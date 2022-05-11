#!/bin/bash

source ../lib/sessions.sh
source ../lib/arguments.sh
source ../lib/headers.sh
source ../lib/wg.sh

source ../config.sh

check_session

pname="${get[profile]}"

add_header "Content-Type: text/plain; charset=utf-8"
add_header "Content-Disposition: attachment; filename=\"$pname.conf\""
print_headers

ip="$(get_peer "$user" "$pname")"

export ip WG_PUBKEY WG_DNS WG_NET WG_DEST_NET WG_ENDPOINT

j2 ../templates/userconf.j2
