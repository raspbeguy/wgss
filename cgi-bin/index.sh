#!/usr/bin/bash

source ../lib/headers.sh
source ../lib/sessions.sh
source ../lib/wg.sh
source ../lib/arguments.sh

check_session

add_header "Content-Type: text/html; charset=utf-8"
print_headers

output_user "$user" | j2 --filters ../misc/j2-filters.py -f json ../templates/index.j2
