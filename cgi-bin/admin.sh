#!/usr/bin/bash

source ../lib/sessions.sh
source ../lib/wg.sh

check_session

if [ "$isadmin" == 0 ]
then
  add_header "Status: 302 Found"
  add_header "Location: /index.sh"
  print_headers
  exit
fi


export userlist=$(ldapsearch -H "$LDAP_URL" -x -b "$LDAP_GROUP_OBJ" "(cn=$LDAP_USER_GROUP)" | grep -oP "^memberUid: \K.*$" | sort | paste -sd "," -)

add_header "Content-Type: text/html; charset=utf-8"
print_headers

output_all | j2 --filters ../misc/j2-filters.py -f json ../templates/admin.j2
