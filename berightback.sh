#!/bin/bash

# variáveis de customização de texto
GREEN='\033[1;32m' # 1; pra além de ser colorido, também estar em negrito
BLUE='\033[34m'
RESET='\033[0m'

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
    local destination="$1" # argumento do subdiretório de destino em direção ao diretório de backup pai 
    shift
    local dir_args=("$@")  # variável que representa todos os argumentos passados pra essa função
    local dir_count=0      # variável só pra obter o número de diretórios

    # criar o subdiretório a cada leva de arrays copiados
    mkdir -p "$destination"

    # copiar os diretórios pro destino
    for dir in "${dir_args[@]}"; do           # receber os argumentos passados pra função e transformar num array (ex: dir_args=(/pasta1 /pasta2))
        if [ -d "$dir" ]; then                # testar se é um diretório que realmente existe
            cp -r "$dir" "$destination/"      # copiar pro direttório de destino

            ((dir_count+=1)) # incrementar mais um diretório na contagem
            echo "Copied $dir to $destination"
        fi
    done

    if [[ $dir_count -gt 0 ]]; then
        echo -e "${GREEN}Finished copying a directory array with $dir_count directories to $BACKUP_DIRECTORY${RESET}"
    fi
}

run_backup() {
    source ./targets.sh # importar as variáveis de listas de diretórios alvo

    # encontrar todas as variáveis que são array dentro desse arquivo (que agora foram refletidas nesse)
    # filtrar apenas as que começam com target_
    # e rodar a função copy_directories em cada um desses arrays
    for var_name in $(compgen -A variable | grep '^target_'); do
        # - declare -p mostra a declaração completa da variável. se o nome dela for dotlocal_dotconfig
        #   o retorno vai ser 'declare -a dotlocal_dotconfig=([0]="~/.config/godot" [1]="~/.config/blender" ...)'
        # - 2>/dev/null é só pra esconder qualquer erro caso, por exemplo, a variável não exista
        # - | grep -q 'declare \-a' lê o que declare -p respondeu e procura a palavra declare -a, que define que a variável é um array normal
        #   o -q faz o grep não printar nada, só retornar true ou false
        #   se esse if for true, essa variável é um array, então deve continuar
        if declare -p "$var_name" 2>/dev/null | grep -q 'declare \-a'; then
            local subdir_name="${var_name#target_}"                 # remove o prefixo "target_"
            local array_backup_dir="$BACKUP_DIRECTORY/$subdir_name" # subdiretório do backup

            echo -e "${BLUE}Now copying $var_name into $array_backup_dir${RESET}"
            eval "copy_directories \"$array_backup_dir\" \"\${$var_name[@]}\"" # usar eval pra poder rodar duas camadas de variáveis, chamando a função pra cada uma
        fi
    done

    echo -e "${GREEN}Finished backing up all directories${RESET}"
}

run_backup