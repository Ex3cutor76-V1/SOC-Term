#!/usr/bin/env bash

set -e

# Cores
VERMELHO=$'\033[31m'
VERDE=$'\033[32m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'


# Variáveis importantes

APP_NAME="SOC-Term"

INSTALL_DIR="/opt/$APP_NAME"
BIN_PATH="/usr/local/bin/sct"

BASE_DIR="$(dirname "$(realpath "$0")")"

TEMP_DIR="$(mktemp -d)"


if [[ -n "$SUDO_USER" ]]; then
    USER_HOME="$(eval echo "~$SUDO_USER")"
else
    USER_HOME="$HOME"
fi


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



# Extrair arquivos importantes

printf "${CIANO}Extraindo arquivos...${RESET}\n"


unzip -q "$ZIP_FILE" -d "$TEMP_DIR"



# Encontrar arquivos

SOURCE_DIR=$(find "$TEMP_DIR" -type f -name "sct.sh" -exec dirname {} \; | head -n 1)


if [[ -z "$SOURCE_DIR" ]]; then

    printf "${VERMELHO}sct.sh não encontrado dentro do pacote.${RESET}\n"

    rm -rf "$TEMP_DIR"

    exit 1

fi



if [[ ! -d "$SOURCE_DIR/scripts" ]]; then

    printf "${VERMELHO}Diretório scripts não encontrado.${RESET}\n"

    rm -rf "$TEMP_DIR"

    exit 1

fi



# Dependências

printf "${CIANO}Verificando dependências...${RESET}\n"


DEPENDENCIAS=(
    lsof
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



# Instalação do software

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



printf "${CIANO}Removendo instalador...${RESET}\n"


cd /


if [[ "$BASE_DIR" != "/" ]]; then

    rm -rf "$BASE_DIR"

fi



# Final do script


printf "${VERDE}${APP_NAME} instalado com sucesso!${RESET}\n"

printf "${CIANO}Execute:${RESET}\n"

echo "sct -h"
