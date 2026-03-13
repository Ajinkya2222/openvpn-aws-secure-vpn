#!/bin/bash
set -e

echo "[+] Updating system"
sudo apt update && sudo apt upgrade -y

echo "[+] Installing OpenVPN and EasyRSA"
sudo apt install -y openvpn easy-rsa iptables-persistent

echo "[+] Creating EasyRSA directory"
make-cadir ~/easy-rsa
cd ~/easy-rsa

export EASYRSA_BATCH=1
export EASYRSA_REQ_CN="MyVPN-CA"

echo "[+] Initializing PKI"
./easyrsa init-pki
./easyrsa build-ca nopass

echo "[+] Generating server certificate"
./easyrsa gen-req server nopass
./easyrsa sign-req server server

echo "[+] Generating client certificate"
./easyrsa gen-req client1 nopass
./easyrsa sign-req client client1

echo "[+] Generating Diffie-Hellman parameters"
./easyrsa gen-dh

echo "[+] Generating TLS authentication key"
openvpn --genkey --secret ta.key

echo "[+] Copying certificates"
sudo mkdir -p /etc/openvpn/server
sudo cp pki/ca.crt pki/issued/server.crt pki/private/server.key pki/dh.pem ta.key /etc/openvpn/server/
sudo cp pki/issued/client1.crt pki/private/client1.key /etc/openvpn/

echo "[+] Enabling IP forwarding"
sudo sysctl -w net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf

echo "[+] Installation complete"