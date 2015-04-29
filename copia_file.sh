#!/bin/bash

#La variabile "err" viene inizializzata a 0. Serve a segnalare la presenza di file per cui si sono verificati errori durante la copia.
err=0

#Ottenimento dell'elenco dei file interessati dal backup tramite il comando ls.
nomiFileDaCopiare=`ls $1`
if [ $? -gt 0 ]
then
	#Se la directory sorgente non sarà disponibile, lo script restituirà un messaggio di errore con exit code 2.
	echo "Attenzione, directory sorgente non disponibile!" >&2
	exit 1
fi

#Verifica della presenza di file/directory all'interno della directory sorgente.
if [ `ls $1 | wc -l` -eq 0 ]
then
	#Se non vengono rilevati file all'interno della directory sorgente lo script segnalerà che essa è vuota e restituirà l'exit code 2.
	echo "Attenzione, directory sorgente vuota" >&2
	exit 2
fi

#Ciclo necessario alla copia dei file.
for i in $nomiFileDaCopiare
do
	#Ottenimento della data di ultima modifica dell'elemento esaminato.
	dataFile=`stat -c %y $1/$i`
	data=${dataFile:0:10}
	ora=${dataFile:11:5}
	dataFile="${data}-${ora}"
	#Nel caso in cui l'elemento sia una directory lo script creerà la directory corrispondente nella destinazione e richiamerà se stesso.
	if [ -d $1/$i ]
	then
		if [ `ls $1/$i | wc -l` -gt 0 ]
		then
			mkdir $2/$i
			$0 $1/$i $2/$i $3
			#Se l'esecuzione dello script avrà restiuito exit code 4 la variabile "err" verrà portata a 1, in modo da segnlare la presenza di errori durante
			#la copia di alcuni file.
			if [ $? -eq 4 ]
			then
				err=1
			fi
		fi
	else
		#Nel caso in cui l'elemento sia un file esso verrà copiato nella directory di destinazione.
		if [[ $dataFile > $3 ]]
		then
			percorso=`dirname $1/$i`
			cp $1/$i $2
			#Se la copia evidenzia problemi lo script lo farà presente all'utente.
			if [ $? -gt 0 ]
			then
				echo "Attenzione! Backup di ${percorso}/$i non riuscito!" >&2
				err=1
			#In caso contrario, lo script segnala all'utente l'avvenuta copia del file.
			else
				echo "Backup di ${percorso}/$i avvenuto con successo!"
			fi
		fi
	fi
done

#Se la variabile "err" avrà assunto valore "1" lo script terminerà con exit code 4
if [ $err -gt 0 ]
then
	exit 4
fi

