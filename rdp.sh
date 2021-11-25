#!/usr/bin/env bash

# Variabili globali
user=su.canali
domain=cpra.local

# Functions
# Help
Help() {
   echo "Uso: $(basename $0) [-?] -h SERVER"
   echo
   echo -e "-h\tMostra questo aiuto."
   echo -e "-s\tServer FQDN/IP"
   echo
}

# Connect
Connect() {
    server=`zenity --entry --text "Server FQND/IP: "`

    if [[ -z $server ]]
    then
	exit 0
    fi
    
    ping -c1 -W1 -q $server &>/dev/null
    status=$( echo $? )

    if [[ $status -ne 0 ]]
    then
	#echo "Impossibile raggiungere il server $2"
	zenity --error --width=400 --height=200 --text "Impossibile raggiungere il server $server!"
	exit 1
    fi

    rdesktop -u $user -d $domain --no-check-certificate -k it -g 1800x1000 $server || xfreerdp -u $user -d $domain $server
    if [[ $? -ne 0 ]]
    then
	zenity --error --width=400 --height=200 --text "Problema imprevisto [ERRORE]: $?"
    fi
    
}

# Controlla i parametri passati
while getopts ":hs" option
do
    case $option in
	h) 
	    Help
	    exit 0
	    ;;
	s)
	    Connect $2
	    exit 0
	    ;;
    esac
done
