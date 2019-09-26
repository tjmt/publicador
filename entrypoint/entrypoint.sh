#!/bin/bash

echo "Iniciando entrypoint do publicador"

if [[ ${DEPLOY_NUGET} == "true" ]]; then
    echo
    echo
    echo "----------------------------------NUGET------------------------------------------"
    /entrypoint/nuget.sh
    echo "---------------------------------------------------------------------------------"
fi


if [[ ${DEPLOY_NPM} == "true" ]]; then    
    echo
    echo
    echo "----------------------------------NPM---------------------------------------------"
    /entrypoint/npm.sh
    echo "---------------------------------------------------------------------------------"
fi

if [[ ${DEPLOY_MAVEN} == "true" ]]; then
    echo
    echo
    echo "----------------------------------MAVEN------------------------------------------"
    /entrypoint/maven.sh
    echo "---------------------------------------------------------------------------------"
fi


if [[ ${DEPLOY_KUBERNETES} == "true" ]]; then
    echo
    echo
    echo "----------------------------------KUBERNETES-------------------------------------"
    /entrypoint/kubernetes/createKubernetesEnvironment.sh
    echo "---------------------------------------------------------------------------------"
fi

if [[ ${DESTROY_KUBERNETES_ENVIRONMENT} == "true" ]]; then
    echo
    echo
    echo "----------------------------------DESTROY_KUBERNETES_ENVIRONMENT-----------------"
    /entrypoint/kubernetes/destroyKubernetesEnvironment.sh
    echo "---------------------------------------------------------------------------------"
fi