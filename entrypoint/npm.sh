#!/bin/bash

validarParametros(){
    if [[ $NPM_REGISTRY == "" ]]; then
        >&2 echo "NPM_REGISTRY is not set!"
        exit 4
    fi

    if [[ $NPM_USER == "" ]]; then
        >&2 echo "NPM_USER is not set!"
        exit 4
    fi

    if [[ $NPM_PASS == "" ]]; then
        >&2 echo "NPM_PASS is not set!"
        exit 4
    fi

    if [[ $NPM_EMAIL == "" ]]; then
        >&2 echo "NPM_EMAIL is not set!"
        exit 4
    fi    
}

npmPackWithLifeCicleIfExists() {
    mkdir -p ${NPM_PACKAGES_FOLDER}publish/

    if [[ $NPM_LIFECYCLE_VERSION != "" ]]; then
        echo
        echo "-------------------------"
        echo "LIFECYCLE_VERSION: $NPM_LIFECYCLE_VERSION"
        echo
        for file in *.tgz; 
        do
            #checa se o arquivo realmente existe
            [[ -f "$file" ]] || continue

            echo "tar zxf file: $file"
            mkdir -p ${NPM_PACKAGES_FOLDER}temp/
            tar zxf $file -C ${NPM_PACKAGES_FOLDER}temp/
                        
            cd ${NPM_PACKAGES_FOLDER}temp/package
            currentVersion=$(node -p "require('./package.json').version")
            newVersion=$currentVersion-$NPM_LIFECYCLE_VERSION

            echo
            echo
            echo "currentVersion: $currentVersion"
            
            npm version $newVersion --loglevel error           
            npm pack --loglevel error
            
            mv *.tgz ${NPM_PACKAGES_FOLDER}publish/
            rm -rf ${NPM_PACKAGES_FOLDER}temp/
        done;
        echo "-------------------------" 
    else
        cp ${NPM_PACKAGES_FOLDER}*.tgz ${NPM_PACKAGES_FOLDER}publish/
    fi    
}

npmPublish() {    
    echo
    echo "-------------------------"
    echo "npm publish"
    cd ${NPM_PACKAGES_FOLDER}publish/
    for file in *.tgz; 
    do
        #checa se o arquivo realmente existe
        [[ -f "$file" ]] || continue        
        npm publish $file --loglevel error
    done;
    rm -rf ${NPM_PACKAGES_FOLDER}publish/    
    echo "-------------------------"
}

printPacotesParaPublicacao(){
    echo
    echo "-------------------------"
    echo "Pacotes npm para publicacao"
    ls . | grep **.tgz
    echo "-------------------------"
}

npmLogin(){
    echo
    echo "-------------------------"
    echo "npm-login-noninteractive"
    npm-login-noninteractive
    echo "-------------------------"
}

#https://docs.npmjs.com/cli-documentation/
#https://www.npmjs.com/package/npm-login-noninteractive

if [[ ${NPM_PACKAGES_FOLDER} == "" ]]; then
    export NPM_PACKAGES_FOLDER="/var/release/packages/npm/"
    echo "Set environment variable NPM_PACKAGES_FOLDER with default value: ${NPM_PACKAGES_FOLDER}"
fi

echo "Path: ${NPM_PACKAGES_FOLDER}"
cd ${NPM_PACKAGES_FOLDER}

printPacotesParaPublicacao
validarParametros
npmLogin
npmPackWithLifeCicleIfExists
npmPublish || true