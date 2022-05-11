source ../config.sh

function output_user {
  local username="$1"
  local users upcount txsum rxsum json
  read users upcount txsum rxsum json < <(jsonify < <(awk -F '\t+' -v username=$username '$4 == username { print $0 }' $WG_PEERS | sort -k3 -n))
  echo "{\"name\":\"$username\",\"peers\":[$json]}"
}

function output_all {
  local users upcount txsum rxsum json
  read users upcount txsum rxsum json < <(jsonify < <(sort -k4 "$WG_PEERS"))
  echo "{\"peers\":[$json], \"stats\":{\"activeusers\":$users,\"upcount\":$upcount,\"txsum\":$txsum,\"rxsum\":$rxsum}}"
}

function jsonify {
  local wg_raw="$(sudo wg show $WG_INTERFACE dump | sed 1d)"
  local json=""
  local pubkey ip creation user name
  local peerline endpoint latest tx rx up
  local txsum=0
  local rxsum=0
  local upcount=0
  local now=$(date +%s)
  local users=$(cut -f 4 "$WG_PEERS" | sort | uniq | wc -l)
  while read pubkey ip creation user name
  do
    ip=${ip%/*}
    peerline="$(echo "$wg_raw" | grep "$pubkey")"
    endpoint="$(echo "$peerline" | cut -f3)"
    latest="$(echo "$peerline" | cut -f5)"
    tx="$(echo "$peerline" | cut -f6)"
    rx="$(echo "$peerline" | cut -f7)"
    txsum=$((txsum + tx))
    rxsum=$((rxsum + rx))
    if (( now - latest < 180 ))
    then
      up="true"
      upcount=$((upcount + 1))
    else
      up="false"
    fi
    json="$json,{\"name\":\"$name\",\"pubkey\":\"$pubkey\",\"user\":\"$user\",\"ip\":\"$ip\",\"endpoint\":\"$endpoint\",\"latest\":$latest,\"creation\":$creation,\"tx\":$tx,\"rx\":$rx,\"up\":$up}"
  done
  echo -e "$users\t$upcount\t$txsum\t$rxsum\t${json:1}"
}

function increment_ip {
  local ip
  IFS=. read -a ip < <(echo "$1")
  local i=1
  while [ "$i" -lt 4 ]
  do
    ip[4-i]=$((ip[4-i]+1))
    if [ ${ip[4-i]} -lt 256 ]
    then
      break
    fi
  done
  (IFS=. ; echo "${ip[*]}")
}


function get_free_ip {
  local MINADDR MAXADDR
  eval "$(ipcalc-ng --minaddr $WG_NET)"
  eval "$(ipcalc-ng --maxaddr $WG_NET)"

  local new_ip=$MINADDR
  while read ip
  do
    if [ "$new_ip" = "${WG_GW_IP%/*}" ]
    then
      new_ip=$(increment_ip $new_ip)
    fi
    if [ ! "$new_ip" = "${ip%/*}" ]
    then
      break
    fi
    new_ip=$(increment_ip $new_ip)
  done < <(cut -f2 $WG_PEERS | cut -d/ -f1 | sort -t . -k 3,3n -k 4,4n)
  echo $new_ip
}

function add_peer {
  local puser="$1"
  local pname="$2"
  local ppubkey="$3"
  new_ip="$(get_free_ip)"
  new_date="$(date "+%s")"
  sudo wg set $WG_INTERFACE peer "$ppubkey" allowed-ips "$new_ip"
  echo -e "$ppubkey\t$new_ip\t$new_date\t$puser\t$pname" >> $WG_PEERS
}

function delete_peer {
  local puser="$1"
  local pname="$2"
  local pubkey dump
  read pubkey dump < <(awk -F '\t+' -v user="$puser" -v name="$pname" '$4 == user && $5 == name { print $0 }' $WG_PEERS)
  tmp_file=$(mktemp)
  sed "\\,$pubkey,d" $WG_PEERS > $tmp_file
  cat $tmp_file > $WG_PEERS
  sudo wg set $WG_INTERFACE peer "$pubkey" remove
}

function get_peer {
  local puser="$1"
  local pname="$2"
  local pubkey ip dump
  read pubkey ip dump < <(awk -F '\t+' -v user="$puser" -v name="$pname" '$4 == user && $5 == name { print $0 }' $WG_PEERS)
  echo "$ip"
}
