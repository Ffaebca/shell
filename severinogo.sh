#!/bin/bash
go=$(zenity --list \
--title="R1" \
--text="Selecione uma opção:" \
--radiolist \
--column=""  --column="Opçoes:" --width=700 --height=600 \
FALSE "Verifica porta-A" \
FALSE "Verifica porta-B" \
FALSE "Encontrar subdomínios-gobuster" \
FALSE "Encontrar subdomínios-for" \
FALSE "Encontrar subdommínios-curl" \
FALSE "Encontrar subdomínios-subfinder" \
FALSE "Mudar inicio de de subdominios de wordlist" \
FALSE "Usar o httpx-toolkit sem ip" \
FALSE "Usar o httpx-toolkit com ip" \
FALSE "Retornar o HTTP headers" \
FALSE "Retornar o código fonte de um site" \
FALSE "Wafw00f - verificar waf" \
FALSE "Gobuster-dir normal" \
FALSE "Gobuster-dir-arquivo" \
FALSE "Gobuster-proxy" \
FALSE "Gobuster-dir-contrabarra" \
TRUE  "Sair" )

case $go in

"Verifica porta-A")
# Define a faixa de IPs que será escaneada
# Executa o curl com o User-Agent especificado (-A) e timeout curto (-m)
    # -I: Obtém apenas o cabeçalho HTTP
    # -s: Modo silencioso, oculta a barra de progresso do curl
    # -A: Define o User-Agent
	# -m 1: define o tempo limite de 1 segundo
    # --connect-timeout 2: Define o tempo limite 2 de conexão para evitar que o script trave em hosts inacessíveis
# Define a faixa de IPs que será escaneada

# Define a faixa de IP inicial e final e a porta alvo como parâmetros do script
FAIXA_IP_INICIAL=$(zenity --entry  --title "ip" --text "Digite faixa de ip inicial")
FAIXA_IP_FINAL=$(zenity --entry  --title "ip" --text "Digite faixa de ip final")
PORTA=$(zenity --entry  --title "ip" --text "Digite a porta ")

# Define o User-Agent personalizado
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.36"

echo "Iniciando scan na faixa de IPs $FAIXA_IP_INICIAL até $FAIXA_IP_FINAL na porta $PORTA com User-Agent: $USER_AGENT"

# Extrai o prefixo da rede (ex: 192.168.1)
PREFIXO=$(echo "$FAIXA_IP_INICIAL" | cut -d '.' -f 1-3)

# Extrai o último octeto dos IPs
OCTETO_INICIAL=$(echo "$FAIXA_IP_INICIAL" | cut -d '.' -f 4)
OCTETO_FINAL=$(echo "$FAIXA_IP_FINAL" | cut -d '.' -f 4)

# Loop pelos endereços IP na faixa especificada
for i in $(seq "$OCTETO_INICIAL" "$OCTETO_FINAL"); do
    IP_ALVO="$PREFIXO.$i"
    
    # Executa o curl com o User-Agent especificado (-A) e timeout curto (-m)
    # -I: Obtém apenas o cabeçalho HTTP
    # -s: Modo silencioso, oculta a barra de progresso do curl
    # -A: Define o User-Agent
    # --connect-timeout: Define o tempo limite de conexão para evitar que o script trave em hosts inacessíveis
    
    resposta=$(curl -Is -A  "$USER_AGENT"  --connect-timeout 2 "http://$IP_ALVO:$PORTA" )

    if [ $? -eq 0 ]; then
        echo "Host $IP_ALVO (Porta $PORTA): ABERTA/RESPONDENDO"
        # Opcional: Mostrar parte da resposta ou cabeçalho para mais detalhes
        # echo "$resposta"
    else
        echo "Host $IP_ALVO (Porta $PORTA): FECHADA/OFFLINE"
    fi
done

echo "Scan concluído."

;;
 "Verifica porta-B")
# Define a faixa de IPs que será escaneada
FAIXA_IP=$(zenity --entry  --title "ip" --text "Digite os três primeiros número do ip:")
PORTA=$(zenity --entry  --title "ip" --text "Digite a porta:")
# Define o user agent personalizado
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.36"
# Loop para iterar sobre os últimos dígitos dos IPs (ex: 1 a 254)
for i in {212..218}; do
IP="${FAIXA_IP}.${i}"
# Mostra o IP que está sendo testado
 echo "Tentando conectar a http://${IP}:${PORTA}..."
