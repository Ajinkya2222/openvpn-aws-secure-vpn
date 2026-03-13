#!/bin/bash

SERVER_IP=$(curl -s http://checkip.amazonaws.com)

cat > client1.ovpn <<EOF
client
dev tun
proto udp
remote $SERVER_IP 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-GCM
auth SHA256
key-direction 1
verb 3

<ca>
$(cat ~/easy-rsa/pki/ca.crt)
</ca>

<cert>
$(cat ~/easy-rsa/pki/issued/client1.crt)
</cert>

<key>
$(cat ~/easy-rsa/pki/private/client1.key)
</key>

<tls-auth>
$(cat ~/easy-rsa/ta.key)
</tls-auth>
EOF

echo "[+] client1.ovpn generated"