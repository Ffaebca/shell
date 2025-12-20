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
FALSE "Gobuster-dir-contrabarra-cut" \
FALSE "Remover os dominios da lista de subdominios-cut" \
FALSE "CURL-GREP" \
FALSE "Wget-baixar-extenssão" \
FALSE "Consulta com o egrep" \
FALSE "Ler arquivo php de diretório" \
FALSE "Ler arquivo php com token" \
FALSE "wfuzz saber filtro" \
FALSE "Wfuzz selecionar filtro" \
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
OUTPUT_FILE=$(zenity --entry  --title "NOME-LISTA.TXT" --text "digite o nome para criar lista de subdomínios.txt":)
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
#instalar o curl -> apt install curl
#instalar o libcurl -> apt install libcurl4-openssl-dev ou apt install libcurl4-gnutls-dev
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
 echo "Serviço HTTP ativo em ${i}.${dominio} (Código: $HTTP_STATUS)" >> sub-curl.txt
fi
done
echo "Varredura concluída."
zenity --info --title="Resultado" --text="subdomínios enviados para o arquivo subc-curl.txt"
cat sub-curl.txt |zenity --title "Conteúdo de: sub-curl.txt" --text-info --editable --width=800 --height=400  2>/dev/null
clear  
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
verbose=$(zenity --entry --title "Verbose" --text "escolha a quantidade de verbose:" " " v vv vvv)
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
url=$(zenity --entry  --title "url" --text "Digite a URL do Site:")
sub=$(zenity --entry  --title "url" --text "Digite o nome do subdiretório: ")
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
gobuster dir -u "$url/$sub" -w "$WORDLIST" -t "$THREADS" -a "$USER_AGENT" --delay 100ms -o "$OUTPUT_FILE" -x php,html,txt,js
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
"Gobuster-dir-contrabarra-cut")
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
"Remover os dominios da lista de subdominios-cut")
WORDLIST=$(zenity --file-selection --title "LISTA FINAL.TXT" --filename=".")
WORDLIST2=$(zenity --entry  --title "WORDLIST2" --text "Digite um nome para a wordlist2:")
cat "$WORDLIST" | cut -d . -f 1 > "$WORDLIST2"
;;
"CURL-GREP")
#USER ATENT:
# Parâmetro ->  -A: Define o User-Agent
#
#USO DE PROXY
#Principais formas de usar proxy com cURL
#Opção de Linha de Comando (-x / --proxy):
#curl -x  hxtp://seu.proxy.com:8080 hxtps://www.google.com
#Use socks4://, socks5://, etc., para proxies SOCKS. 
#curl -x socks5://proxy.example.com:1080 hxtps://www.example.com
#Variáveis de Ambiente:
#Linux/macOS:
#export http_proxy="hxtp://seu.proxy.com:8080"
#export https_proxy="hxtp://seu.proxy.com:8080"
#curl hxtps://www.google.com # cURL usará o proxy automaticamente
#Windows: Use set no CMD ou $env:http_proxy no PowerShell.
#Autenticação:
#Use --proxy-user para nome de usuário e senha:
#curl --proxy-user usuario:senha -x hxtp://seu.proxy.com:8080 hx tps://www.google.com
#Ignorar Proxy:
#Use --noproxy para listar hosts que não devem usar proxy (ex: localhost,127.0.0.1,.meudominio.local).
#Arquivo de Configuração:
#Crie um arquivo .curlrc (ou _curlrc no Windows) com configurações permanentes, como proxy = hxtp://seu.proxy.com:8080.   
url=$(zenity --entry  --title "url" --text "Digite a URL do Site:")
sub=$(zenity --entry  --title "url" --text "Digite o nome do subdiretório: ")
arq=$(zenity --entry  --title "url" --text "Digite o nome do arquivo.php: ")
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.30"
busca=$(zenity --entry  --title "PARAMETRO:href ; .php ; src etc" --text "Digite o parâmetro a buscar:")
 curl -A \""$USER_AGENT"\" "$url/$sub/$arq" | grep "$busca" | zenity --title "Resultado" --text-info --editable  --width=1000 --height=600   2>/dev/null

