#!/usr/bin/env bash

# Cores
VERMELHO=$'\033[31m'
VERDE=$'\033[32m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Verificação se a ferramenta está usando root

if [ "$(id -u)" -ne 0 ]; then
    printf "${VERMELHO}Acesso negado${RESET}\n"
    echo "Utilize: sudo sct -h"
    exit 1
fi

# Diretório dos scripts
SOC_DIR="/opt/SOC-Term"
SCRIPT_DIR="$SOC_DIR/scripts"

if [[ ! -d "$SCRIPT_DIR" ]]; then
    printf "${VERMELHO}Instalação não encontrada em %s${RESET}\n" "$SOC_DIR"
    printf "${CIANO}Rode novamente: sudo ./install.sh${RESET}\n"
    exit 1
fi

# Executa um script interno, avisando quando ele estiver ausente
exec_script() {
    local script="$SCRIPT_DIR/$1"
    shift

    if [[ ! -f "$script" ]]; then
        printf "${VERMELHO}Script ausente: %s${RESET}\n" "$script"
        exit 1
    fi

    bash "$script" "$@"
}

case "$1" in

-h|--help)

cat << EOF

SOC-Term - Ferramenta para análise de segurança
Criado por: Ex3cutor76-V1

Uso:
sudo sct <flag> <argumento>

Apoio:
-h, --help                   Mostra ajuda
-db, --database              Consulta das strings
-lo, --log                   Consulta de logs
-v, --version                Mostra versão da ferramenta
-up, --upgrade               Atualizar a ferramenta

Usuários:
-u, --users                  Mostra uma lista de usuários existentes no sistema

Arquivos:
-st <arquivo>, --string <arquivo>        Análise de strings
-a  <arquivo>, --analyze-hash <arquivo>  Análise de hash
-i  <arquivo>, --information <arquivo>   Informações sobre um arquivo

Logs:
-ssh, --ssh            Logs SSH
-sys, --system         Logs do sistema
-svc, --service        Logs de serviços
-krn, --kernel         Logs do kernel

Serviços:
-se, --analyze-service   Análise de serviços

Processos:
-pr, --process             Análise de processos

Rede:
-p, --ports              Análise de portas TCP/UDP
-l, --lsof               Análise de recursos usando lsof

Engenharia social:
-e, --engineering        Coleta do script assembler de um binário

URL:
-ur, --analyze-url <url>   Análise de URL com VirusTotal

API do VirusTotal:
Edite o arquivo: $SOC_DIR/API/API.txt

EOF

;;

-st|--string)

if [ -z "$2" ]; then
    printf "${VERMELHO}Erro: informe um arquivo.${RESET}\n"
    exit 1
fi

if [[ ! -f "$2" ]]; then
    printf "${VERMELHO}Arquivo inexistente.${RESET}\n"
    exit 1
fi

printf "${CIANO}Permissões do arquivo${RESET}\n"
ls -lh "$2"

exec_script string.sh strings "$2"
;;

-ssh|--ssh)

exec_script logs.sh -ssh
;;

-sys|--system)

exec_script logs.sh -sys
;;

-svc|--service)

exec_script logs.sh -svc
;;

-krn|--kernel)

exec_script logs.sh -krn
;;

-se|--analyze-service|--analize-service)

exec_script services.sh
;;


-pr|--process)

exec_script process.sh
;;


-p|--ports)

exec_script ports.sh
;;


-l|--lsof)

lsof -i -n -P
;;

-db|--database)

exec_script db.sh
;;

--log|-lo)

exec_script logviewer.sh
;;

-v|--version)

echo "Nome: SOC-Term"
echo "Versão 6.2"
;;

-u|--users)

exec_script user.sh
;;

-i|--information)

if [ -z "$2" ]; then
    printf "${VERMELHO}Erro: informe um arquivo.${RESET}\n"
    exit 1
fi

if [[ ! -f "$2" ]]; then
    printf "${VERMELHO}Arquivo inexistente.${RESET}\n"
    exit 1
fi

exec_script info.sh info "$2"
;;

-a|--analyze-hash)

if [ -z "$2" ]; then
    printf "${VERMELHO}Erro: informe um arquivo.${RESET}\n"
    exit 1
fi

if [[ ! -f "$2" ]]; then
    printf "${VERMELHO}Arquivo inexistente.${RESET}\n"
    exit 1
fi

exec_script hash.sh hash "$2"
;;

--upgrade|-up)

if ! command -v git >/dev/null; then
    printf "${VERMELHO}git não encontrado.${RESET}\n"
    printf "${CIANO}Instale o git e tente novamente.${RESET}\n"
    exit 1
fi

printf "${AMARELO}Clonando a versão mais recente...${RESET}\n"

CLONE_DIR="$(mktemp -d)"

if ! git clone --depth 1 https://github.com/Ex3cutor76-V1/SOC-Term.git "$CLONE_DIR/SOC-Term"; then
    printf "${VERMELHO}Falha ao clonar o repositório.${RESET}\n"
    rm -rf "$CLONE_DIR"
    exit 1
fi

printf "${AMARELO}Instalando nova versão...${RESET}\n"

if ! bash "$CLONE_DIR/SOC-Term/install.sh"; then
    printf "${VERMELHO}Falha na atualização.${RESET}\n"
    rm -rf "$CLONE_DIR"
    exit 1
fi

rm -rf "$CLONE_DIR"

printf "${VERDE}Atualização completa!${RESET}\n"
;;

-ur|--analyze-url)

if [ -z "$2" ]; then
    printf "${VERMELHO}Erro: informe uma URL.${RESET}\n"
    printf "${CIANO}Use: sudo sct -ur https://exemplo.com${RESET}\n"
    exit 1
fi

exec_script virustotal.sh "$2"
;;

-e|--engineering)
exec_script eng.sh "$2"
;;

*)
printf "${VERMELHO}Comando inválido.${RESET}\n"
printf "${CIANO}Use: sudo sct -h${RESET}\n"
exit 1
;;

esac
