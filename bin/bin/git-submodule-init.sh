#!/bin/bash

set -e
#rm -rf .git
#git init

git config -f .gitmodules --get-regexp '^submodule\..*\.path$' > tempfile

while read -u 3 path_key ppath
do
    url_key=$(echo $path_key | sed 's/\.path/.url/')
    url=$(git config -f .gitmodules --get "$url_key")

    read -p "Are you sure you want to delete $ppath and re-initialize as a new submodule? " yn
    case $yn in
        [Yy]* ) rm -rf $ppath; git submodule add $url $ppath;
            echo "$ppath has been initialized" ;;
        [Nn]* ) exit ;;
        * ) echo "Please answer yes or no.";;
    esac

done 3<tempfile

rm tempfile
