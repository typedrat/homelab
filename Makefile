SECRETS_YAML = talos/secrets.yaml
CONFIG_PATCHES = $(wildcard talos/patches/*.yaml)
ISERLOHN_CONFIG = talos/rendered/iserlohn.yaml
ISERLOHN_NODE ?= iserlohn.lan
ISERLOHN_PATCH = talos/nodes/iserlohn.yaml
ISERLOHN_PORT ?= 6443

.PHONY: iserlohn-apply bootstrap cilium flux

$(ISERLOHN_CONFIG): $(CONFIG_PATCHES) $(ISERLOHN_PATCH) $(SECRETS_YAML)
	talosctl gen config \
		--output $(ISERLOHN_CONFIG) \
		--output-types controlplane \
		--with-cluster-discovery=false \
		--with-secrets=$(SECRETS_YAML) \
		$(foreach patch,$(CONFIG_PATCHES),--config-patch @$(patch) ) \
		--config-patch @$(ISERLOHN_CONFIG) \
		ginga-teikoku https://$(ISERLOHN_NODE):$(ISERLOHN_PORT) \
		--force

iserlohn: $(ISERLOHN_CONFIG)

iserlohn-apply: iserlohn
	talosctl apply-config \
		--insecure \
		-n iserlohn.lan \
		-f $(ISERLOHN_CONFIG)

bootstrap:
	talosctl bootstrap

cilium:
	@if [ -z "$(KUBERNETES_API_SERVER_ADDRESS)" ] || [ -z "$(KUBERNETES_API_SERVER_PORT)" ]; then \
		echo "Error: KUBERNETES_API_SERVER_ADDRESS and KUBERNETES_API_SERVER_PORT must be set."; \
		exit 1; \
	fi
	helm install                                                    \
		cilium                                                      \
		cilium/cilium                                               \
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

flux:
	@if [ -z "$(GITHUB_TOKEN)" ]; then \
		echo "Error: GITHUB_TOKEN must be set."; \
		exit 1; \
	fi
	flux bootstrap github                                                \
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
