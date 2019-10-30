#https://github.com/NuGet/Home/issues/8433#issue-478154101
FROM ubuntu:18.04 as base

#https://askubuntu.com/questions/91543/apt-get-update-fails-to-fetch-files-temporary-failure-resolving-error
RUN echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null

ARG TimeZone
ARG Language
ARG Unicode

RUN ln -snf /usr/share/zoneinfo/$TimeZone /etc/localtime && echo $TimeZone > /etc/timezone

RUN apt-get update && \
    apt-get -y install locales locales-all && \
    apt-get -y install zip && \
    apt-get -y install unzip && \
    apt-get -y install curl && \
    apt-get -y install apt-transport-https && \
    locale-gen ${Language}.${Unicode} && \ 
    update-locale LANG=${Language}.${Unicode}

ENV LANG ${Language}.${Unicode}
ENV LANGUAGE ${Language}

RUN apt-get -y install mono-complete
#------------------------------------------#

ARG NUGET_VERSION
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
#https://github.com/kubernetes/kompose/releases/
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