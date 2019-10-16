#!/bin/bash

chechKubernetesFolder(){
  if [[ ${KUBERNETES_FOLDER} == "" ]]; then
    export KUBERNETES_FOLDER="/var/release/source/"
    echo "Set environment variable KUBERNETES_FOLDER with default value: ${KUBERNETES_FOLDER}"
  fi;

  cd ${KUBERNETES_FOLDER}
}


chechKubeconfigPath(){
  if [[ ${KUBECONFIG_PATH} == "" ]]; then
    export KUBECONFIG_PATH="${KUBERNETES_FOLDER}kubeconfig"
    echo "Set environment variable KUBECONFIG_PATH with default value: ${KUBECONFIG_PATH}"
  fi;

  if [[ ! -f ${KUBECONFIG_PATH} ]]; then
      echo "Lista de kubeconfig disponíveis:"
      ls /entrypoint/kubernetes/kubeconfig/
      >&2 echo "kubeconfig nao encontrado. (${KUBECONFIG_PATH})"
      exit 4
  fi
}

convertKompose(){
  #Se foi informado usar kompose
  if [[ ${COMPOSE_PATH} != "" ]]; then
    echo
    echo
    echo "-------------------------"
    echo "Kompose convert"
    echo

    if [[ -f $COMPOSE_PATH ]]; then
        echo "Arquivo yml para conversao:  $COMPOSE_PATH"
        /usr/local/bin/kompose convert -f $COMPOSE_PATH      
    else
        >&2 echo "Arquivo $COMPOSE_PATH não encontrado"
        exit 4    
    fi;

    echo "-------------------------"
  fi;  
}

kubectlApply(){

  echo
  echo "-------------------------"
  echo "kubectl apply"
  echo
  
  for file in *-namespace.yaml;
  do
    [[ -f $file ]] || continue
    kubectl --kubeconfig ${KUBECONFIG_PATH} apply -f $file
  done;

  for file in *.yaml;
  do
    [[ -f $file ]] || continue
    kubectl --kubeconfig ${KUBECONFIG_PATH} apply -f $file
  done;  
  echo "-------------------------"
}

kubectlDelete(){
  echo
  echo "-------------------------"
  echo "kubectl delete"
  echo 
 
  #Deletando o namespace, deleta tudo
  for file in *-namespace.yaml;
  do
    [[ -f $file ]] || continue
    kubectl --kubeconfig ${KUBECONFIG_PATH} delete -f $file --grace-period=0 --force
    exit 0;
  done;  
  echo "-------------------------"
}