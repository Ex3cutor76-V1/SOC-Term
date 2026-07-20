#!/usr/bin/env bash

# Cores
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Diretório dos scripts
SOC_DIR="/opt/SOC-Term"
SCRIPT_DIR="$SOC_DIR/scripts"


case "$1" in

-h|--help)

cat << EOF

SOC-Term - Ferramenta de análise Blue Team

Uso:
sct <flag> <argumento>


Apoio:
-h              Mostra ajuda
update          Atualiza ferramenta


Strings:
-st <arquivo>   Análise de strings


Logs:
-ssh            Logs SSH
-sys            Logs do sistema
-svc            Logs de serviços


Serviços:
-se             Análise de serviços


Processos:
-pr             Análise de processos


Rede:
-p              Análise de portas TCP/UDP
-l              Análise de recursos usando lsof

EOF

;;

-st)

if [ -z "$2" ]; then
    printf "${VERMELHO}Erro: informe um arquivo.${RESET}\n"
    exit 1
fi

bash "$SCRIPT_DIR/string.sh" strings "$2"

;;


-ssh)

bash "$SCRIPT_DIR/logs.sh" -ssh

;;


-sys)

bash "$SCRIPT_DIR/logs.sh" -sys

;;


-svc)

bash "$SCRIPT_DIR/logs.sh" -svc

;;


-se)

bash "$SCRIPT_DIR/services.sh"

;;


-pr)

bash "$SCRIPT_DIR/process.sh"

;;


-p)

bash "$SCRIPT_DIR/ports.sh"

;;


-l)

sudo lsof -i -n -P

;;


update)
cd "/opt/"
sudo rm -rf "SOC-Term/"
git clone https://github.com/Ex3cutor76-V1/SOC-Term.git
cd /$HOME/SOC-Term
printf "${CIANO}Atualização completa!${RESET}\n"
;;


*)

printf "${VERMELHO}Comando inválido.${RESET}\n"
printf "${CIANO}Use: sct -h${RESET}\n"

;;

esac
