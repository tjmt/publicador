clear
##-------------- RELEASE
export TIMEZONE="America/Cuiaba"
export LANGUAGE="pt_BR"
export UNICODE="UTF-8"
export KUBECTL_VERSION="v1.16.0"
export KOMPOSE_VERSION="v1.19.0"
export NUGET_VERSION="latest"
export NODE_VERSION="10.17.0"

export IMAGE_VERSION="1.0"
docker-compose -f docker-compose.build.yml build
docker tag tjmt/publicador:$IMAGE_VERSION tjmt/publicador:$(echo $IMAGE_VERSION | sed 's/.\{2\}$//')
docker tag tjmt/publicador:$IMAGE_VERSION tjmt/publicador:latest
docker push tjmt/publicador