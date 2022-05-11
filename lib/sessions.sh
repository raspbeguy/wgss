source ../lib/headers.sh
source ../lib/cookies.sh
source ../lib/arguments.sh

source ../config.sh

export ADMIN

function create_session {
  local session_id=$(cat /dev/urandom | tr -cd "a-zA-Z0-9" | head -c $SESSION_ID_LEN)
  mkdir -p $SESSION_PATH
  echo $1 > $SESSION_PATH/$session_id
  add_header "Set-Cookie: session=$session_id"
}

function check_session {
  if [ -z ${cookies[session]} ] || \
     [ ! -f "$SESSION_PATH/${cookies[session]}" ] || \
     (( $(date +%s) - $(stat -c %Y "$SESSION_PATH/${cookies[session]}") > $SESSION_TERM ))
  then
    rm -f "$SESSION_PATH/${cookies[session]}"
    local target=$(urlencode $REQUEST_URI)
    add_header "Status: 302 Found"
    add_header "Location: /auth.sh?target=$target"
    print_headers
    exit
  else
    export username=$(cat $SESSION_PATH/${cookies[session]})
    ! (ldapsearch -H "$LDAP_URL" -x -b "$LDAP_GROUP_OBJ" "(memberUid=$username)" | grep -q "^cn: $LDAP_ADMIN_GROUP")
    export isadmin=$?
    if [ ${get[user]+x} ] && [ "$isadmin" == 1 ]
    then
      user=${get[user]} 
    else
      user=$username
    fi
    export $user
  fi
}	

function destroy_session {
  local session_id=${cookies[session]}
  if [ -f $SESSION_PATH/$session_id ]
  then
    rm $SESSION_PATH/$session_id
  fi
}
