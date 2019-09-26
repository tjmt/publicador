#!/bin/bash

if [[ ${MAVEN_PACKAGES_FOLDER} == "" ]]; then
    export MAVEN_PACKAGES_FOLDER="/var/release/packages/maven/"
    echo "Set environment variable MAVEN_PACKAGES_FOLDER with default value: ${MAVEN_PACKAGES_FOLDER}"
fi