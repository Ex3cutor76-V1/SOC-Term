# O que é o SOC-Term?
O SOC-Term é uma ferramenta CLI voltada para análises de SOC, com o objetivo de facilitar análises de segurança em ambientes Linux.
 Ele reúne verificações comuns realizadas durante as triagens de segurança.

## Funcionalidades

### Análise de Logs
Realiza análise e coleta de informações presentes em logs do sistema:

  * Sistema
  * SSH
  * Serviços

### Análise de Rede
Auxilia na identificação de informações relacionadas à rede:

  * Identificação de portas TCP
  * Identificação de portas UDP

### Monitoramento
Permite visualizar informações sobre o estado atual do sistema:

  * Processos em execução
  * Serviços ativos

### Extração de Indicadores de Comprometimento(IoCs)
Realiza extração de possíveis indicadores encontrados em arquivos:

  * Endereços IP
  * URLs
  * Endereços de e-mail

## Dependências
O SOC-Term utiliza principalmente ferramentas já presentes no sistema Linux para realizar suas análises, mantendo poucas dependências externas:

```bash 
sudo apt install unzip lsof 
```
OBS: Esses pacotes normalmente são instalados automaticamente pelo `install.sh`.
As dependências utilizadas no SOC-Term servem para:

`unzip`: Utilizado no processo de instalação.
`lsof`: Utilizado para análises de arquivos, processos e recursos em uso.

## Instalação
Clone o repositório:
```bash 
git clone https://github.com/Ex3cutor76-V1/SOC-Term.git
```
Inicia o script:
```bash
cd SOC-Term
sudo ./install.sh
```

## Comandos
| Comando | Descrição |
| --------|-----------|
| `sct -h`| Mostra os comandos |
| `sct -st <arquivo>` | Faz análise de strings de um arquivo |
| `sct -ssh` | Cria um arquivo txt com os logs envolvendo SSH |
| `sct -sys` | Cria um arquivo txt com os logs envolvendo o sistema |
| `sct -svc` | Cria um arquivo txt com os logs envolvendo os serviços |
| `sct -se` | Faz a análise de serviços rodando |
| `sct -pr` | Faz anáise de processos |
| `sct -p` | Faz análise de portas TCP e UDP |
| `sct -l` | Faz a análise de recursos com o lsof |


