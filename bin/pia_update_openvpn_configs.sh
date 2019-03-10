#!/bin/bash

cd ~/Downloads
rm openvpn.zip
wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
rm openvpn-ip.zip
wget https://www.privateinternetaccess.com/openvpn/openvpn-ip.zip
rm openvpn-tcp.zip
wget https://www.privateinternetaccess.com/openvpn/openvpn-tcp.zip

mkdir pia
cd ~/Downloads/pia

mkdir udp ip tcp

cd udp
unzip ~/Downloads/openvpn.zip
for x in *.ovpn; do mv "${x}" "UDP - ${x}"; done
cd ~/Downloads/pia

cd ip
unzip ~/Downloads/openvpn-ip.zip
for x in *.ovpn; do mv "${x}" "IP - ${x}"; done
cd ~/Downloads/pia

cd tcp
unzip ~/Downloads/openvpn-tcp.zip
for x in *.ovpn; do mv "${x}" "TCP - ${x}"; done
cd ~/Downloads/pia

for x in udp ip tcp; do mv ${x}/* .; done

# Fix problem with disconnection error: AUTH: Received control message: AUTH_FAILED
for x in *.ovpn; do
    echo 'pull-filter ignore "auth-token"' >> "${x}"
done

rmdir ./* 2>/dev/null

rm ../privateinternetaccess_ovpn.zip
zip ../privateinternetaccess_ovpn.zip *
cd ~/Downloads
rm -rf pia
