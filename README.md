
# Vagrantfile and Scripts to Automate Kubernetes with Cilium setup using Kubeadm

The purpose of this repo is to create a demo/verification environment for Kubernetes with Cilium on Apple Silicon Macs with Darwin OS. It leverages Vagrant and Parallels as a virtual machine host provider.

This repo is based on the work found in:
 * https://github.com/ahmadjubair33/vagrant-kubernetes
 * https://computingforgeeks.com/install-kubernetes-cluster-ubuntu-jammy/
 * https://app.vagrantup.com/jharoian3/boxes/ubuntu-22.04-arm64


## Preparation

Install Parallels, Vagrant and the Parallels provider plugin:

```
% brew install --cask vagrant
...
% vagrant plugin install vagrant-parallels
...
% vagrant plugin list
vagrant-parallels (2.2.5, global)
  - Version Constraint: > 0
```

## The architecture of the solution

The infrastructure that is being deployed consists of:

 * one control-plane node; untainted so it can be use also as a worker
 * two dedicated worker nodes
 * no-kube-proxy Cillium installation

## Run it

To invoke the creation of the said infraastructure do

```
% vagrant up
...

```

After the successful completion the cluster is accessible as follows:
```
% export KUBECONFIG=$PWD/config/config
% kubectl get nodes
```

Install the cilium tools with brew, verify it is operational and connect to the Hubble UI in your browser.
```
% brew install cilium-cli
% cilium status
    /¯¯\
 /¯¯\__/¯¯\    Cilium:         OK
 \__/¯¯\__/    Operator:       OK
 /¯¯\__/¯¯\    Hubble:         OK
 \__/¯¯\__/    ClusterMesh:    disabled
    \__/

DaemonSet         cilium             Desired: 3, Ready: 3/3, Available: 3/3
Deployment        hubble-relay       Desired: 1, Ready: 1/1, Available: 1/1
Deployment        hubble-ui          Desired: 1, Ready: 1/1, Available: 1/1
Deployment        cilium-operator    Desired: 2, Ready: 2/2, Available: 2/2
Containers:       hubble-ui          Running: 1
                  cilium-operator    Running: 2
                  cilium             Running: 3
                  hubble-relay       Running: 1
Cluster Pods:     4/4 managed by Cilium
Image versions    cilium             quay.io/cilium/cilium:v1.12.3@sha256:30de50c4dc0a1e1077e9e7917a54d5cab253058b3f779822aec00f5c817ca826: 3
                  hubble-relay       quay.io/cilium/hubble-relay:v1.12.3@sha256:320dff9389e3fc6e2d33863510d497e8bcf245a5755236ae466a0729cc656a79: 1
                  hubble-ui          quay.io/cilium/hubble-ui:v0.9.2@sha256:d3596efc94a41c6b772b9afe6fe47c17417658956e04c3e2a28d293f2670663e: 1
                  hubble-ui          quay.io/cilium/hubble-ui-backend:v0.9.2@sha256:a3ac4d5b87889c9f7cc6323e86d3126b0d382933bd64f44382a92778b0cde5d7: 1
                  cilium-operator    quay.io/cilium/operator-generic:v1.12.3@sha256:816ec1da586139b595eeb31932c61a7c13b07fb4a0255341c0e0f18608e84eff: 2
% cilium hubble ui
ℹ️  Opening "http://localhost:12000" in your browser...
```

In another console run the connectivity test and switch to the Hublle UI. Monitor the `cilium-test` namespace for the tests execution.
```
% export KUBECONFIG=$PWD/config/config
% cilium connectivity test
```
