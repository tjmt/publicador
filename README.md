# Usage

## docker-compose up
```sh
docker-compose -f docker-compose.yml up --abort-on-container-exit
docker-compose -f docker-compose.yml down -v
```

<details>
  <summary>Kubernetes</summary>

### Descrição das variaveis de ambiente
- **DEPLOY_KUBERNETES:** Indica se irá rodar o script que publica os yaml no Kubernetes (`kubectl apply`) 
- **DESTROY_KUBERNETES_ENVIRONMENT:** Indica se irá rodar o script que deleta os yaml no Kubernetes (`kubectl delete`)
- **KUBERNETES_FOLDER:** Caminho dos arquivos yaml para publicação (Default: `/var/release/source`)
- **KUBECONFIG_PATH:** Caminho do kubeconfig para publicação (Default: `/var/release/source/kubeconfig`)
- **COMPOSE_PATH:** Caso deseja utilizar Kompose para converter yml em yaml, informar o caminho completo do docker-compose a ser transformado.

### Obs:
- Para publicar os yaml no kubernetes, usar `DEPLOY_KUBERNETES:true`
- Para excluir os yaml no kubernetes, usar `DESTROY_KUBERNETES_ENVIRONMENT:true`

```yml
version: '3.5'
services:
  sistema-release:
    image: publicador:latest
    environment:      
      DEPLOY_KUBERNETES: ${DEPLOY_KUBERNETES}
      DESTROY_KUBERNETES_ENVIRONMENT: ${DESTROY_KUBERNETES_ENVIRONMENT}
      KUBERNETES_FOLDER: ${KUBERNETES_FOLDER}
      KUBECONFIG_PATH: ${KUBECONFIG_PATH}
      COMPOSE_PATH: ${COMPOSE_PATH}
    volumes:
      - ./exemplos/kubernetes:/var/release/source
```

</details>


<details>
  <summary>Nuget</summary>

### Descrição das variaveis de ambiente
- **DEPLOY_NUGET:** Indica se irá rodar o script que publica pacotes nuget
- **NUGET_LIFECYCLE_VERSION:** Life cycle do pacote Nuget
- **NUGET_REGISTRY:** Registry para publicação do pacote nuget
- **NUGET_USER:** Usuário do registry
- **NUGET_PASS:** Senha do registry


```yml
version: '3.5'
services:
  sistema-release:
    image: publicador:latest
    environment:
      DEPLOY_NUGET: ${DEPLOY_NUGET}
      NUGET_LIFECYCLE_VERSION: ${NUGET_LIFECYCLE_VERSION}
      NUGET_REGISTRY: ${NUGET_REGISTRY}
      NUGET_USER: ${NUGET_USER}
      NUGET_PASS: ${NUGET_PASS}
    volumes:
      - ./exemplos/nuget:/var/release/packages/nuget
```
</details>

<details>
  <summary>NPM</summary>

### Descrição das variaveis de ambiente
- **DEPLOY_NPM:** Indica se irá rodar o script que publica pacotes NPM
- **NPM_LIFECYCLE_VERSION:** Life cycle do pacote NPM
- **NPM_REGISTRY:** Registry para publicação do pacote NPM
- **NPM_USER:** Usuário do registry
- **NPM_PASS:** Senha Usuário do registry
- **NPM_EMAIL:** Email para login do registry

```yml
version: '3.5'

services:
  sistema-release:
    image: publicador:latest
    environment:
      DEPLOY_NPM: ${DEPLOY_NPM}
      NPM_LIFECYCLE_VERSION: ${NPM_LIFECYCLE_VERSION}
      NPM_REGISTRY: ${NPM_REGISTRY}
      NPM_USER: ${NPM_USER}
      NPM_PASS: ${NPM_PASS}
      NPM_EMAIL: ${NPM_EMAIL} 
    volumes:
      - ./exemplos/npm:/var/release/packages/npm
```
</details>

<details>
  <summary>Maven</summary>

#TODO

</details>  