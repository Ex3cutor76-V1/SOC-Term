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
SCRIPTS_DIR="$INSTALL_DIR/scripts"
DATA_DIR="$INSTALL_DIR/data"
LOG_DIR="$INSTALL_DIR/logs"
API_DIR="$INSTALL_DIR/API"
API_FILE="$API_DIR/API.txt"

BASE_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"

TEMP_DIR=""

# Só remove o diretório do instalador quando ele veio de um pacote zip.
# Instalando a partir de um clone (sct --upgrade), o clone é preservado.
REMOVE_SOURCE=0

cleanup() {
    if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

trap cleanup EXIT


printf "${AMARELO}Iniciando instalação do ${APP_NAME}...${RESET}\n"


# Verificação Root

if [[ "$EUID" -ne 0 ]]; then

    printf "${VERMELHO}Execute como root.${RESET}\n"
    printf "Use: sudo ./install.sh\n"

    exit 1

fi


# Dependências

dependencias=(
unzip
lsof
iproute2
file
curl
jq)

printf "${CIANO}Verificando dependências...${RESET}\n"


if command -v apt-get >/dev/null; then

    DEBIAN_FRONTEND=noninteractive apt-get update -qq || true
    DEBIAN_FRONTEND=noninteractive apt-get install -y "${dependencias[@]}"

elif command -v dnf >/dev/null; then

    dnf install -y "${dependencias[@]}"

elif command -v pacman >/dev/null; then

    pacman -Sy --noconfirm "${dependencias[@]}"

else

    printf "${VERMELHO}Gerenciador de pacotes não encontrado.${RESET}\n"
    exit 1

fi


# Localização dos arquivos de origem
# Pacote SOC-Term.zip tem prioridade (distribuição oficial).
# Sem o zip, usa o diretório do próprio instalador (usado por "sct --upgrade").

if [[ -f "$BASE_DIR/SOC-Term.zip" ]]; then

    printf "${CIANO}Verificando pacote...${RESET}\n"

    TEMP_DIR="$(mktemp -d)"
    unzip -q "$BASE_DIR/SOC-Term.zip" -d "$TEMP_DIR"

    REMOVE_SOURCE=1

    SOURCE_DIR="$(find "$TEMP_DIR" -type f -name "sct.sh" -print -quit)"

    if [[ -n "$SOURCE_DIR" ]]; then
        SOURCE_DIR="$(dirname "$SOURCE_DIR")"
    fi

else

    printf "${AMARELO}SOC-Term.zip não encontrado. Usando os arquivos do próprio diretório.${RESET}\n"

    SOURCE_DIR="$BASE_DIR"

fi


if [[ -z "$SOURCE_DIR" || ! -f "$SOURCE_DIR/sct.sh" ]]; then

    printf "${VERMELHO}sct.sh não encontrado.${RESET}\n"

    exit 1

fi


if [[ ! -d "$SOURCE_DIR/scripts" ]]; then

    printf "${VERMELHO}Diretório scripts não encontrado.${RESET}\n"

    exit 1

fi


# Se o instalador estiver dentro do próprio destino, copia para um temporário
# antes de apagar a instalação antiga

if [[ "$SOURCE_DIR" == "$INSTALL_DIR" ]]; then

    TEMP_DIR="$(mktemp -d)"
    cp -a "$SOURCE_DIR/sct.sh" "$SOURCE_DIR/scripts" "$TEMP_DIR/"
    SOURCE_DIR="$TEMP_DIR"

fi


# Preserva dados, logs e a chave da API antes de substituir a instalação

BACKUP_DIR=""

if [[ -d "$DATA_DIR" || -d "$LOG_DIR" ]]; then

    BACKUP_DIR="$(mktemp -d)"

    if [[ -d "$DATA_DIR" ]]; then
        cp -a "$DATA_DIR" "$BACKUP_DIR/data"
    fi

    if [[ -d "$LOG_DIR" ]]; then
        cp -a "$LOG_DIR" "$BACKUP_DIR/logs"
    fi

fi

OLD_API=""

if [[ -f "$API_FILE" ]]; then
    OLD_API="$(head -n 1 "$API_FILE" | tr -d '\r' | tr -d '[:space:]')"
fi


# Instalação

printf "${CIANO}Instalando arquivos...${RESET}\n"

rm -rf "$INSTALL_DIR"

mkdir -p "$SCRIPTS_DIR" "$DATA_DIR" "$LOG_DIR" "$API_DIR"

cp -r "$SOURCE_DIR/scripts/"* "$SCRIPTS_DIR/"

cp "$SOURCE_DIR/sct.sh" "$BIN_PATH"


# Restaura dados e logs preservados

if [[ -n "$BACKUP_DIR" ]]; then

    if [[ -d "$BACKUP_DIR/data" ]]; then
        cp -a "$BACKUP_DIR/data/." "$DATA_DIR/"
    fi

    if [[ -d "$BACKUP_DIR/logs" ]]; then
        cp -a "$BACKUP_DIR/logs/." "$LOG_DIR/"
    fi

    rm -rf "$BACKUP_DIR"

fi


# Permissões

chmod +x "$BIN_PATH"

chmod +x "$SCRIPTS_DIR/"*.sh

chmod 755 "$INSTALL_DIR" "$SCRIPTS_DIR"

chmod 700 "$DATA_DIR" "$LOG_DIR" "$API_DIR"


# Permissões para o usuário salvar dados e logs

OWNER="${SUDO_USER:-root}"

chown -R "$OWNER":"$OWNER" "$DATA_DIR" "$LOG_DIR"


# Chave da API: criada vazia se não existir, somente root lê e escreve

if [[ ! -f "$API_FILE" ]]; then
    : > "$API_FILE"
fi

chmod 600 "$API_FILE"
chown root:root "$API_FILE"


# Limpeza

printf "${CIANO}Limpando arquivos temporários...${RESET}\n"

if [[ -n "$TEMP_DIR" && -d "$TEMP_DIR" ]]; then
    rm -rf "$TEMP_DIR"
    TEMP_DIR=""
fi


# API do VirusTotal

printf "${CIANO}API do VirusTotal (opcional)${RESET}\n"
printf "Arquivo: %s\n" "$API_FILE"
printf "Obtenha a chave em: https://www.virustotal.com/gui/my-apikey\n"

resp=""

if [[ -t 0 ]]; then
    read -r -p "Gostaria de adicionar sua API do VirusTotal? (s/n): " resp || resp=""
fi

resp="$(printf '%s' "$resp" | tr '[:upper:]' '[:lower:]')"

case "$resp" in

s|sim|y|yes)

    api=""

    read -r -s -p "Digite sua API (não será exibida): " api || api=""
    printf "\n"

    api="$(printf '%s' "$api" | tr -d '[:space:]')"

    if [[ -z "$api" ]]; then

        printf "${AMARELO}Chave vazia. Nada foi gravado.${RESET}\n"

        if [[ -n "$OLD_API" ]]; then
            printf '%s\n' "$OLD_API" > "$API_FILE"
            chmod 600 "$API_FILE"
        fi

    else

        printf '%s\n' "$api" > "$API_FILE"
        chmod 600 "$API_FILE"
        printf "${VERDE}API adicionada com sucesso!${RESET}\n"

    fi

    ;;

*)

    if [[ -n "$OLD_API" ]]; then
        printf '%s\n' "$OLD_API" > "$API_FILE"
        chmod 600 "$API_FILE"
    fi

    ;;

esac


# Remoção do instalador

if [[ "$REMOVE_SOURCE" -eq 1 ]]; then

    printf "${CIANO}Removendo instalador...${RESET}\n"

    cd /

    if [[ "$BASE_DIR" != "/" && "$BASE_DIR" != "$HOME" ]]; then
        rm -rf "$BASE_DIR"
    fi

fi


# Final

printf "${VERDE}${APP_NAME} instalado com sucesso!${RESET}\n"

printf "${CIANO}Execute:${RESET}\n"

echo "sct -h"
