#!/bin/bash

clear
crontab -l > sdel
echo "0 * * * * "$(pwd)"/sdel.sh" >> sdel
crontab sdel
rm sdel

if [[ -d ~/TRASH ]]
then
    :
else
    mkdir ~/TRASH
fi

for var in "$@"
do
    gzip -t "$var" 2>/dev/null
    if [ $? != 0 ]
    then
        #gzip "$var"
        tar -zcvf "$var.tar.gz" "$var/" 
        mv "$var.tar.gz" ~/TRASH
        rm -r "$var"
    else
        mv "$var" ~/TRASH
    fi
done

cd ~/TRASH

if [ "$(ls -A $DIR)" ]; then
    for filename in ~/TRASH/*; do
        two_days=$(date -d 'now - 2 days' +%s)
        file_time=$(date -r "$filename" +%s)

        if (( file_time <= two_days )); then
            rm "$filename"
        fi
    done
fi

exit 0