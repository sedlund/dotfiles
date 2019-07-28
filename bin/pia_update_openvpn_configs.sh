#!/bin/bash
#vim: et

#PIAZIP=https://www.privateinternetaccess.com/openvpn/openvpn
#
#for x in \.zip \\-ip\.zip \\-tcp\.zip; do
#    url="${PIAZIP}${x}"
#    file=$(basename $url .zip)
#    rm "${file}"
#    wget $url
#done

rm openvpn.zip
wget https://www.privateinternetaccess.com/openvpn/openvpn.zip
rm openvpn-ip.zip
wget https://www.privateinternetaccess.com/openvpn/openvpn-ip.zip
rm openvpn-tcp.zip
wget https://www.privateinternetaccess.com/openvpn/openvpn-tcp.zip

mkdir udp ip tcp

cd udp || exit
unzip ../openvpn.zip
for x in *.ovpn; do
    y=${x// /_}
    y=${y,,}
    mv "${x}" "udp_${y}"
done
cd ..

cd ip || exit
unzip ../openvpn-ip.zip
for x in *.ovpn; do
    y=${x// /_}
    y=${y,,}
    mv "${x}" "ip_${y}"
done
cd ..

cd tcp || exit
unzip ../openvpn-tcp.zip
for x in *.ovpn; do
    y=${x// /_}
    y=${y,,}
    mv "${x}" "tcp_${y}"
done
cd ..

mkdir pia
cd pia || exit
for x in udp ip tcp; do
    mv ../${x}/* .
    rmdir ../${x}
done

for x in *.ovpn; do
    # Fix problem with disconnection error: AUTH: Received control message: AUTH_FAILED
    echo 'pull-filter ignore "auth-token"' >> "${x}"
    # Find max mtu by adding mtu-tune to a config and use the lowest 'actual' number
    echo 'mssfix 1445' >> "${x}"
    # Make sure systemd unit file has Restart=always
    echo 'ping-exit 10' >> "${x}"
    # Common warning on wifi
    echo 'mute-replay-warnings' >> "${x}"
    mv "${x}" "$(basename "${x}" .ovpn)".conf
done

perl -pi -e 's/auth-user-pass/auth-user-pass \/etc\/openvpn\/client\/pia-auth.txt/g' ./*.conf


rm ../privateinternetaccess_ovpn.zip
zip -9 ../privateinternetaccess_ovpn.zip ./*
cd ..
