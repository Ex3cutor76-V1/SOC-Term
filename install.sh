#!/usr/bin/env bash

set -e

# Cores
VERMELHO=$'\033[31m'
VERDE=$'\033[32m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

APP_NAME="SOC-Term"

INSTALL_DIR="/opt/$APP_NAME"
BIN_PATH="/usr/local/bin/sct"

BASE_DIR="$(dirname "$(realpath "$0")")"

printf "${AMARELO}Iniciando instalação do ${APP_NAME}...${RESET}\n"


# ==========================
# Root
# ==========================

if [[ "$EUID" -ne 0 ]]; then
    printf "${VERMELHO}Execute como root:${RESET}\n"
    printf "sudo ./install.sh\n"
    exit 1
fi


# ==========================
# Verificar arquivos
# ==========================

printf "${CIANO}Verificando arquivos...${RESET}\n"


if [[ ! -f "$BASE_DIR/sct.sh" ]]; then
    printf "${VERMELHO}sct.sh não encontrado.${RESET}\n"
    exit 1
fi


if [[ ! -d "$BASE_DIR/scripts" ]]; then
    printf "${VERMELHO}Diretório scripts não encontrado.${RESET}\n"
    exit 1
fi


printf "${VERDE}Arquivos encontrados.${RESET}\n"



# ==========================
# Dependências
# ==========================

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



# ==========================
# Instalação
# ==========================

printf "${CIANO}Instalando arquivos...${RESET}\n"


rm -rf "$INSTALL_DIR"

mkdir -p "$INSTALL_DIR/scripts"


cp -r "$BASE_DIR/scripts/"* "$INSTALL_DIR/scripts/"


cp "$BASE_DIR/sct.sh" "$BIN_PATH"



# ==========================
# Permissões
# ==========================

chmod +x "$BIN_PATH"
chmod +x "$INSTALL_DIR/scripts/"*.sh



# ==========================
# Limpeza
# ==========================

printf "${CIANO}Removendo arquivos temporários...${RESET}\n"


if [[ "$BASE_DIR" == "$HOME"* ]]; then
    rm -rf "$BASE_DIR"
fi



# ==========================
# Final
# ==========================


printf "${VERDE}SOC-Term instalado com sucesso!${RESET}\n"

printf "${CIANO}Execute:${RESET}\n"

echo "sct -h"
