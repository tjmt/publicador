clear
##-------------- RELEASE
export TIMEZONE="America/Cuiaba"
export LANGUAGE="pt_BR"
export UNICODE="UTF-8"
export KUBECTL_VERSION="v1.15.4"
export KOMPOSE_VERSION="v1.18.0"
export NUGET_VERSION="latest"
export NODE_VERSION="10.16.3"
export DOCKER_REGISTRY

#------NPM
export NPM_REGISTRY
export NPM_USER
export NPM_PASS
export NPM_EMAIL


#------NUGET
export NUGET_REGISTRY
export NUGET_USER
export NUGET_PASS

export IMAGE_VERSION="1.0.0"
docker-compose -f docker-compose.build.yml build
docker-compose -f docker-compose.build.yml push

export IMAGE_VERSION="latest"
docker-compose -f docker-compose.build.yml build
docker-compose -f docker-compose.build.yml push