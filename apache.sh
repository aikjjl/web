#配置ssh

FROM centos
RUN yum -y update \
&& yum install -y openssh-server \
&& echo "root:aikjjl"|chpasswd \
#生成主机密钥
&& ssh-keygen -A
EXPOSE 22

#apache
#源码包http://httpd.apache.org/
COPY ./httpd-2.4.43.tar.gz /usr/src
WORKDIR /usr/src
RUN yum install -y wget \
&& yum install -y gcc make apr-devel apr apr-util apr-util-devel pcre-devel \
&& dnf install redhat-rpm-config -y \
&& tar zxf httpd-2.4.43.tar.gz
WORKDIR /usr/src/httpd-2.4.43
RUN ./configure --prefix=/usr/local/apache2 --enable-mods-shared=most --enable-so \
&& make && make install \
#修改apache配置文件
&& sed -i 's/#ServerName www.example.com:80/ServerName localhost:80/g' /usr/local/apache2/conf/httpd.conf \
&& echo "/usr/local/apache2/bin/httpd -D FOREGROUND \n/usr/sbin/sshd -D" > /run_ssh_httpd.sh \
&& chmod +x /run_ssh_httpd.sh
EXPOSE 80
CMD ["/run_ssh_httpd.sh"]
