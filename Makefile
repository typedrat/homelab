SECRETS_YAML = talos/secrets.yaml
CONFIG_PATCHES = $(wildcard talos/patches/*.yaml)
ISERLOHN_CONFIG = talos/rendered/iserlohn.yaml
ISERLOHN_NODE ?= iserlohn.lan
ISERLOHN_PATCH = talos/nodes/iserlohn.yaml
ISERLOHN_PORT ?= 6443

TALOS_SCHEMATIC = talos/schematic.yaml
TALOS_VERSION = v1.9.2
TALOS_PLATFORM = metal
TALOS_ARCH = amd64
TALOS_SECUREBOOT = true

SCHEMATIC_HASH := $(shell curl -sX POST --data-binary @$(TALOS_SCHEMATIC) https://factory.talos.dev/schematics | jq -r '.id')
TALOS_ISO_URL_ROOT = https://factory.talos.dev/image/$(SCHEMATIC_HASH)/$(TALOS_VERSION)
TALOS_ISO_URL = $(TALOS_ISO_URL_ROOT)/$(TALOS_PLATFORM)-$(TALOS_ARCH)$(if $(TALOS_SECUREBOOT),-secureboot,).iso
TALOS_ISO = talos/talos-$(TALOS_VERSION)-$(TALOS_PLATFORM)-$(TALOS_ARCH)$(if $(TALOS_SECUREBOOT),-secureboot,).iso

.PHONY: iserlohn-apply-init iserlohn-apply-patches bootstrap cilium flux

define newline


endef

$(TALOS_ISO): $(TALOS_SCHEMATIC)
	@echo "Downloading $(TALOS_ISO) -- make a live USB and boot it when done"
	@curl $(TALOS_ISO_URL) -o $(TALOS_ISO)

talos-iso: $(TALOS_ISO)

$(ISERLOHN_CONFIG): $(CONFIG_PATCHES) $(ISERLOHN_PATCH) $(SECRETS_YAML) $(TALOS_ISO) $(TALOS_SCHEMATIC)
	@talosctl gen config \
		--output $(ISERLOHN_CONFIG) \
		--output-types controlplane \
		--with-cluster-discovery=false \
		--with-secrets=$(SECRETS_YAML) \
		$(foreach patch,$(CONFIG_PATCHES),--config-patch @$(patch) \$(newline)) \
		--config-patch @$(ISERLOHN_PATCH) \
		ginga-teikoku https://$(ISERLOHN_NODE):$(ISERLOHN_PORT) \
		--install-image "factory.talos.dev/installer$(if $(TALOS_SECUREBOOT),-secureboot,)/$(SCHEMATIC_HASH):$(TALOS_VERSION)" \
		--force

iserlohn: $(ISERLOHN_CONFIG)

iserlohn-apply-init: iserlohn
	@talosctl apply-config \
		--insecure \
		-n iserlohn.lan \
		-f $(ISERLOHN_CONFIG)

UNPATCHABLE := (talos/patches/encrypt-fs.yaml talos/patches/rotate-server-certificates.yaml)
PATCHABLE_PATCHES := $(filter-out $(UNPATCHABLE),$(CONFIG_PATCHES))

iserlohn-apply-patches: $(PATCHABLE_PATCHES) $(ISERLOHN_PATCH)
	$(foreach patch,$^, \
		@echo "Applying $(patch): " $(newline) \
		@talosctl patch mc --patch-file $(patch) 2>&1 | sed 's/^/    /' $(newline) \
	)

bootstrap:
	@talosctl bootstrap

cilium:
	@if [ -z "$(KUBERNETES_API_SERVER_ADDRESS)" ] || [ -z "$(KUBERNETES_API_SERVER_PORT)" ]; then \
		echo "Error: KUBERNETES_API_SERVER_ADDRESS and KUBERNETES_API_SERVER_PORT must be set."; \
		exit 1; \
	fi
	@helm install                                                   \
		cilium                                                      \
		cilium/cilium                                               \
		--wait --timeout
		--version 1.16.6                                            \
		--namespace kube-system                                     \
		--set ipam.mode=kubernetes                                  \
		--set hostFirewall.enabled=true                             \
		--set hubble.relay.enabled=true                             \
		--set hubble.ui.enabled=true                                \
		--set kubeProxyReplacement=true                             \
		--set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
		--set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
		--set cgroup.autoMount.enabled=false                        \
		--set cgroup.hostRoot=/sys/fs/cgroup                        \
		--set k8sServiceHost="$(KUBERNETES_API_SERVER_ADDRESS)"     \
		--set k8sServicePort="$(KUBERNETES_API_SERVER_PORT)"        \
		--set bgpControlPlane.enabled=true
	@echo -n "Waiting for Cilium to be ready..."
	@until cilium status | grep OK | wc -l | grep 4 > /dev/null; do \
		echo -n "."; \
		sleep 10; \
	done
	@echo

flux:
	@if [ -z "$(GITHUB_TOKEN)" ]; then \
		echo "Error: GITHUB_TOKEN must be set."; \
		exit 1; \
	fi
	@kubectl create ns flux-system
	@cat age.agekey | kubectl create secret generic sops-age --namespace=flux-system --from-file=age.agekey=/dev/stdin
	@flux bootstrap github                                               \
		--token-auth=false                                               \
		--owner=typedrat                                                 \
		--repository=homelab                                             \
		--branch=master                                                  \
		--path=clusters/ginga-teikoku                                    \
		--personal

.DEFAULT_GOAL := help
help:
	@echo "You must specify a target. Available targets are:"
	@echo "    iserlohn  - Build the node configuration file for 'iserlohn'"
	@echo "    iserlohn-apply - Apply the node configuration to 'iserlohn'"
	@echo "    bootstrap      - Bootstrap the Talos cluster"
	@echo "    cilium         - Install the Cilium CNI"
	@echo "    flux           - Install the Flux GitOps tool"
