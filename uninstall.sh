#!/bin/bash

printf "$(tput setaf 3)Please confirm that you want to uninstall EDB: Y/N $(tput setaf 7): "
read -r confirm


case "$confirm" in
    [yY] | [yY][eE][sS]) echo "Confirmed! Uninstalling EDB..." ;;
    *) echo "Cancelled!" && exit 0
esac

unalias edb
find . -remove
echo "EDB uninstalled, please delete the parent folder manually..."
