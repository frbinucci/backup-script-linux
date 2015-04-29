#/bin/bash

#Creazione dell'elenco delle directory presenti nella directory di destinazione.
nomiCartelleBackup=`ls $2`

#Se l'esecuzione del precedente comando restiuisce un exit code diverso da 0, lo script segnalerà la non disponibilità della directory di destinazione
#e terminerà con l'exit code 3.
if [ $? -gt 0 ]
then
	echo "Attenzione, directory di destinazione non disponibile!" >&2
	exit 3
fi

#Nel caso in cui il tipo di backup (contenuto nell'argomento $1) sia "completo", la variabile "ultimaData" verrà inizializzata con la stringa "1970-01-01-00:00."
if [ $1 == 'completo' ]
then
	ultimaData="1970-01-01-00:00"
else
	ultimaData="1970-01-01-00:00"
	#Nel caso in cui il tipo di backup selezionato sia "incrementale" verrà ricercata la cartella di backup più recente e tale data verrà salvata nella
	#variabile "ultimaData".
	if [ $1 == 'incrementale' ]
	then
		
		for i in $nomiCartelleBackup
		do
			dataCartella="${i:0:4}-${i:4:2}-${i:6:2}-${i:8:2}:${i:10:2}"
			if [[ "$dataCartella" > "$ultimaData" ]]
			then
				ultimaData=$dataCartella
			fi
		done
		#Se, al termine del precedente ciclo, la variabile "ultimaData" assumerà valore "1970-01-01-00:00" lo script segnalerà l'assenza di precedenti
		#backup e terminerà con exit code 6.
		if [[ $ultimaData == '1970-01-01-00:00' ]]
		then
			echo "Attenzione! Nella directory di destinazione non è stato trovato alcun backup! Eseguire un backup, quindi riprovare!" >&2
			exit 6
		fi
	else
		#Nel caso in cui il tipo di backup selezionato sia "differenziale" verrà ricercata la cartella di backup completo più recente e tale data verrà
		#salvata all'interno della variabile "ultimaData".
		if [ $1 == 'differenziale' ]
		then
			for i in $nomiCartelleBackup
			do
				dataCartella="${i:0:4}-${i:4:2}-${i:6:2}-${i:8:2}:${i:10:2}"
				tipoBackup=${i:13:8}
				if [ $tipoBackup == 'completo' ]
				then
					if [[ "$dataCartella" > "$ultimaData" ]]
					then
						ultimaData=$dataCartella
					fi
				fi
			done
			#Se, al termine del precedente ciclo, la variabile "ultimaData" assumerà valore "1970-01-01-00:00" lo script segnalerà l'assenza di precedenti
			#backup e terminerà con exit code 5.
			if [[ $ultimaData == '1970-01-01-00:00' ]]
			then
				echo "Attenzione! Nella directory di destinazione non è stato trovato alcun backup completo! Eseguire un backup completo, quindi riprovare!" >&2
				exit 5
			fi
		else
			#Nel caso in cui il tipo di backup non sia riconosciuto, lo script lo farà presente all'utente e restituirà l'exit code 7.
			echo "Attenzione! Lo script non esegue backup di tipo $1" >&2
			exit 7
		fi
	fi
fi

#Lo script restituirà il valore della variabile "ultimaData".
echo $ultimaData