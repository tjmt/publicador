clear
##-------------- RELEASE
export TIMEZONE="America/Cuiaba"
export LANGUAGE="pt_BR"
export UNICODE="UTF-8"
export KUBECTL_VERSION="v1.15.4"
export KOMPOSE_VERSION="v1.18.0"
export NUGET_VERSION="latest"
export NODE_VERSION="10.16.3"


export IMAGE_VERSION="latest"
docker-compose -f docker-compose.build.yml build && docker-compose -f docker-compose.build.yml push