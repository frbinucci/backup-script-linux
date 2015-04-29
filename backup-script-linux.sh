#!/bin/bash
nomeCartella=`dirname $0`
#Nel caso in cui lo script venga invocato con un numero insufficiente di argomenti verrà visualizzato un messaggio di errore.
if [ -z "$1" -o -z "$2" -o -z "$3" ]
then
	echo
	echo 'Errore! Uno o più parametri mancanti!' >&2
	echo "La sintassi corrretta è: $0 <tipo_backup> <directory_sorgente> <directory_destinazione>" >&2
	#Lo script restiutirà l'exit code 8 se il numero di argomenti con cui è stato invocato è insufficiente
	exit 8
fi

echo

#Ottenimanto del nome della cartella di backup tramite il comando "date"
nomeCartellaBackup=`date +%Y%m%d%H%M`

#Ottenimento dell'ultima data tramite il sottoscritp "ottieni_ultima_data.sh". Gli argomenti con cui viene invocato lo script sono:
#$1=>Tipo di backup.
#$2=>Directory di destinazione.
ultimaData=`./${nomeCartella}/ottieni_ultima_data.sh $1 $3` 

#L'exit code restiuito dallo script "ottieni_ultima_data" viene salvato nella variabile "controlloData"
controlloData=$?

#Nel caso in cui la variabile "controlloData" contenga un valore superiore a 0, l'ottenimento dell'ultima data di backup ha evidenziato errori e
#lo script terminerà con l'exit code restituito dal sottoscritp "ottieni_ultima_data.sh".
if [ $controlloData -gt 0 ]
then
	exit $controlloData
fi

#Ottenimento del nome completo della cartella di backup.
nomeCartellaBackup=${nomeCartellaBackup}_$1

#Creazione della directory di backup nella cartella di destinazione.
mkdir $3/$nomeCartellaBackup

#Invocazione del sottoscript "copia_file.sh" con i rispettivi argomenti:
#$2=>Directory di origine.
#$3=>Directory di destinazione.
#$ultimaData=>Ultima data di backup.
${nomeCartella}/copia_file.sh $2 $3/$nomeCartellaBackup $ultimaData

#Salvataggio dell'exit code dello script "copia_file.sh" all'interno della variabile "controlloCopia".
controlloCopia=$?

#Se la variabile "controlloCopia" assumerà valori superiori a 0 lo script restiuirà l'exit code dello script "controlloCopia".
if [ $controlloCopia -gt 0 ]
then
	exit $controlloCopia
fi

#Segnalazione all'utente dell'avvenuto backup di tutti i file.
echo 
echo "Backup di tutti i files avvenuto con successo!" 
	