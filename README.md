# homelab

This stores the configuration for my personal homelab machines.

More documentation will be added as I migrate my systems over to my new (circa January 2025) infrastructure.

## Standing up the cluster

I've created a [`Makefile`](/Makefile) that helps automate some of the process of standing up a node.

```shell
# Build the configuration:
$ make iserlohn
# With iserlohn in Maintenance mode:
$ make iserlohn-apply
# After first boot:
$ make bootstrap
$ make cilium
$ make flux
```

I currently can't figure out a good way to make it more automated than that without requiring a lot more work, since many of the commands involved do not provide an easy way to wait for their action to complete after they dispatch work to the cluster, so for now it is fundamentally a hands-on process where the user must watch the output from Talos' dashboard and Kubernetes itself to know when to continue.
