#!/bin/bash

source ../lib/sessions.sh
source ../lib/arguments.sh
source ../lib/headers.sh
source ../lib/wg.sh

check_session

pname="${get[profile]}"
delete_peer "$user" "$pname"

echo "{\"user\":\"$user\",\"profile\":\"$new_name\"}" | \
  j2 -f json ../templates/mail-delete-profile.j2 | \
  mail \
    -s "[WGSS] Suppression de profil pour $user" \
    -a "Content-Type: text/plain; charset=UTF-8" \
    -a "Precedence: bulk" \
    -r "$MAIL_FROM" \
    "$MAIL_ADMIN"
 
add_header "Status: 302 Found"
add_header "Location: /index.sh?user=$user"
print_headers
