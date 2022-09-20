#!/bin/bash

use="$0 : Invalid use\nUse : $0 [create | set | add | run] (add and run not done yet)"

if [ -z "$1" ]; then
    echo -e $use
    exit 0
fi

if [ $1 == "create" ]; then
    use="$0 create : Invalid use\nUse : $0 create {project name}"

    if [ -z "$2" ]; then
        echo -e $use
        exit 0
    fi

    echo "$(tput setaf 3)Creating project '$2' $(tput setaf 7)"
    mkdir $2
    cd $2
    mkdir load
    cd load
    git clone https://github.com/TotoroGaming/edb.git
    cd edb
    find . -type d -not -name 'templates' -delete
    find . -maxdepth 1 -type f -delete
    cd templates
    find . -type d -not -name 'init' -delete
    find . -maxdepth 1 -type f -delete

    cd ../../../
    mv ./load/edb/templates/init/* .
    rm -rf ./load
    cd edb
    echo "$(jq --arg projectName $2 '.project.name = $projectName' infos.json)" >infos.json
    cd ../../
    echo "$(tput setaf 2)Project created! $(tput setaf 7)Use the '$0 set' command to change the bot options or use '$0 run' to run the bot!"

elif [ $1 == "set" ]; then
    use="$0 set : Invalid use\nUse : $0 set [token | project | botstatus] {value}"

    if [ -z "$2" ]; then
        echo -e $use
        exit 0
    elif [ ! -e ./edb/infos.json ]; then
        echo "$(tput setaf 1)The current directory is not a EDB project! ('./edb/infos.json' not fount) $(tput setaf 7)"
        exit 0
    fi

    if [ $2 == "token" ]; then
        if [ -z "$3" ]; then
            echo -e $use
            exit 0
        fi
        
        echo "$(tput setaf 3)Changing token value...$(tput setaf 7)"
        echo "$(jq --arg token $3 '.token = $token' ./edb/infos.json)" > ./edb/infos.json
        echo "$(tput setaf 2)Token value successfuly changed! $(tput setaf 7)"

    elif [ $2 == "project" ]; then
        echo "$(tput setaf 6)Enter the new settings (leave blank for no change)$(tput setaf 7)"
        printf "$(tput setaf 3)Please enter the new project name$(tput setaf 7): "
        read -r projName
        if [ "$projName" == "" ]; then projName="$(jq '.project.name' ./edb/infos.json)"; fi

        printf "$(tput setaf 3)Please enter the new project description$(tput setaf 7): "
        read -r projDesc
        if [ "$projDesc" == "" ]; then projDesc="$(jq '.project.description' ./edb/infos.json)"; fi

        printf "$(tput setaf 3)Please enter the new project author$(tput setaf 7): "
        read -r projAuth
        if [ "$projAuth" == "" ]; then projAuth="$(jq '.project.author' ./edb/infos.json)"; fi

        echo ""

        echo "$(tput setaf 3)Changing project values...$(tput setaf 7)"
        echo "$(jq --arg projName $projName --arg projDesc $projDesc --arg projAuth $projAuth '.project + {name:"$projName", description:"$projDesc", author:"$projAuth"}' ./edb/infos.json)" > ./edb/infos.json
        echo "$(tput setaf 2)Token value successfuly changed! $(tput setaf 7)"

    elif [ $2 == "botstatus" ]; then
        echo "not done yet :'("
    else
        echo -e $use
        exit 0
    fi

fi