;;
"Wget-baixar-extenssão")
#1. Usando Variáveis de Ambiente (Método Preferencial)
#O wget respeita automaticamente as variáveis de ambiente http_proxy, https_proxy e ftp_proxy. Esta é a forma mais flexível, pois funciona para qualquer comando wget subsequente na mesma sessão de terminal.
#Você define a variável antes de executar o comando:
#bash
# Para tráfego HTTP
#export http_proxy=hxtp://proxy.example.com:8080
# Para tráfego HTTPS (se necessário um proxy diferente)
#export https_proxy=hxtp://proxy.example.com:8080
# Exemplo de uso:
#wget site.com
#Com autenticação:
#bash
#export http_proxy=hxtp://usuario:senha*arroba*proxy.example.com:8080
#wget site.com
#2. Usando Parâmetros de Linha de Comando
#Se você quiser configurar o proxy apenas para um único comando wget sem afetar sua sessão de terminal, use os parâmetros --proxy e --proxy-user/--proxy-password.
#Sintaxe básica com --proxy=on:
#Você precisa explicitamente ativar o uso do proxy com --proxy=on se ele já não estiver configurado via variáveis de ambiente.
#bash
#wget --proxy=on -e http_proxy=hxtp://proxy.example.com:8080 site.com
#Sintaxe alternativa para proxy/usuário/senha:
#bash
#wget --proxy-user=meuusuario --proxy-password=minhasenha site.com
#Use o código com cuidado.
#3. Desativando o Proxy (Exceção)
#Caso você tenha as variáveis de ambiente configuradas globalmente, mas precise que um comando wget específico não use o proxy, você pode usar o parâmetro --no-proxy.
#bash
#wget --no-proxy site.com
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#Arquivo para configurar um proxy:
#Edite o arquivo ~.wgetrc ou /etc/wgetrc para todo o sistema
#Adicione as linhas (sem export):
#use_proxy = on
#http_proxy = http//seu_proxy_.com:porta
#https_proxy = http//seu_proxy_.com:porta
# PARAMETROS WGET:
# -r -> Recursivo
# -np -> Não permite sair do enderesso passado
# -nd -> Não salvar nem criar diretórios
# -A ->  Extenssão do arquivo
AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/108.0.0.0 Safari/537.30"
diretorio=$(zenity --entry  --title "diretório" --text "Digite o nome do diretório que quer criar:")
mkdir "$diretorio" 
ext=$(zenity --entry  --title "Extenssão" --text "Digite a .extenssão que quer baixar:")
url=$(zenity --entry  --title "url" --text "Digite a URL do Site:")
echo "Entre no diretório $diretorio e cole o comando: wget --user-agent=\""$AGENT"\" -r -np -nd  -A \""$ext"\"  "$url" " > comando.txt
cat comando.txt |zenity --title "Cole dentro de $diretorio" --text-info --editable --width=800 --height=400  2>/dev/null
clear  
;;
"Consulta com o egrep")
#js=$(zenity --file-selection --title "SELECIONE O diretório do ARQUVO JS" --filename="." --directory) \
#p1=$(zenity --entry  --title "Extenssão" --text "Digite o parametro 01:")
#p2=$(zenity --entry  --title "Extenssão" --text "Digite o parametro 02:")
#p3=$(zenity --entry  --title "Extenssão" --text "Digite o parametro 03:")
aq=$(zenity --file-selection --title  "SELECIONE O arquivo do ARQUVO JS" --filename=".") 
egrep "api|token|.php|href|src" $aq |zenity --title "Resultado" --text-info --editable  --width=1000 --height=600   2>/dev/null
clear
;;
"Ler arquivo php de diretório")
url=$(zenity --entry  --title "url" --text "Digite a URL do Site:")
sub=$(zenity --entry  --title "url" --text "Digite o nome do subdiretório: ")
arq=$(zenity --entry  --title "url" --text "Digite o nome do arquivo.php: ")
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.30"

 curl -A \""$USER_AGENT"\" "$url/$sub/$arq" | zenity --title "Resultado" --text-info --editable  --width=1000 --height=600   2>/dev/null
clear
;;
"Ler arquivo php com token")
url=$(zenity --entry  --title "url" --text "Digite a URL do Site:")
sub=$(zenity --entry  --title "url" --text "Digite o nome do subdiretório: ")
arq=$(zenity --entry  --title "url" --text "Digite o nome do arquivo.php: ")
token=$(zenity --entry  --title "url" --text "Dite o token: ")
source=$(zenity --entry  --title "url" --text "Digite o parâmetro a pesquisar: ")
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.30"

 curl -A \""$USER_AGENT"\" "$url/$sub/$arq" --data "token=$token&source=$source" | zenity --title "Resultado" --text-info --editable  --width=1000 --height=600   2>/dev/null
clear
;;
"wfuzz saber filtro")
#FERRAMENTA WFUZZ:
#PARAMETROS:-c → cor
#-w → wordlist
#-d → dados
#-H → User Agent
#--hw → filtrar por palavras
#--hl → filtrar por linhas
#--hc → filtrar por caracteres
url=$(zenity --entry  --title "url" --text "Digite a URL do Site:")
sub=$(zenity --entry  --title "url" --text "Digite o nome do subdiretório: ")
arq=$(zenity --entry  --title "url" --text "Digite o nome do arquivo.php: ")
token=$(zenity --entry  --title "url" --text "Cole o token: ")
tp=$(zenity --entry  --title "url" --text "Dite o tempo da requisição: ")
uagent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.30"
wlist=$(zenity --file-selection --title  "SELECIONE A WORDLIST" --filename=".")
echo wfuzz -c -w "$wlist" -d \""token=$token&source=FUZZ"\" -H \""User-Agent:$uagent" \" -s "$tp" "$url/$sub/$arq" |zenity --title "Copie e cole" --text-info --editable  --width=1000 --height=600 
;;
"Wfuzz selecionar filtro")
url=$(zenity --entry  --title "url" --text "Digite a URL do Site:")
sub=$(zenity --entry  --title "url" --text "Digite o nome do subdiretório: ")
arq=$(zenity --entry  --title "url" --text "Digite o nome do arquivo.php: ")
token=$(zenity --entry  --title "url" --text "Cole o token: ")
tp=$(zenity --entry  --title "url" --text "Dite o tempo da requisição: ")
pr=$(zenity --entry --title "Verbose" --text "Escollha o parametro a ser filtrado:" " " hw hl  hc )
vl=$(zenity --entry  --title "url" --text "digite o valor do parametro a ser filtrado:")
uagent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML,like Gecko) Chrome/108.0.0.0 Safari/537.30"
wlist=$(zenity --file-selection --title  "SELECIONE A WORDLIST" --filename=".")
echo wfuzz -c -w "$wlist" -d \""token=$token&source=FUZZ"\" -H \""User-Agent:$uagent" \" -s "$tp" "--$pr" "$vl"  "$url/$sub/$arq" |zenity --title "Copie e cole" --text-info --editable  --width=1000 --height=600 
;;
"Sair")
clear
exit
esac
