function urldecode {
  local url_encoded="${1//+/ }"
  printf '%b' "${url_encoded//%/\\x}"
}

function urlencode {
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
}

read POST_STRING

OIFS=$IFS
IFS='=&'
parm_get=($QUERY_STRING)
parm_post=($POST_STRING)
IFS=$OIFS

declare -A get
declare -A post

for ((i=0; i<${#parm_get[@]}; i+=2)); do
  get[${parm_get[i]}]=$(urldecode ${parm_get[i+1]})
done

for ((i=0; i<${#parm_post[@]}; i+=2)); do
  post[${parm_post[i]}]=$(urldecode ${parm_post[i+1]})
done
