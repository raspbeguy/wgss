LDAP_URL="ldaps://ldap.example.net"
LDAP_USER_OBJ="ou=users,dc=example,dc=net"
LDAP_GROUP_OBJ="ou=groups,dc=example,dc=net"
LDAP_ADMIN_GROUP="admin"
LDAP_USER_GROUP="users"

SESSION_ID_LEN=12
SESSION_PATH="/tmp/wg-sf-sessions"
SESSION_TERM=10800

WG_INTERFACE="wg0"
WG_PEERS="/etc/wireguard/peers.list"
WG_PUBKEY="xxxxxxxxxxxxx"
WG_NET="10.0.0.0/16"
WG_DEST_NET="192.168.0.0/16"
WG_GW_IP="10.0.0.1"
WG_ENDPOINT="vpn.example.net:51820"
WG_DNS="192.168.0.1"
WG_UP_DELAY=180
