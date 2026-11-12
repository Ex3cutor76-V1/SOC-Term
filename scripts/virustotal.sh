#!/usr/bin/env bash

set -u

# Cores
MAGENTA=$'\033[35m'
VERMELHO=$'\033[31m'
VERDE=$'\033[32m'
CIANO=$'\033[36m'
AMARELO=$'\033[33m'
RESET=$'\033[0m'

# Variáveis importantes
SOC_DIR="/opt/SOC-Term"
API_FILE="$SOC_DIR/API/API.txt"

URL="${1:-}"

CONNECT_TIMEOUT=10
MAX_TIME=60
TENTATIVAS=12
INTERVALO=5

# Dependências
for cmd in curl jq; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        printf "${VERMELHO}Dependência ausente: %s${RESET}\n" "$cmd"
        exit 1
    fi
done

# Verificação da URL
if [[ -z "$URL" ]]; then
    printf "${VERMELHO}Erro: informe uma URL.${RESET}\n"
    printf "${CIANO}Use: sudo sct -ur https://exemplo.com${RESET}\n"
    exit 1
fi

if [[ ! "$URL" =~ ^https?:// ]]; then
    printf "${VERMELHO}URL inválida: use http:// ou https://.${RESET}\n"
    exit 1
fi

# Verificação de API
if [[ ! -f "$API_FILE" ]]; then
    printf "${VERMELHO}API não adicionada.${RESET}\n"
    printf "${CIANO}Crie o arquivo e grave sua chave:${RESET}\n"
    printf "  sudo sh -c 'echo SUA_CHAVE > %s'\n" "$API_FILE"
    printf "  sudo chmod 600 %s\n" "$API_FILE"
    exit 1
fi

API="$(head -n 1 "$API_FILE" | tr -d '\r' | tr -d '[:space:]')"

if [[ -z "$API" ]]; then
    printf "${VERMELHO}API não adicionada.${RESET}\n"
    printf "${AMARELO}Arquivo vazio: %s${RESET}\n" "$API_FILE"
    exit 1
fi

printf "${VERDE}API adicionada.${RESET}\n"


# Requisição para a API do VirusTotal. Devolve o corpo seguido do código HTTP.
vt_request() {
    local metodo="$1"
    local endpoint="$2"
    shift 2

    curl -sS \
        --connect-timeout "$CONNECT_TIMEOUT" \
        --max-time "$MAX_TIME" \
        -X "$metodo" \
        "https://www.virustotal.com/api/v3$endpoint" \
        -H "x-apikey: $API" \
        "$@" \
        -w '\n%{http_code}' 2>/dev/null
}

# Traduz o erro devolvido pela API em uma linha legível
vt_erro() {
    local corpo="$1"
    local codigo="$2"

    case "$codigo" in

    401)
        printf "Chave de API inválida ou revogada.\n"
        ;;

    403)
        printf "Chave sem permissão para esta consulta.\n"
        ;;

    404)
        printf "Recurso não encontrado na API.\n"
        ;;

    429)
        printf "Limite de requisições do VirusTotal atingido. Tente mais tarde.\n"
        ;;

    *)
        local mensagem
        mensagem="$(printf '%s' "$corpo" | jq -r '.error.message // empty' 2>/dev/null)"

        if [[ -n "$mensagem" ]]; then
            printf "HTTP %s: %s\n" "$codigo" "$mensagem"
        else
            printf "Falha na requisição (HTTP %s).\n" "$codigo"
        fi
        ;;

    esac
}


# Envio da URL para análise

printf "${AMARELO}Enviando URL para análise...${RESET}\n"

RESPONSE="$(vt_request POST "/urls" --data-urlencode "url=$URL")"

if [[ -z "$RESPONSE" ]]; then
    printf "${VERMELHO}Falha de rede ao contatar o VirusTotal.${RESET}\n"
    exit 1
fi

HTTP_CODE="${RESPONSE##*$'\n'}"
BODY="${RESPONSE%$'\n'*}"

if [[ "$HTTP_CODE" != "200" ]]; then
    printf "${VERMELHO}Erro ao iniciar análise de URL.${RESET}\n"
    vt_erro "$BODY" "$HTTP_CODE"
    exit 1
fi

# Coletando ID
ANALYSIS_ID="$(printf '%s' "$BODY" | jq -r '.data.id // empty' 2>/dev/null)"

if [[ -z "$ANALYSIS_ID" ]]; then
    printf "${VERMELHO}Resposta inesperada da API: nenhum ID de análise.${RESET}\n"
    exit 1
fi


# Consulta para concluir, com limite de tentativas

STATUS=""
RESULT=""

for ((i=1; i<=TENTATIVAS; i++)); do

    printf "${AMARELO}Consultando análise (%d/%d)...${RESET}\n" "$i" "$TENTATIVAS"

    RESPONSE="$(vt_request GET "/analyses/$ANALYSIS_ID")"

    if [[ -z "$RESPONSE" ]]; then
        printf "${VERMELHO}Falha de rede na consulta da análise.${RESET}\n"
        exit 1
    fi

    HTTP_CODE="${RESPONSE##*$'\n'}"
    RESULT="${RESPONSE%$'\n'*}"

    if [[ "$HTTP_CODE" != "200" ]]; then
        printf "${VERMELHO}Falha na consulta de análise.${RESET}\n"
        vt_erro "$RESULT" "$HTTP_CODE"
        exit 1
    fi

    STATUS="$(printf '%s' "$RESULT" | jq -r '.data.attributes.status // empty' 2>/dev/null)"

    if [[ "$STATUS" == "completed" ]]; then
        break
    fi

    sleep "$INTERVALO"

done

if [[ "$STATUS" != "completed" ]]; then
    printf "${AMARELO}Análise ainda não foi concluída.${RESET}\n"
    printf "${MAGENTA}ID: %s${RESET}\n" "$ANALYSIS_ID"
    printf "${CIANO}Reexecute o comando em alguns instantes.${RESET}\n"
    exit 1
fi


# Após completar análise

echo "================================="
echo "Análise feita:"
echo "================================="
printf "${CIANO}URL:${RESET} %s\n" "$URL"
printf "${MAGENTA}ID:${RESET} %s\n" "$ANALYSIS_ID"

printf '%s' "$RESULT" | jq -r '
(.data.attributes.stats // {}) |
"Malicious:  \(.malicious // 0)",
"Suspicious: \(.suspicious // 0)",
"Harmless:   \(.harmless // 0)",
"Undetected: \(.undetected // 0)",
"Timeout:    \(.timeout // 0)"
'
