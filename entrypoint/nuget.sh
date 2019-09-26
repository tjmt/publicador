#!/bin/bash

validarParametros(){
    if [[ $NUGET_REGISTRY == "" ]]; then
        >&2 echo "NUGET_REGISTRY is not set!"
        exit 4
    fi

    if [[ $NUGET_USER == "" ]]; then
        >&2 echo "NUGET_USER is not set!"
        exit 4
    fi

    if [[ $NUGET_PASS == "" ]]; then
        >&2 echo "NUGET_PASS is not set!"
        exit 4
    fi
}

#https://docs.microsoft.com/en-us/nuget/reference/cli-reference/cli-ref-pack
sourcesAdd() {
    echo
    echo "-------------------------"
    echo "Nuget sources add"    
    $nuget sources add -Name "nuget-publish" -Source ${NUGET_REGISTRY} -username ${NUGET_USER} -password ${NUGET_PASS} -verbosity normal -ForceEnglishOutput    
    echo "-------------------------"
}

packWithSuffixIfExists() {
    if [[ ${NUGET_LIFECYCLE_VERSION} != "" ]]; then
        echo
        echo "-------------------------"
        echo "LIFECYCLE_VERSION: $NUGET_LIFECYCLE_VERSION"        
        echo
        for file in *.nupkg; 
        do
            #checa se o arquivo realmente existe
            [[ -f "$file" ]] || continue

            unzip -qq $file -d ./temp
            rm $file        
            nuspecFile="$(ls ./temp | grep **.nuspec)"        
            $nuget pack "./temp/$nuspecFile" -suffix ${NUGET_LIFECYCLE_VERSION} -verbosity normal -ForceEnglishOutput
            rm -r ./temp            
        done;
        echo "-------------------------" 
    fi
}

nugetPush() {
    echo
    echo "-------------------------"
    echo "nuget push"
    $nuget push *.nupkg -Source ${NUGET_REGISTRY} -DisableBuffering -Verbosity normal -ForceEnglishOutput
    echo "-------------------------"
}

printPacotesParaPublicacao(){
    echo
    echo "-------------------------"
    echo "Pacotes nuget para publicacao"
    ls . | grep **.nupkg
    echo "-------------------------"
}


if [[ ${NUGET_PACKAGES_FOLDER} == "" ]]; then
    export NUGET_PACKAGES_FOLDER="/var/release/packages/nuget/"
    echo "Set environment variable NUGET_PACKAGES_FOLDER with default value: ${NUGET_PACKAGES_FOLDER}"
fi

echo "Path: ${NUGET_PACKAGES_FOLDER}"
cd ${NUGET_PACKAGES_FOLDER}

printPacotesParaPublicacao
validarParametros
nuget="/usr/bin/mono /usr/local/bin/nuget.exe"
sourcesAdd
packWithSuffixIfExists
nugetPush