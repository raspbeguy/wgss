OIFS=$IFS
IFS='=; '
cookies_raw=($HTTP_COOKIE)
IFS=$OIFS

declare -A cookies

for ((i=0; i<${#cookies_raw[@]}; i+=2)); do
  cookies[${cookies_raw[i]}]=${cookies_raw[i+1]}
done