# Utiliza o cURL com o user agent customizado (-A) e outras opções para um
#teste mais rápido:
# -m 2: tempo limite (timeout) de 2 segundos para cada requisição.
# -s: modo silencioso para não mostrar a barra de progresso.
# -o /dev/null: descarta a saída (resposta do servidor), pois só queremos o
#cabeçalho.
# -I: faz uma requisição HEAD, que é mais rápida que uma GET completa.
# -w "%{http_code}": imprime o código de status HTTP da resposta.
# --connect-timeout 2: define o tempo limite para a conexão, evitando longas
#esperas.
HTTP_STATUS=$(curl -m 2 -s -o /dev/null -I -w "%{http_code}" --connect-timeout 2 -A "$USER_AGENT" "http://${IP}:${PORTA}")
# Verifica se o código de status HTTP indica sucesso (códigos 2xx ou 3xx)
if [[ "$HTTP_STATUS" =~ ^(2|3)[0-9]{2}$ ]] ; then
 echo "Serviço HTTP ativo em http://${IP}:${PORTA} (Código: $HTTP_STATUS)"
fi
done
echo "Varredura concluída."
;;
"Encontrar subdomínios-gobuster")
# --- Configuração Ética para Rede Local ---
# 1. Garanta que você tem permissão para testar o domínio e a rede.
# 2. Varreduras excessivas podem sobrecarregar o DNS ou a rede.
# 3. As opções a seguir simulam um comportamento mais "humano" e menosagressivo.
# Defina o domínio local que você tem permissão para testar

#OPTIONS:
#   --domain value, --do value            The target domain
#  --check-cname, -c                     Also check CNAME records (default: false)
#   --timeout value, --to value           DNS resolver timeout (default: 1s)
#  --wildcard, --wc                      Force continued operation when wildcard found (default: false)
#  --no-fqdn, --nf                       Do not automatically add a trailing dot to the domain, so the resolver uses the DNS search domain (default: false)
#   --resolver value                      Use custom DNS server (format server.com or server.com:port)
#  --protocol value                      Use either 'udp' or 'tcp' as protocol on the custom resolver (default: "udp")
#   --wordlist value, -w value            Path to the wordlist. Set to - to use STDIN.
#  --delay value, -d value               Time each thread waits between requests (e.g. 1500ms) (default: 0s)
#  --threads value, -t value             Number of concurrent threads (default: 10)
#  --wordlist-offset value, --wo value   Resume from a given position in the wordlist (default: 0)
#  --output value, -o value              Output file to write results to (defaults to stdout)
#  --quiet, -q                           Don't print the banner and other noise (default: false)
#  --no-progress, --np                   Don't display progress (default: false)
#  --no-error, --ne                      Don't display errors (default: false)
#  --pattern value, -p value             File containing replacement patterns
#  --discover-pattern value, --pd value  File containing replacement patterns applied to successful guesses
#  --no-color, --nc                      Disable color output (default: false)
#  --debug                               enable debug output (default: false)
#  --help, -h                            show help
#
DOMAIN=$(zenity --entry  --title "ip" --text "Digite o nome do domínio:")
# Caminho para a wordlist de subdomínios do SecList
# Altere o caminho se o seu SecList estiver em outro diretório
WORDLIST=$(zenity --file-selection --title "Seleção de arquivo" --filename="/usr/share/seclists/Discovery/DNS/")
# Defina um User-Agent para simular um navegador comum
# Isso ajuda a evitar que o servidor detecte um comportamento incomum de scanner
#USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.36"
# Define o número de threads (taxa de requisições)
# Um valor baixo (ex: 10) é menos invasivo para a rede local
THREADS=$(zenity --entry  --title "Threads" --text "Digite um valor para o THREADS:")
# Arquivo para salvar a saída do Gobuster
OUTPUT_FILE=$(zenity --entry  --title "NOME-LISTA.TXT" --text "digite o nome da lista de subdomínios.txt":)
echo "Iniciando varredura de subdomínios em $DOMAIN na rede local..."
echo "A wordlist utilizada é: $WORDLIST"
# Executa o Gobuster com o modo DNS e parâmetros avançados
# -d: define o domínio alvo
# -w: define a wordlist
# -t: define o número de threads
# -a: define o User-Agent
# -o: salva a saída em um arquivo
# -p: parametro para usar um proxy. 
sleep 2
gobuster dns --domain  "$DOMAIN" --wordlist "$WORDLIST" --threads "$THREADS" --ne  --output "$OUTPUT_FILE"
# Verifica se o comando foi executado com sucesso e se encontrou resultados
if [ -s "$OUTPUT_FILE" ]; then
echo "Varredura concluída. Subdomínios encontrados salvos em $OUTPUT_FILE."
echo "--- Resultados ---"
cat "$OUTPUT_FILE"
else
echo "Varredura concluída, mas nenhum subdomínio encontrado."
fi
;;
"Encontrar subdomínios-for")
for i in $(cat dns-teste) ; do host $i.corpnetwork.com.br; done | grep -v "not found" 
;;
"Encontrar subdommínios-curl")
# Define subdominios a ser escaneados
dominio=$(zenity --entry  --title "Dominio" --text "Digite o dominio:")
WORDLIST=$(zenity --file-selection --title "Seleção de arquivo" --filename="/usr/share/seclists/Discovery/DNS/")
# Define o user agent personalizado
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.36"
# Loop para iterar sobre os últimos dígitos dos IPs (ex: 1 a 254)
for i in $(cat $WORDLIST); do
# Utiliza o cURL com o user agent customizado (-A) e outras opções para um
#teste mais rápido:
# -m 2: tempo limite (timeout) de 2 segundos para cada requisição.
# -s: modo silencioso para não mostrar a barra de progresso.
# -o /dev/null: descarta a saída (resposta do servidor), pois só queremos o
#cabeçalho.
# -I: faz uma requisição HEAD, que é mais rápida que uma GET completa.
# -w "%{http_code}": imprime o código de status HTTP da resposta.
# --connect-timeout 2: define o tempo limite para a conexão, evitando longas
#esperas.

