#!/usr/bin/env bash

set -e

# Cores
VERMELHO=$'\033[31m'
VERDE=$'\033[32m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variaveis importantes

APP_NAME="SOC-Term"

INSTALL_DIR="/opt/$APP_NAME"
BIN_PATH="/usr/local/bin/sct"

BASE_DIR="$(dirname "$(realpath "$0")")"

TEMP_DIR="/$HOME/SOC-Term/"


printf "${AMARELO}Iniciando instalação do ${APP_NAME}...${RESET}\n"


# Verificação Root

if [[ "$EUID" -ne 0 ]]; then
    printf "${VERMELHO}Execute como root.${RESET}\n"
    printf "Use: sudo ./install.sh\n"
    exit 1
fi


# Verificação ZIP

printf "${CIANO}Verificando pacote...${RESET}\n"


ZIP_FILE="$BASE_DIR/SOC-Term.zip"


if [[ ! -f "$ZIP_FILE" ]]; then
    printf "${VERMELHO}SOC-Term.zip não encontrado.${RESET}\n"
    exit 1
fi



# Dependências unzip

if ! command -v unzip &>/dev/null; then

    printf "${AMARELO}Instalando unzip...${RESET}\n"

    apt update
    apt install -y unzip

fi



# Extrair dados da ferramenta

printf "${CIANO}Extraindo arquivos...${RESET}\n"


rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"


unzip -q "$ZIP_FILE" -d "$TEMP_DIR"



# Encontrar arquivo sct.sh

SOURCE_DIR=$(find "$TEMP_DIR" -type f -name "sct.sh" -exec dirname {} \; | head -n 1)


if [[ -z "$SOURCE_DIR" ]]; then

    printf "${VERMELHO}sct.sh não encontrado dentro do pacote.${RESET}\n"
    exit 1

fi



# Dependências da ferramenta

printf "${CIANO}Verificando dependências...${RESET}\n"


DEPENDENCIAS=(
    lsof
    awk
    strings
    systemctl
    journalctl
    ss
)


for comando in "${DEPENDENCIAS[@]}"; do

    if command -v "$comando" &>/dev/null; then

        printf "${VERDE}OK: $comando${RESET}\n"

    else

        printf "${AMARELO}Instalando: $comando${RESET}\n"

        apt update
        apt install -y "$comando"

    fi

done



# Instalação no sistema

printf "${CIANO}Instalando arquivos...${RESET}\n"


rm -rf "$INSTALL_DIR"

mkdir -p "$INSTALL_DIR/scripts"


cp -r "$SOURCE_DIR/scripts/"* "$INSTALL_DIR/scripts/"

cp "$SOURCE_DIR/sct.sh" "$BIN_PATH"



# Permissões

chmod +x "$BIN_PATH"
chmod +x "$INSTALL_DIR/scripts/"*.sh



# Limpeza

printf "${CIANO}Limpando arquivos temporários...${RESET}\n"


rm -rf "$TEMP_DIR"


printf "${VERDE}SOC-Term instalado com sucesso!${RESET}\n"

printf "${CIANO}Execute:${RESET}\n"

echo "sct -h"
