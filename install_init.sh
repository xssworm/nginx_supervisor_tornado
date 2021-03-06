#!/bin/bash
Current=${PWD};

#pip_version = $(/usr/bin/pip -V | awk -F[[:space:]] '{print $2}');

yum install python-pip python-dev python-pycurl python-simplejson nginx;
python ${Current}/install_supervisor.py;
pip -q install tornado;

adduser -M www-data;
#adduser -M supervisord;
#usermod -a -G supervisord root;

mkdir -p /var/log/supervisor;
touch /var/run/supervisord.pid;
#chown supervisord:supervisord /var/run/supervisord.pid 

#chown supervisord:supervisord /var/log/supervisord;
cp -r ${Current}/var/pythonweb /var/pythonweb;
cp -f ${Current}/etc/supervisord.conf /etc/supervisord.conf;
cp -f ${Current}/etc/nginx/nginx.conf /etc/nginx/nginx.conf;
chown -R www-data:www-data /var/pythonweb; 
cp -f ${Current}/supervisord.service /usr/lib/systemd/system/supervisord.service;
cp -f ${Current}/nginxd.service /usr/lib/systemd/system/nginxd.service;

service nginxd enable;
service supervisord enable;
setsebool -P httpd_can_network_connect 1