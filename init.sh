#!/bin/bash

echo "$(tput setaf 3)Initializing EDB... $(tput setaf 7)"
rm -rf ./templates
chmod +x ./index.sh


if [ ! "$(command -v jq)" ]; then
    pushd || exit
    if [ ! "$(command -v brew)" ]; then
        echo "$(tput setaf 3)Brew not installed! $(tput setaf 7)Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo "$(tput setaf 2)Brew installed! $(tput setaf 7)"
    fi
    echo "$(tput setaf 3)Installing JQ with Brew... $(tput setaf 7)"
    brew install jq
    echo "$(tput setaf 2)JQ installed! $(tput setaf 7)"
    popd || exit
fi

alias edb="./index.sh"
echo "$(tput setaf 2)EDB ready! $(tput setaf 7)Use './index.sh' in the EDB directory to start using the module!"
