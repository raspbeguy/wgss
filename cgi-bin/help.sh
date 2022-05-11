#!/bin/bash

source ../lib/headers.sh
source ../lib/sessions.sh

source ../config.sh

check_session

add_header "Content-Type: text/html; charset=utf-8"
print_headers

export WG_PUBKEY WG_NET WG_DEST_NET WG_ENDPOINT WG_DNS
j2 ../templates/help.j2
