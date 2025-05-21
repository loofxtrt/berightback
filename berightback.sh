#!/bin/bash

# importar as variáveis de listas de diretórios alvo
source ./targets.sh

# cria nome do diretório de backup com base na data atual
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIRECTORY="$HOME/Desktop/backup-$DATE"

mkdir -p "$BACKUP_DIRECTORY"

# guard clause caso o diretório de backup não exista por algum motivo
if [ -z "$BACKUP_DIRECTORY" ] || [ ! -d "$BACKUP_DIRECTORY" ]; then
    echo "Backup directory does not exists or is not a valid directory"
    return 1
fi

# copiar os diretórios especificados pro diretório de backup
copy_directories() {
    local dir_args=("$@") # variável que representa todos os argumentos passados pra essa função
    local dir_count=0     # variável só pra obter o número de diretórios

    for dir in "${dir_args[@]}"; do           # receber os argumentos passados pra função e transformar num array (ex: dir_args=(/pasta1 /pasta2))
        if [ -d "$dir" ]; then                # testar se é um diretório que realmente existe
            cp -r "$dir" "$BACKUP_DIRECTORY/" # copiar pro direttório de destino

            ((dir_count+=1)) # incrementar mais um diretório na contagem
            echo "Copied $dir to $BACKUP_DIRECTORY"
        else
            echo "$dir is not a valid directory. Moving on to the next"
        fi
    done

    echo "Copied $dir_count directories to $BACKUP_DIRECTORY"
}