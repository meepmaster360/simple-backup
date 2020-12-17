#!/bin/bash
# Autor: meepmaster
# Descrição: Script para Backup do sistema.

# Pode ser configurado no script os valores padrão, se não forem declaradas variáveis
#     novas na linha de comando

# O script vai nomear o ficheiro de backup: {$HOSTNAME}.{YYYYmmdd}.img

# Quando o scrip apaga backups mais antigos que o periodo de retenção,
#     ele vai apagar apenas ficheiros associados ao $HOSTNAME.
 
# Uso: backup.sh {path} {days of retention}
# Uso: backup.sh {/home/backup} {2}
# Uso: backup.sh  # Assume {/nmt/backup} {3}


# INICIO
clear

# Criar directorio /mnt/backup
# Criar scrip para verificar existencia de directorio
mkdir /mnt/backup

# Declarar variáveis e valores padrão
backup_path=/mnt/backup
retention_days=3

# Verificar se estamos com previlégios root!
if [[ ! $(whoami) =~ "root" ]]; then
echo ""
echo "***************************************"
echo "*** Tem de ser executado como root! ***"
echo "***************************************"
echo ""
exit
fi

# Check to see if we got command line args
if [ ! -z $1 ]; then
   backup_path=$1
fi

if [ ! -z $2 ]; then
   retention_days=$2
fi

# Create trigger to force file system consistency check if image is restored
touch /boot/forcefsck

# Perform backup
dd if=/dev/mmcblk0 of=$backup_path/$HOSTNAME.$(date +%Y%m%d).img bs=1M

# Remove fsck trigger
rm /boot/forcefsck

# Delete old backups
find $backup_path/$HOSTNAME.*.img -mtime +$retention_days -type f -delete 