# Mostra o domínio que está sendo testado
sleep 1
 echo "Tentando conectar a ${i}.${dominio}..."
HTTP_STATUS=$(curl -m 2 -s -o /dev/null -I -w "%{http_code}" --connect-timeout 2 -A "$USER_AGENT" "${i}.${dominio}")
# Verifica se o código de status HTTP indica sucesso (códigos 2xx ou 3xx)
if [[ "$HTTP_STATUS" =~ ^(2|3)[0-9]{2}$ ]] ; then
 echo "Serviço HTTP ativo em ${i}.${dominio} (Código: $HTTP_STATUS)" >> sub.txt
fi
done
echo "Varredura concluída."
echo "subdomínios enviados para o arquivo sub.txt"
;;
"Encontrar subdomínios-subfinder")
dominio=$(zenity --entry  --title "Dominio" --text "Digite o dominio:")
subfinder -all  -d  "$dominio" -silent  -o sub.txt
echo "foi criado um arquivo chamado sub.txt "
;;
"Mudar inicio de de subdominios de wordlist")
zenity --info --title="Dica" --text="use o comando cat wordlist | sed 's/^/subdominio./' > wordlist2" --no-wrap
;;
"Usar o httpx-toolkit sem ip")
lista=$(zenity --entry  --title "Dominio" --text "Digite o nome da lista com subdomínios:")
httpx-toolkit -l "$lista" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.36" -silent > sites.txt
zenity --info --title="n=Nova lista" --text="A lista sites.txt foi criada" --no-wrap
;;
"Usar o httpx-toolkit com ip")
lista=$(zenity --entry  --title "Dominio" --text "Digite o nome da lista com subdomínios:")
httpx-toolkit -l "$lista" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.36" -silent -ip > sitesip.txt
zenity --info --title="n=Nova lista" --text="A lista sitesip.txt foi criada" --no-wrap
;;
"Retornar o HTTP headers")
site=$(zenity --entry  --title "Dominio" --text "Digite o endereço http ou https do site:")
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.36"
curl "${site}" -A "$USER_AGENT"  -I
;;
"Retornar o código fonte de um site")
site=$(zenity --entry  --title "Dominio" --text "Digite o endereço http ou https do site:")
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.36"
curl  "${site}" -A "$USER_AGENT"  
;;
"Wafw00f - verificar waf")
site=$(zenity --entry  --title "Dominio" --text "Digite o endereço http ou https do site:")
verbose=$(zenity --entry --title "Verbose" --text "escolha a quantidade de verbose" " " v vv vvv)
wafw00f -a -r "$site"  -"$verbose"
;;
"Gobuster-dir normal")
# --- Configuração Ética para Rede Local ---
# 1. Garanta que você tem permissão para testar o domínio e a rede.
# 2. Varreduras excessivas podem sobrecarregar o DNS ou a rede.
# 3. As opções a seguir simulam um comportamento mais "humano" e menos agressivo.
# Defina o domínio local que você tem permissão para testar
DOMAIN=$(zenity --entry  --title "Dominio" --text "Digite o nome do domínio")
# Caminho para a wordlist de subdomínios do SecList
# Altere o caminho se o seu SecList estiver em outro diretório
WORDLIST=$(zenity --file-selection --title "SELECIONE COMMON.TXT" --filename="/usr/share/seclists/Discovery/DNS/")
# Defina um User-Agent para simular um navegador comum
# Isso ajuda a evitar que o servidor detecte um comportamento incomum de scanner
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.36"
# Define o número de threads (taxa de requisições)
# Um valor baixo (ex: 10) é menos invasivo para a rede local
THREADS=$(zenity --entry  --title "Threads" --text "Digite um valor para o THREADS:")
# Arquivo para salvar a saída do Gobuster
OUTPUT_FILE=$(zenity --entry  --title "NOME-LISTA.TXT" --text "digite o nome da lista de diretórios.txt":)
echo "Iniciando varredura de subdomínios em $DOMAIN na rede local..."
echo "A wordlist utilizada é: $WORDLIST"
# Executa o Gobuster com o modo DNS e parâmetros avançados
# -d: define o domínio alvo
# -w: define a wordlist
# -t: define o número de threads
# -a: define o User-Agent
# -o: salva a saída em um arquivo
gobuster dns -d "$DOMAIN" -w "$WORDLIST" -t "$THREADS" -a "$USER_AGENT" -o "$OUTPUT_FILE"
# Verifica se o comando foi executado com sucesso e se encontrou resultados
if [ -s "$OUTPUT_FILE" ]; then
echo "Varredura concluída. Subdomínios encontrados salvos em $OUTPUT_FILE."
echo "--- Resultados ---"
cat "$OUTPUT_FILE"
else
echo "Varredura concluída, mas nenhum subdomínio encontrado."
fi
;;
"Gobuster-dir-arquivo")
# --- Configuração Ética para Varredura de Diretórios em Rede Local ---
# 1. Tenha permissão explícita para testar o alvo.
# 2. A varredura deve ser realizada em ambiente controlado para não sobrecarregar o servidor.
# 3. Este script usa um alvo local de exemplo; substitua-o pelo seu alvo autorizado.
# Defina a URL completa do alvo local. 
TARGET_URL=$(zenity --entry  --title "Dominio" --text "Digite o nome do domínio")
# Caminho para a wordlist de diretórios do SecList.
# Altere o caminho se o seu SecList estiver em outro diretório.
WORDLIST=$(zenity --file-selection --title "Seleção de arquivo" --filename="/usr/share/seclists/Discovery/DNS/")
# Defina um User-Agent para simular um navegador comum.
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.36"
# Define o número de threads (taxa de requisições). Um valor baixo é menosinvasivo.
THREADS=$(zenity --entry  --title "Threads" --text "Digite um valor para o THREADS:")
# Arquivo para salvar a saída do Gobuster.
OUTPUT_FILE=$(zenity --entry  --title "NOME-LISTA.TXT" --text "digite o nome da lista de diretórios.txt":)
echo "Iniciando varredura de diretórios em $TARGET_URL na rede local..."
echo "A wordlist utilizada é: $WORDLIST"
# Executa o Gobuster com o modo "dir" para varredura de diretórios e arquivos.
# -u: define a URL alvo.
# -w: define a wordlist.
# -t: define o número de threads.
# -a: define o User-Agent.
# -o: salva a saída em um arquivo.
# --delay: adiciona um atraso de 100ms entre as requisições, tornando-as menosagressivas.
# -x: especifica extensões de arquivo comuns para buscar (ex: .php, .html).
gobuster dir -u "$TARGET_URL" -w "$WORDLIST" -t "$THREADS" -a "$USER_AGENT" --delay 100ms -o "$OUTPUT_FILE" -x php,html,txt,js
# Verifica se o comando foi executado com sucesso e se encontrou resultados.
if [ -s "$OUTPUT_FILE" ]; then
echo "Varredura concluída. Diretórios e arquivos encontrados salvos em $OUTPUT_FILE."
echo "--- Resultados ---"
cat "$OUTPUT_FILE"
else
echo "Varredura concluída, mas nenhum diretório ou arquivo encontrado."
fi
;;
"Gobuster-proxy")
# --- Configuração Ética para Varredura de Diretórios com Proxy ---
# 1. Tenha permissão explícita para testar o alvo e a configuração de proxy.
# 2. Varreduras com proxy devem ser realizadas em ambientes controlados.
# 3. Este script usa um alvo local de exemplo; substitua-o pelo seu alvo autorizado.
# Defina a URL completa do alvo local.
TARGET_URL=$(zenity --entry  --title "Dominio" --text "Digite o endereço http ou https do site:")
# Caminho para a wordlist de diretórios do SecList.
WORDLIST=$(zenity --file-selection --title "Seleção de arquivo" --filename="/usr/share/seclists/Discovery/DNS/")
# Defina um User-Agent para simular um navegador comum.
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.36"
# Define o número de threads.
THREADS=$(zenity --entry  --title "Threads" --text "Digite um valor para o THREADS:")
# Arquivo para salvar a saída do Gobuster.
OUTPUT_FILE=(zenity --entry  --title "NOME-LISTA.TXT" --text "digite o nome da lista de diretórios.txt":)
# --- Configuração do Proxy ---
# Defina o endereço e a porta do seu proxy.
# Exemplo para Burp Suite ou OWASP ZAP rodando localmente (127.0.0.1:8080).
# Para usar, remova o '#' da linha abaixo e ajuste conforme necessário.
# PROXY_URL="http....ip:8080 "
PROXY_URL="" # Deixe vazio se não for usar proxy
# Constrói o comando Gobuster com ou sem a flag de proxy
GOBUSTER_CMD="gobuster dir -u \"$TARGET_URL\" -w \"$WORDLIST\" -t \"$THREADS\" -a \"$USER_AGENT\" --delay 100ms -o \"$OUTPUT_FILE\" -x php,html,txt"
if [ -n "$PROXY_URL" ]; then
GOBUSTER_CMD+=" -p \"$PROXY_URL\""
echo "Iniciando varredura com proxy ($PROXY_URL) em $TARGET_URL..."
else
echo "Iniciando varredura sem proxy em $TARGET_URL..."
fi
echo "A wordlist utilizada é: $WORDLIST"
# Executa o Gobuster
eval $GOBUSTER_CMD
# Verifica se o comando foi executado com sucesso e se encontrou resultados
if [ -s "$OUTPUT_FILE" ]; then
echo "Varredura concluída. Diretórios e arquivos encontrados salvos em $OUTPUT_FILE."
echo "--- Resultados ---"
cat "$OUTPUT_FILE"
else
echo "Varredura concluída, mas nenhum diretório ou arquivo encontrado."
fi
;;
"Gobuster-dir-contrabarra")
#RETIRANDO A PRIMEIRA PALAVRA DE UMA LISTA
# Modificando lista1
lista1=$(zenity --file-selection --title "LISTA FINAL.TXT" --filename=".")
cat "$lista1" | cut -d . -f 1 > scandir
# Selecionando lista2 scandir
lista2=$(zenity --file-selection --title "SELECIONE SCANDIR" --filename=".")
# Scaneando o dominio
dominio=$(zenity --entry  --title "Dominio" --text "Digite o dominio:")
gobuster dir -u "$dominio" -w "$lista2" --random-agent -f 
;;
"Sair")
clear
exit
esac
