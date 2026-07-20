#!/usr/bin/env bash

# Cores
VERMELHO=$'\033[31m'
VERDE=$'\033[32m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Nome da ferramenta
APP_NAME="SOC-Term"

# Caminhos
INSTALL_DIR="/opt/$APP_NAME"
BIN_PATH="/usr/local/bin/sct"

# Caminho onde o instalador está sendo executado
BASE_DIR="$(dirname "$(realpath "$0")")"

printf "${AMARELO}Iniciando instalação do ${APP_NAME}...${RESET}\n"

# Verifica root
if [ "$EUID" -ne 0 ]; then
    printf "${VERMELHO}Execute o instalador como root.${RESET}\n"
    printf "Use: sudo ./install.sh\n"
    exit 1
fi


# Verificação de dependências

printf "${CIANO}Verificando dependências...${RESET}\n"

DEPENDENCIAS=(
    lsof
    awk
    strings
    systemctl
    journalctl
    ss
    git
)

for comando in "${DEPENDENCIAS[@]}"; do

    if ! command -v "$comando" &>/dev/null; then
        printf "${VERMELHO}Ausente: $comando${RESET}\n"

        if command -v apt &>/dev/null; then
            apt update
            apt install -y "$comando"
        else
            printf "${VERMELHO}Gerenciador apt não encontrado.${RESET}\n"
            exit 1
        fi

    else
        printf "${VERDE}OK: $comando${RESET}\n"
    fi

done


# Criar diretório dos scripts

printf "${CIANO}Organizando arquivos...${RESET}\n"

mkdir -p "$INSTALL_DIR/scripts"


# Copiar scripts

cp -r "$BASE_DIR/scripts/"* "$INSTALL_DIR/scripts/"


# Copiar comando principal

cp "$BASE_DIR/sct.sh" "$BIN_PATH"


# Permissões

chmod +x "$BIN_PATH"
chmod +x "$INSTALL_DIR/scripts/"*.sh


printf "${VERDE}SOC-Term instalado com sucesso!${RESET}\n"

printf "${CIANO}Execute:${RESET}\n"
echo "sct -h"
