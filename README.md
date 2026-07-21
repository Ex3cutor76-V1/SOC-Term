# O que é o SOC-Term?

O SOC-Term é uma ferramenta CLI voltada para Analistas de SOC, com o objetivo de facilitar as análises de segurança em ambientes Linux. Ele reúne verificações comuns realizadas durante as triagens de segurança, permitindo essas funcionalidades:

## Funcionalidades

*Análise de Logs*

  * Sistema
  * SSH
  * Serviços

  *Análise de Rede*

  * Identificação de portas TCP
  * Identificação de portas UDP

  *Monitoramento*

  * Processos em execução
  * Serviços ativos

  *Extração de Indicadores (IoCs)*

  * Endereços IP
  * URLs
  * Endereços de e-mail

## Dependências:
Na maioria das instalações não é necessário instalar as dependências manualmente, pois o script `install.sh` realiza automaticamente essa etapa.
O SOC-Term utiliza ferramentas já presentes no sistema Linux para realizar suas análises, mantendo poucas dependências externas:

```bash 
sudo apt install unzip lsof 
```

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

## Comandos:
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


