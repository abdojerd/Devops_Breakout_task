#!/bin/bash

#=============================================================#
# Name:         SSL Certificate Creater                       #
# Description:  Create a self-signed SSL Certificates         #
#               for Apache                                    #
# Data:         10.11.2019                                    #
# Author:       Abdellatif JERDAOUI                           #
            
#=============================================================#

checkRoot() {
   if [ $(id -u) -ne 0 ]; then
     printf "Script must be run as root. Try 'sudo ./ssl_certificate_generator.sh'\n"
     exit 1
   fi
}


setServerName() {
    choices=breakgame.task
    if [ "$choices" != "" ]; then
        __servername=$choices
    else
        break
    fi
}


installCertificateApache() {
  mkdir -p /etc/haproxy/cert
 
  openssl req -new -x509 -days 365 -nodes -out /etc/haproxy/cert/$__servername.crt -keyout /etc/haproxy/cert/$__servername.key -subj '/CN=breakout.test/O=Breakout test company./C=US'
  chmod 600 /etc/haproxy/cert/$__servername.key
  chmod 600 /etc/haproxy/cert/$__servername.crt
}


checkRoot
setServerName
installCertificateApache


exit 0
