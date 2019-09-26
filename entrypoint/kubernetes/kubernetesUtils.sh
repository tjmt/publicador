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
      echo "kubeconfig nao encontrado. (${KUBECONFIG_PATH})"      
      echo "Lista de kubeconfig disponíveis:"
      ls /entrypoint/kubernetes/kubeconfig/
  fi
}

convertKompose(){
  komposeFile="docker-compose.${KOMPOSE_ENVIRONMENT}.yml"

  echo
  echo
  echo "-------------------------"
  echo "Kompose convert"
  echo

  if [[ -f $komposeFile ]]; then
      echo "Arquivo yml para conversao:  $komposeFile"
      /usr/local/bin/kompose convert -f $komposeFile      
  else
      >&2 echo "Arquivo $komposeFile não encontrado"
      exit 4    
  fi;

  echo "-------------------------"
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