#!/bin/bash
# Create, manage or run your EDB project to create the best Discord bot!
#
# Usage:
#       edb
#           [ create {project name} ]
#           [ set [token | project | botstatus] {value} ]
#           [ add [ command | event ] {name} ]
#           [ run {SOON} ]

use="edb : Invalid use\nUse : edb [create | set | add | run]"

if [ -z "$1" ]; then
    echo -e $use
    exit 1
fi

if [ $1 == "create" ]; then
    use="edb create : Invalid use\nUse : edb create {project name}"

    if [ -z "$2" ]; then
        echo -e $use
        exit 1
    fi

    echo "$(tput setaf 3)Creating project '$2' $(tput setaf 7)"
    mkdir $2
    cd $2
    mkdir load
    cd load
    git clone https://github.com/KodeurKubik/edb.git
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
    cd ../
    npm install
    cd ../
    echo "$(tput setaf 2)Project created! $(tput setaf 7)Use the '$0 set' command to change the bot options or use '$0 run' to run the bot!"

elif [ $1 == "set" ]; then
    use="edb set : Invalid use\nUse : edb set [token {new token} | project | botstatus]"

    if [ -z "$2" ]; then
        echo -e $use
        exit 1
    elif [ ! -e ./edb/infos.json ]; then
        echo "$(tput setaf 1)The current directory is not a EDB project! ('./edb/infos.json' not found) $(tput setaf 7)"
        exit 1
    fi

    if [ $2 == "token" ]; then
        if [ -z "$3" ]; then
            echo -e $use
            exit 1
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
        jq ".project.name = \"$projName\"" < ./edb/infos.json > temp.json && mv temp.json ./edb/infos.json
        jq ".project.description = \"$projDesc\"" < ./edb/infos.json > temp.json && mv temp.json ./edb/infos.json
        jq ".project.author = \"$projAuth\"" < ./edb/infos.json > temp.json && mv temp.json ./edb/infos.json

        echo "$(tput setaf 2)Project value(s) successfuly changed! $(tput setaf 7)"

    elif [ $2 == "botstatus" ]; then
        echo "$(tput setaf 6)Enter the new settings (leave blank for no change)$(tput setaf 7)"
        printf "$(tput setaf 3)Please enter the new bot status$(tput setaf 7): "
        read -r statusName
        if [ "$statusName" == "" ]; then statusName="$(jq '.status.name' ./edb/infos.json)"; fi

        echo "$(tput setaf 6)Status types:$(tput setaf 7) Playing: 0 | Listening: 2 | Watching: 3"
        printf "$(tput setaf 3)Please enter the new bot status type$(tput setaf 7): "
        read -r statusType
        if [ "$statusType" == "" ]; then statusType="$(jq '.status.type' ./edb/infos.json)"; fi

        echo ""

        echo "$(tput setaf 3)Changing project values...$(tput setaf 7)"
        jq ".status.name = \"$statusName\"" < ./edb/infos.json > temp.json && mv temp.json ./edb/infos.json
        jq ".status.type = \"$statusType\"" < ./edb/infos.json > temp.json && mv temp.json ./edb/infos.json
        echo "$(tput setaf 2)Status value(s) successfuly changed! $(tput setaf 7)"

    else
        echo -e $use
        exit 1
    fi

elif [ $1 == "run" ]; then

    if [ ! -e ./edb/infos.json ]; then
        echo "$(tput setaf 1)The current directory is not a EDB project! ('./edb/infos.json' not found) $(tput setaf 7)"
        exit 1
    fi

    npm run bot

elif [ $1 == "add" ]; then
    use="edb add : Invalid use\nUse : edb add [command | event] {name}"

    if [ -z "$2" ]; then
        echo -e $use
        exit 1
    elif [ ! -e ./edb/infos.json ]; then
        echo "$(tput setaf 1)The current directory is not a EDB project! ('./edb/infos.json' not found) $(tput setaf 7)"
        exit 1
    elif [ -z "$3" ]; then
        echo -e $use
        exit 1
    fi


    if [ $2 == "command" ]; then
        if [ -f "./commands/$3.js" ] && [ -s "./commands/$3.js" ]; then
            echo "$(tput setaf 1)The '$3.js' file already exists and is not empty! $(tput setaf 7)"
            exit 1
        fi

        if [ "$(curl -s "https://raw.githubusercontent.com/KodeurKubik/edb/main/templates/commands/$3.js")" == "404: Not Found" ]; then
            echo "$(tput setaf 1)Command not found in the github commands! $(tput setaf 7) See here for all commands: https://github.com/KodeurKubik/edb/tree/main/templates/commands"
            exit 1
        fi

        curl "https://raw.githubusercontent.com/KodeurKubik/edb/main/templates/commands/$3.js" > "./commands/$3.js"
        echo "$(tput setaf 2)Command '$3' successfully added! $(tput setaf 7)"

    elif [ $2 == "event" ]; then
        if [ -f "./events/$3.js" ] && [ -s "./events/$3.js" ]; then
            echo "$(tput setaf 1)The '$3.js' file already exists and is not empty! $(tput setaf 7)"
            exit 1
        fi

        if [ "$(curl -s "https://raw.githubusercontent.com/KodeurKubik/edb/main/templates/events/$3.js")" == "404: Not Found" ]; then
            echo "$(tput setaf 1)Event not found in the github events! $(tput setaf 7) See here for all events: https://github.com/KodeurKubik/edb/tree/main/templates/events"
            exit 1
        fi

        curl "https://raw.githubusercontent.com/KodeurKubik/edb/main/templates/events/$3.js" > "./events/$3.js"
        echo "$(tput setaf 2)Event '$3' successfully added! $(tput setaf 7)"
    fi
fi
