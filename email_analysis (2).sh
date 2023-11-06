#!/bin/bash


function show_help {
	echo ""
       	echo "email_analysis.sh [-h|--help]|[-e|--email]|[-c|--company]+[dateiname]"
   	echo ""
    	echo "  -h|--help: Show this help and quits"
    	echo "  -e|--email: gibt die Emailadressen aus, in geordneter Reihenfolge"
    	echo "  -c|--company: gibt die Email Provider aus, un geordneter Reihenfolge"
    	echo ""
}


#option ist der Übergabeparameter file ist die zu übergebende Datei
option=$1
file=$2

#wenn die erste Eingabe eine Datei ist, dann wird die Eingabe file zugeordnet
#und option wird -e zugeordnet, da standardmäßig die Emails gecheckt werden sollen
if [ -f $option ]; then
	file=$option
	option="-e"
fi
#wenn keine Eingabe oder eine falsche erfolgt ohne Dateiübergabe, und nicht nur -h oder --help eingegeben wurde, 
#dann wird der Fehlercode angezeigt und die show_help Seite aufgerufen
if [ -z $file ] && [ "$option"  != "-h" ] && [ "$option"  != "--help" ]; then
	echo "falsche Eingabe"
	show_help
	exit
fi
#Übergabeparameter, aber keine gültige Datei übergeben
if [ ! -f  $file ]; then
        echo "keine Datei übergeben"
        show_help
        exit
fi


#wenn die Variable  option vorhanden ist wird diese den verschiedenen Fällen zugeordnet:
case "$option" in
	-e|--email)
		#es werden mit grep alle Zeilen mit "From " rausgezogen und an das nächste grep übergeben, welches nach @ rausfiltert
		#das cut schneidet mit -d als Trennfaktor das Element, an zweiter Stelle, sodass man nur noch die Email erhält, sort sortiert das ganze alphabetisch
		#sodass die Emails nebeneinander sind, uniq -c bündelt die nebeneinanderstehenden Emails zu einer einzelnen und gibt die Anzahl aus
		#sort -n sortiert das Ganze dann nummerisch
		grep -B1  "^From: " "$file" |grep "^From " | grep "@" | cut -d " " -f2 | sort | uniq -c  | sort -n
		;;
	-c|--company)
		#zweilmal gecuttet und @ als Trennfaktor beim 2. cut
		grep -B1 "^From: " "$file" | grep "^From " | grep "@" | cut -d " " -f2 | cut -d "@" -f2 | sort | uniq -c | sort -n
		;;
	-h|--help)
		show_help
		;;
	*)
		echo "falscher Übergabeparameter"
		show_help
		;;
esac

