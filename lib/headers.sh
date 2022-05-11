declare headers

function add_header {
  headers+=( "$1" )
}

function print_headers {
  for i in ${!headers[@]}
  do
    echo ${headers[$i]}
  done
  echo ""
}
