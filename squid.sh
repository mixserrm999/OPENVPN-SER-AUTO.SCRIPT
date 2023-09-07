#!/bin/bash

# ตรวจสอบว่ามีกระบวนการ apt ที่ทำงานอยู่หรือไม่
while pgrep -x "apt" >/dev/null; do
    echo "ระบบกำลังทำงานคำสั่ง apt, รอสักครู่..."
    sleep 5
done

# ติดตั้ง Squid
sudo apt-get update
sudo apt-get install -y squid

sleep 5
# ลบ squid.conf และสร้าง squid.conf ใหม่
sudo rm /etc/squid/squid.conf
sudo tee /etc/squid/squid.conf > /dev/null <<EOL
acl localnet src 10.0.0.0/8	# RFC1918 possible internal network
acl localnet src 172.16.0.0/12	# RFC1918 possible internal network
acl localnet src 192.168.0.0/16	# RFC1918 possible internal network
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl CONNECT method CONNECT

http_access allow CONNECT localnet

http_access allow localhost
http_access deny manager

http_access deny !Safe_ports

http_access deny CONNECT !SSL_ports

http_access allow CONNECT

http_access allow localnet
http_access allow localhost

http_access deny all

http_port 8080

cache_dir ufs /var/spool/squid 100 16 256

cache_mem 256 MB

coredump_dir /var/cache/squid

refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
refresh_pattern .		0	20%	4320

dns_nameservers 1.1.1.1 1.0.0.1
EOL

# รีสตาร์ท Squid
sudo systemctl restart squid

# เปิดพอร์ต 8080 ในไฟร์วอลล์
sudo ufw allow 8080/tcp

chmod +x squid.sh

echo "ติดตั้ง Squid และกำหนดพอร์ตเสร็จสมบูรณ์"
