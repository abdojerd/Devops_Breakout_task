FROM oraclelinux
MAINTAINER Abdellatif Jerdaoui <abdojerd@gmail.com>
#prepare our instance and install apache web server
RUN yum -y update && yum clean all
RUN yum -y install httpd && yum clean all
#install requirements of SSL protocol
RUN yum -y install mod_ssl openssl crypto-utils
#install haproxy
RUN yum -y install haproxy
#create configuration directories
RUN mkdir -p /var/www/html/logs
RUN mkdir /etc/httpd/sites-available
RUN mkdir /etc/httpd/sites-enabled
RUN mkdir -p /etc/haproxy/cert
#copy configuration files
COPY ./breakgame.task.conf /etc/httpd/sites-available
COPY ./Breakout/ /var/www/html/
COPY ./haproxy.cfg /etc/haproxy
#Add bash scripts
ADD ssl_cert_generator.sh /.
ADD run-httpd.sh /.
RUN chmod -v +x /ssl_cert_generator.sh
RUN chmod -v +x /run-httpd.sh
#configuration
RUN ln -s /etc/httpd/sites-available/breakgame.task.conf /etc/httpd/sites-enabled/breakgame.task.conf
RUN echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
RUN sed -i 's/Listen 80/Listen 8000/g' /etc/httpd/conf/httpd.conf
RUN sed -i 's/Listen 443 https/#Listen 443 https/g' /etc/httpd/conf.d/ssl.conf
#add https support to haproxy
RUN sed -i -e 's/\r$//' ssl_cert_generator.sh
RUN ./ssl_cert_generator.sh
RUN cat /etc/haproxy/cert/breakgame.task.crt /etc/haproxy/cert/breakgame.task.key > /etc/haproxy/cert/breakgame.task.pem
#execute
CMD /usr/sbin/haproxy -D -f /etc/haproxy/haproxy.cfg -p /var/run/haproxy.pid && /usr/sbin/httpd -D FOREGROUND

EXPOSE 80 443