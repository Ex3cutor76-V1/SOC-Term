#!/usr/bin/env bash

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
CIANO=$'\033[36m'
VERDE=$'\033[32m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Funções importantes

kernel() {

arquivo=$(ls -t /opt/SOC-Term/logs/log-krn-*.txt 2>/dev/null | head -n1)

if [[ -n "$arquivo" ]]; then
printf "${VERDE}O arquivo existe!${RESET}\n"
printf "${MAGENTA}======KERNEL======${RESET}\n"
printf "${AMARELO}Iniciando leitura...${RESET}\n"
sleep 1
less "$arquivo"
else
printf "${VERMELHO}O arquivo não existe.${RESET}\n"
fi

}

ssh() {

arquivo2=$(ls -t /opt/SOC-Term/logs/log-ssh-*.txt 2>/dev/null | head -n1)

if [[ -n "$arquivo2" ]]; then
printf "${VERDE}O arquivo existe!${RESET}\n"
printf "${MAGENTA}======SSH======${RESET}\n"
printf "${AMARELO}Iniciando leitura...${RESET}\n"
sleep 1
less "$arquivo2"
else
printf "${VERMELHO}O arquivo não existe...${RESET}\n"
fi

}

service() {

arquivo3=$(ls -t /opt/SOC-Term/logs/log-svc-*.txt 2>/dev/null | head -n1)

if [[ -n "$arquivo3" ]]; then
printf "${VERDE}O arquivo existe!${RESET}\n"
printf "${MAGENTA}======SERVIÇO======${RESET}\n"
printf "${AMARELO}Iniciando leitura.${RESET}\n"
sleep 1
less "$arquivo3"
else
printf "${VERMELHO}O arquivo não existe.${RESET}\n"
fi

}

system() {

arquivo4=$(ls -t /opt/SOC-Term/logs/log-sys-*.txt 2>/dev/null | head -n1)

if [[ -n "$arquivo4" ]]; then
printf "${VERDE}O arquivo existe!${RESET}\n"
printf "${MAGENTA}======SISTEMA======${RESET}\n"
printf "${AMARELO}Iniciando leitura...${RESET}\n"
sleep 1
less "$arquivo4"
else
printf "${VERMELHO}O arquivo não existe.${RESET}\n"
fi

}

# Inicio da consulta
while true; do
if [ -d "/opt/SOC-Term/logs" ]; then
    ls -lh /opt/SOC-Term/logs/
fi

printf "${MAGENTA}Use: k (Kernel), sy (Sistema), se (Serviço), ss (SSH), q (Sair) ou c (Limpar)${RESET}\n"
read -p "${CIANO}Qual arquivo gostaria de consultar?${RESET}" opc
opc=${opc,,}

case "$opc" in

k)
kernel
;;
sy)
system
;;
se)
service
;;
ss)
ssh
;;
c)
read -p "${CIANO}Você tem certeza? (s/n): " resp
resp=${resp,,}
if [[ "$resp" == "s" || "$resp" == "sim" ]]; then
sudo rm -f /opt/SOC-Term/logs/*.txt
printf "${VERDE}Limpeza completa!${RESET}\n"
else
printf "${MAGENTA}Nenhum arquivo foi apagado, pode ficar calmo${RESET}\n"
fi
;;
q)
break
;;
*)
printf "${VERMELHO}Opção inválida${RESET}\n"
;;

esac
done
