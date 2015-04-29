 backup-script-linux

##Nome

*backup-script-linux*, script che consente di eseguire il backup dei file in ambiente Linux o tramite Cygwin

##Sintassi

backup_script_linux TIPO_BACKUP DIRECTORY_SORGENTE DIRECTORY_DESTINAZIONE

##Descrizione

*Avvertenze:*

* Lo script assume che per il backup di diverse directory sorgente si utilizzino diverse directory di destinazione.
* Lo script crea problemi se si cerca di eseguire due backup dello stesso tipo durante lo stesso minuto, a causa della modalità utilizzata per nominare le cartelle di destinazione dei vari backup poichè le due cartelle dovrebbero avere il medesimo nome (vedi sotto).
* Lo script crea problemi se i nomi dei file di cui si vuole eseguire il backup contengono degli spazi.
* Lo script consente di eseguire il backup di file e directory, anche se il backup di cartelle risulta una funzionalità da migliorare.

Lo script consente di eseguire un particolare tipo di backup dei file presenti nella directory sorgente, i quali verranno copiati all'interno della directory di destinazione.
Nella directory di destinazione lo script creerà una sottodirectory per ogni backup eseguito, la quale avrà come nome la data in cui è stato eseguito il backup seguita dalla tipologia di backup. La data viene scritta nella forma **AAAA/MM/GG/HH/mm** e, in particolar modo, il nome della cartella di destinazione di ogni backup avrà la seguente forma:

**AAAAMMGGHHmm_tipoDiBackup.**


Lo script consente, in particolare, di eseguire tre tipologie di backup:

* Backup completo, coinvolge tutti i file presenti nella directory sorgente
* Backup incrementale, coinvolge i file presenti nella directory sorgente che sono stati modificati dall'ultimo backup
* Backup differenziale, coinvolge i file presenti nella directory sorgente che sono stati modificati dall'ultimo backup completo

Mentre è sempre possibile eseguire un backup completo, non sarà possibile eseguire un backup incrementale e differenziale se non sono presenti altri backup nella cartella.



##Input

* TIPO_BACKUP: rappresenta la tipologia di backup che si vuole eseguire e può assumere tre valori: completo, incrementale e differenziale.
* DIRECTORY_SORGENTE: rappresenta la directory dove sono localizzati i file dei quali si vuole eseguire il backup.
* DIRECTORY_DESTINAZIONE: rappresenta la directory dove verranno copiati i file coinvolti nel processo di backup.

#Output

###Exit code

* 0 Il backup di tutti i file presenti nella directory sorgente è avvenuto con successo.
* 1 La directory sorgente non è disponibile.
* 2 La directory sorgente è vuota.
* 3 La directory destinazione non è disponibile.
* 4 Si sono verificati errori durante la copia di alcuni file.
* 5 Non è stato trovato alcun backup completo nella cartella di destinazione.
* 6 Non è stato trovato alcun backup nella cartella di destinazione.
* 7 Il tipo di backup inserito non è stato riconosciuto.
* 8 Omessi alcuni argomenti tra quelli necessari per l'esecuzione dello script.

###STDOUT

Lo script stamperà una serie di righe, ognuna delle quali contenente il nome del file la cui copia è avvenuta con successo.

###STDERR

Lo script stamperà una serie di righe nel STDERR, ognuna delle quali contenente il nome del file durante la cui copia sono stati riscontrati dei problemi.



