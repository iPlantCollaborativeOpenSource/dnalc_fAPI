#!/bin/bash

if [[ !  ]];then
    read -p "iPlant username: " USER
fi

if [[ ! $TOKEN ]];then
    read -s -p "iPlant password: " TOKEN
fi

JSON=$1

if ! [[ -n $JSON ]]; then
    read -p "JSON File: " JSON
fi

echoerr() { echo "$@" 1>&2; }

if [[  ]] && [[ $TOKEN ]] && [[ $JSON ]]; 
then
    echoerr "Hello ${USER}. I will now install $JSON."
    curl -X POST -sku ":$TOKEN" -F "fileToUpload=@$JSON" https://foundation.iplantc.org/apps-v1/apps/ |json_xs -f json
else
    echoerr "You must provide a username, password, and JSON file name!"
fi

