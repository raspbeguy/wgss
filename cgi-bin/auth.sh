#!/usr/bin/bash

source ../lib/arguments.sh
source ../lib/headers.sh
source ../lib/sessions.sh

source ../config.sh

function get_do {
  add_header "Content-Type: text/html; charset=utf-8"
  print_headers
  export AUTH_TARGET="$(urldecode ${get[target]})"
  j2 ../templates/auth.j2
}

function post_do {
  local username="${post[username]}"
  local password="${post[password]}"
  userldap=$(ldapwhoami -H $LDAP_URL -D "uid=$username,$LDAP_USER_OBJ" -x -w $password)
  local rc=$?
  if [[ $rc == "0" ]]
  then
    create_session $username
    add_header "Status: 302 Found"
    add_header "Location: ${post[target]}"
    print_headers
  else
    add_header "Content-Type: text/plain; charset=utf-8"
    print_headers
    echo "Identifiants erronés"
  fi
}

case $REQUEST_METHOD in
  "GET") get_do ;;
  "POST") post_do ;;
  *)
    add_header "Content-Type: text/plain; charset=utf-8"
    print_headers
    echo '¯\_(ツ)_/¯'
    ;;
esac
