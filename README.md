# Usage

## docker build
`docker-compose -f .\docker-compose.build.yml build`


### Kubernetes
- `docker-compose -f docker-compose.cd-release-kubernetes.yml up --build --abort-on-container-exit`
- `docker-compose -f docker-compose.cd-release-kubernetes.yml down -v`
```yml
version: '3.5'

services:
  sistema-release:
    image: nexusdocker.tjmt.jus.br/dsa/publisher:latest
    environment:
      DOCKER_REGISTRY: ${DOCKER_REGISTRY:-nexusdocker.tjmt.jus.br/dsa/teste/}
      VERSION: ${VERSION:-latest}
      BRANCH: ${BRANCH:-develop}
      ENVIRONMENT: ${ENVIRONMENT:-override}      
    volumes:
      - ./exemplos/kubernetes:/var/run/kubernetes
```


### Nuget
- `docker-compose -f docker-compose.cd-release-nuget.yml up --build --abort-on-container-exit`
- `docker-compose -f docker-compose.cd-release-nuget.yml down -v`
```yml
version: '3.5'

services:
  sistema-release:
    image: nexusdocker.tjmt.jus.br/dsa/publisher:latest
    environment:
      NUGET_LIFE_CICLE_VERSION: ${NUGET_LIFE_CICLE_VERSION:-local}
      NUGET_USER: ${NUGET_USER:-admin}
      NUGET_PASS: ${NUGET_PASS:-admin}
      NUGET_REGISTRY: ${NUGET_REGISTRY:-http://nuget.tjmt.jus.br/repository/nuget-hosted/}
    volumes:
      - ./exemplos/nuget:/var/run/packages
```


### NPM
- `docker-compose -f docker-compose.cd-release-npm.yml up --build --abort-on-container-exit`
- `docker-compose -f docker-compose.cd-release-npm.yml down -v`
```yml
version: '3.5'

services:
  sistema-release:
    image: nexusdocker.tjmt.jus.br/dsa/publisher:latest
    environment:
      NPM_LIFE_CICLE_VERSION: ${NPM_LIFE_CICLE_VERSION:-local}
      NPM_USER: ${NPM_USER:-admin}
      NPM_PASS: ${NPM_PASS:-admin}
      NPM_EMAIL: ${NPM_EMAIL:-cerberus@tjmt.jus.br}
      NPM_REGISTRY: ${NPM_REGISTRY:-http://npm.tjmt.jus.br/repository/npm-hosted/}      
    volumes:
      - ./exemplos/npm:/var/run/packages
```