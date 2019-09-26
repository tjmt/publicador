#https://dotnet.microsoft.com/learn/dotnet/hello-world-tutorial/install
#https://github.com/NuGet/Home/issues/8433#issue-478154101
FROM ubuntu:18.04 as base

ARG TimeZone="America/Cuiaba"
ARG Language="pt_BR"
ARG Unicode="UTF-8"   

#Precisa configurar o timezone por causa que o mono pede a localidade
RUN ln -snf /usr/share/zoneinfo/$TimeZone /etc/localtime && echo $TimeZone > /etc/timezone

RUN apt-get update && \
    apt-get -y install locales locales-all && \
    apt-get -y install zip && \
    apt-get -y install unzip && \
    apt-get -y install curl && \
    apt-get -y install mono-complete && \
    apt-get -y install apt-transport-https && \
    locale-gen ${Language}.${Unicode} && \ 
    update-locale LANG=${Language}.${Unicode}

ENV LANG ${Language}.${Unicode}
ENV LANGUAGE ${Language}
#------------------------------------------#

ARG NUGET_VERSION=
ARG KUBECTL_VERSION
ARG KOMPOSE_VERSION
ARG NODE_VERSION

#------------------------------------------#
#------------------Node/NPM----------------# 
#https://nodejs.org/en/download/
ARG NODE_FILE_NAME="node-v${NODE_VERSION}-linux-x64.tar.xz"
ARG NODE_URL="https://nodejs.org/dist/v${NODE_VERSION}/${NODE_FILE_NAME}"
RUN echo ${NODE_URL}

RUN curl -sOSL -k ${NODE_URL}
RUN tar -xJf ${NODE_FILE_NAME} -C /usr/local --strip-components=1 --no-same-owner && \
    rm ${NODE_FILE_NAME} && \
    ln -s /usr/local/bin/node /usr/local/bin/nodejs

ENV NODE_TLS_REJECT_UNAUTHORIZED=0 
RUN npm config set strict-ssl false && \
    npm i -g npm-login-noninteractive
#------------------------------------------#


#------------------------------------------#
#------------------kubectl-----------------#
#https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-on-linux
ARG KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
RUN echo ${KUBECTL_URL}
RUN curl -sOSL -k ${KUBECTL_URL}
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
#------------------------------------------#


#------------------------------------------#
#------------------Nuget-------------------#
ARG NUGET_URL="https://dist.nuget.org/win-x86-commandline/${NUGET_VERSION}/nuget.exe"
RUN echo ${NUGET_URL}
RUN curl -o /usr/local/bin/nuget.exe ${NUGET_URL}
#------------------------------------------#


#------------------------------------------#
#------------------kompose-----------------# 
#Customizado TJMT
COPY kompose ./kompose
#Comunidade
#ARG KOMPOSE_URL="https://github.com/kubernetes/kompose/releases/download/${KOMPOSE_VERSION}/kompose-linux-amd64"
#RUN echo ${KOMPOSE_URL}
#RUN curl -sOSL -k ${KOMPOSE_URL} -o kompose

RUN chmod +x ./kompose
RUN mv ./kompose /usr/local/bin/kompose
#------------------------------------------#

FROM base as publicador
ARG DOCKER_REGISTRY
ARG NPM_USER
ARG NPM_PASS
ARG NPM_EMAIL
ARG NPM_REGISTRY
ARG NUGET_REGISTRY
ARG NUGET_USER
ARG NUGET_PASS

ENV DOCKER_REGISTRY=${DOCKER_REGISTRY}
ENV NPM_USER=${NPM_USER}
ENV NPM_PASS=${NPM_PASS}
ENV NPM_EMAIL=${NPM_EMAIL}
ENV NPM_REGISTRY=${NPM_REGISTRY}
ENV NUGET_REGISTRY=${NUGET_REGISTRY}
ENV NUGET_USER=${NUGET_USER}
ENV NUGET_PASS=${NUGET_PASS}

WORKDIR /entrypoint
COPY ./entrypoint /entrypoint

RUN chmod +x entrypoint.sh \
    nuget.sh \
    npm.sh \
    maven.sh \
    kubernetes/createKubernetesEnvironment.sh \
    kubernetes/destroyKubernetesEnvironment.sh \
    kubernetes/kubernetesUtils.sh
             
WORKDIR /var/release/

CMD ["/entrypoint/entrypoint.sh"]