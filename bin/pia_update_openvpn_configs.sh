#!/bin/bash

rm openvpn.zip
wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
rm openvpn-ip.zip
wget https://www.privateinternetaccess.com/openvpn/openvpn-ip.zip
rm openvpn-tcp.zip
wget https://www.privateinternetaccess.com/openvpn/openvpn-tcp.zip

mkdir udp ip tcp

cd udp
unzip ../openvpn.zip
for x in *.ovpn; do 
	y=${x// /_}
	y=${y,,}
	mv "${x}" "udp_${y}"
done
cd ..

cd ip
unzip ../openvpn-ip.zip
for x in *.ovpn; do 
	y=${x// /_}
	y=${y,,}
	mv "${x}" "ip_${y}"
done
cd ..

cd tcp
unzip ../openvpn-tcp.zip
for x in *.ovpn; do 
	y=${x// /_}
	y=${y,,}
	mv "${x}" "tcp_${y}"
done
cd ..

mkdir pia
cd pia
for x in udp ip tcp; do 
	mv ../${x}/* .
	rmdir ../${x}
done

# Fix problem with disconnection error: AUTH: Received control message: AUTH_FAILED
#for x in *.ovpn; do
#    echo 'pull-filter ignore "auth-token"' >> "${x}"
#done

rm ../privateinternetaccess_ovpn.zip
zip -9 ../privateinternetaccess_ovpn.zip *
cd ..
