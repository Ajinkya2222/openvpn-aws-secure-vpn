

# Secure OpenVPN on AWS using RSA, AES & Post-Quantum Cryptography

Author: Ajinkya Kulkarni

---

PROJECT DESCRIPTION

This project demonstrates the complete implementation of a secure VPN using OpenVPN deployed on AWS EC2.
The VPN uses a hybrid cryptographic model combining RSA, AES, SHA, TLS and Diffie-Hellman to provide secure communication over the internet.

Algorithms used:

RSA-2048 → Authentication and key exchange
AES-256-GCM → Data encryption
SHA256 / HMAC → Integrity verification
TLS 1.3 → Secure handshake
Diffie-Hellman → Session key generation

The system creates an encrypted tunnel between client and server and routes all traffic through the AWS instance, masking the client IP.

---

HOW THE VPN WORKS

Client connects to server
TLS handshake starts
Server sends RSA certificate
Client verifies CA certificate
Shared key generated using DH
AES encryption enabled
All packets encrypted

Flow:

Client → TLS handshake → Encrypted tunnel → AWS OpenVPN Server → Internet

---

REPOSITORY STRUCTURE

openvpn-aws-secure-vpn

scripts
install_openvpn.sh
generate_client_ovpn.sh

configs
server.conf
client_template.ovpn

logs
sample_openvpn_logs.txt

README.md
LICENSE

---

FILE EXPLANATION

install_openvpn.sh
Installs OpenVPN and EasyRSA and generates RSA certificates

server.conf
Defines encryption, authentication and routing

generate_client_ovpn.sh
Creates client1.ovpn automatically

client_template.ovpn
Reference config for understanding format

logs folder
Contains log examples proving encryption

---

FULL SETUP GUIDE

STEP 1 — Create AWS EC2 Server

Use Ubuntu 22.04
Use t2.micro free tier

Security group:

22 TCP → My IP
1194 UDP → 0.0.0.0/0

---

STEP 2 — Login to server

ssh -i your-key.pem ubuntu@PUBLIC_IP

If terminal shows

ubuntu@ip-xxx:~$

You are inside server

---

STEP 3 — Clone repository

git clone [https://github.com/yourusername/openvpn-aws-secure-vpn.git](https://github.com/yourusername/openvpn-aws-secure-vpn.git)

cd openvpn-aws-secure-vpn

---

STEP 4 — Install OpenVPN

chmod +x scripts/install_openvpn.sh

sudo scripts/install_openvpn.sh

This generates:

CA
server key
client key
dh.pem
ta.key

RSA is used here

---

STEP 5 — Copy server config

sudo cp configs/server.conf /etc/openvpn/server.conf

Start server

sudo systemctl enable openvpn@server

sudo systemctl start openvpn@server

Check

sudo systemctl status openvpn@server

---

STEP 6 — Generate client config

chmod +x scripts/generate_client_ovpn.sh

./scripts/generate_client_ovpn.sh

Creates

client1.ovpn

Contains

CA
client cert
client key
TLS key
cipher

---

STEP 7 — Download client file

scp -i key.pem ubuntu@IP:/home/ubuntu/client1.ovpn .

---

STEP 8 — Connect VPN

Windows

Install OpenVPN GUI

Copy file to

C:\Program Files\OpenVPN\config

Connect

Linux

sudo openvpn --config client1.ovpn

---

STEP 9 — Verify VPN

curl ifconfig.me

IP should match AWS IP

---

CRYPTOGRAPHY EXPLANATION

RSA

Used for authentication

Server sends certificate

Client verifies CA

openssl x509 -in server.crt -text

Shows RSA key

---

TLS HANDSHAKE

ClientHello
ServerHello
Certificate
Key exchange
Session key

---

AES ENCRYPTION

After handshake

cipher AES-256-GCM

Used for data

---

HMAC

auth SHA256

Ensures integrity

---

DIFFIE HELLMAN

dh.pem

Creates shared key

---

LOG PROOF

sudo tail -f /var/log/openvpn/openvpn.log

Example

VERIFY OK depth=1
TLSv1.3 cipher TLS_AES_256_GCM_SHA384
Data Channel Encrypt AES-256-GCM
Initialization Sequence Completed

Proof of

RSA
AES
TLS
SHA

---

POST QUANTUM CRYPTOGRAPHY DISCUSSION

RSA is vulnerable to quantum computers

Shor algorithm can break RSA

Future VPN must use PQC

NIST algorithms

Kyber → key exchange
Dilithium → signatures
SPHINCS+ → hash signatures

Future VPN

RSA + Kyber hybrid

Benefits

Quantum safe
Backward compatible
Stronger security

OpenSSL 3 supports PQC
OpenVPN can be upgraded

---

FUTURE WORK

Post-quantum VPN
WireGuard
Multi client
Auto certificate
Firewall
Fail2ban

---

DISCLAIMER

Educational use only

---

RESULT

This project demonstrates real

VPN
RSA
AES
TLS
AWS deployment
Logs proof
Post-quantum awareness


