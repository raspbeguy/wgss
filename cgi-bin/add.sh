#!/bin/bash

source ../lib/arguments.sh
source ../lib/headers.sh
source ../lib/sessions.sh
source ../lib/wg.sh

function get_do {
  check_session
  add_header "Content-Type: text/html; charset=utf-8"
  print_headers
  output_user "$user" | j2 -f json ../templates/add.j2
}

function post_do {
  check_session
  new_name="${post[name]}"
  new_pubkey="${post[pubkey]}"
  add_peer "$user" "$new_name" "$new_pubkey"
  echo "{\"user\":\"$user\",\"profile\":\"$new_name\"}" | \
    j2 -f json ../templates/mail-new-profile.j2 | \
    mail \
      -s "[WGSS] Ajout de nouveau profil pour $user" \
      -a "Content-Type: text/plain; charset=UTF-8" \
      -a "Precedence: bulk" \
      -r "$MAIL_FROM" \
      "$MAIL_ADMIN"
  add_header "Status: 302 Found"
  add_header "Location: /index.sh?user=$user"
  print_headers
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
