#!/bin/bash

source ../lib/sessions.sh
source ../lib/headers.sh

destroy_session
add_header "Status: 302 Found"
add_header "Location: /"
print_headers
