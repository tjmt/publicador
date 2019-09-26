#!/bin/bash

source /entrypoint/kubernetes/kubernetesUtils.sh

chechKubernetesFolder
chechKubeconfigPath
convertKompose
kubectlApply