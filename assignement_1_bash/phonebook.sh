#!/bin/bash

clear

function insertC()
{
    echo "Please Enter The Name"
    read -p "" Name
    echo "How Many Phone Numbers Does This Person Have"
    read -p "" Number
    case $Number in
    ''|*[!0-9]*) echo This Is Not A Number
        ;;
    *)  echo "" >> 'phonebook.sh'
        echo $Name >> 'phonebook.sh'
        echo $Number >> 'phonebook.sh'
        local Counter=1
        while [ $Counter -le $Number ]
        do
            echo "Please Enter Phone Number #$Counter"
            read -p "" num
            echo $num >> 'phonebook.sh'
            ((Counter++))
        done
        ;;
    esac
}

function viewC()
{
    local start=0
    input="phonebook.sh"
    while IFS= read -r line
        do
            if [ "$line" == "#Start Appending To The Database" ]
            then
                start=1
                continue
            fi
            if [ $start == 1 ]
            then
                printf "\t\t$line\n"
                IFS= read -r line
                local Number=$(($line + 0))
                local Counter=0
                while [ $Counter -le $Number ]
                do
                    IFS= read -r line
                    printf "\t\t$line\n"
                    ((Counter++))
                done
                echo ""
            fi
    done < "$input"
}

function searchC()
{
    echo "Please Enter The Name You Want To Search For"
    read -p "" Name
    printf "\tThe Results Are:\n"
    local start=0
    input="phonebook.sh"
    while IFS= read -r line
        do
            if [ "$line" == "#Start Appending To The Database" ]
            then
                start=1
                continue
            fi
            if [ $start == 1 ] && [ "$line" == "$Name" ]
            then
                printf "\t\t$line\n"
                IFS= read -r line
                local Number=$line
                local Counter=0
                while [ $Counter -le $Number ]
                do
                    IFS= read -r line
                    printf "\t\t$line\n"
                    ((Counter++))
                done 
            elif [ $start == 1 ] && [ "$line" != "$Name" ]
            then
                IFS= read -r line
                local Number=$line
                local Counter=0
                while [ $Counter -le $Number ]
                do
                    IFS= read -r line
                    ((Counter++))
                done
            fi
    done < "$input"
}

function deleteC()
{
    touch tmpphonebook.txt
    chmod 777 tmpphonebook.txt
    input="phonebook.sh"
    echo "Please Enter The Name You Want To Delete"
    read -p "" Name
    local start=0
    input="phonebook.sh"
    while IFS= read -r line
        do
            if [ "$line" == "#Start Appending To The Database" ]
            then
                start=1
                echo "$line" >> "tmpphonebook.txt"
                continue
            fi
            if [ $start == 0 ]
            then
                echo "$line" >> "tmpphonebook.txt"
            elif [ $start == 1 ] && [ "$line" != "$Name" ]
            then
                echo "$line" >> "tmpphonebook.txt"
                IFS= read -r line
                echo "$line" >> "tmpphonebook.txt"
                local Number=$line
                local Counter=0
                while [ $Counter -le $Number ]
                do
                    IFS= read -r line
                    echo "$line" >> "tmpphonebook.txt"
                    ((Counter++))
                done
            elif [ $start == 1 ] && [ "$line" == "$Name" ]
            then
                IFS= read -r line
                local Number=$line
                local Counter=0
                while [ $Counter -le $Number ]
                do
                    IFS= read -r line
                    ((Counter++))
                done
            fi
    done < "$input" 
    if [ "$(tail -1 tmpphonebook.txt)" != "#Start Appending To The Database" ]
    then
        head -n -1 tmpphonebook.txt > phonebook.sh
    else
        head -n -1 tmpphonebook.txt > phonebook.sh
        printf "#Start Appending To The Database" >> "phonebook.sh"
    fi
    rm -f tmpphonebook.txt
}

function deleteAllC()
{
   touch tmpphonebook.txt
   chmod 777 tmpphonebook.txt
   input="phonebook.sh"
    while IFS= read -r line && [ "$line" != "#Start Appending To The Database" ]
        do
            echo "$line" >> "tmpphonebook.txt"
    done < "$input"
    printf "#Start Appending To The Database" >> "tmpphonebook.txt"
    mv tmpphonebook.txt phonebook.sh
}

getopts 'ivsed' options
        case $options in
            i) insertC
                ;;
            v) viewC
                ;;
            s) searchC
                ;;
            e) deleteAllC
                ;;
            d) deleteC
                ;;
            *) printf "\tFor Inserting A New Contact Use -i\n\tFor Viewing Contacts Use -v\n\tFor Searching Use -s\n\tFor Deleting All Contacts Use -e\n\tFor Deleting A specific Contact Use -d\n"
        esac
exit 0;

#Start Appending To The Database