#动静分离
#客户端请求的动态页面和静态页面分开处理
#动态请求用apache ，nginx 做静态和反向



#配置ssh
#宿主机ssh-keygen -t rsa
#宿主机cat ~/.ssh/id_rsa.pub >authorized_keys

FROM centos
COPY ./authorized_keys /etc/.ssh/authorized_keys
RUN yum -y update \
&& yum install -y openssh-server \
&& echo "root:aikjjl"|chpasswd \
&& ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key \
&& ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key \
&& ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key \
&& ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key \
&& echo -e "#!/bin/sh \n/usr/sbin/sshd -D" > /run_sshd.sh \
&& chmod +x /run_sshd.sh
EXPOSE 22
CMD ["/run_sshd.sh"]

#apache
#源码包http://httpd.apache.org/
WORKDIR /usr/src
RUN yum install -y wget \
&& yum install -y gcc make apr-devel apr apr-util apr-util-devel pcre-devel \
&& dnf install redhat-rpm-config -y \
&& tar zxf httpd-2.4.43.tar.gz
WORKDIR httpd-2.4.4
#自定义安装位置，模块
RUN ./configure --prefix=/usr/local/apache2 --enable-mods-shared=most --enable-so \
&& make && make install \
#修改apache配置文件
&& sed -i 's/#ServerName www.example.com:80/ServerName localhost:80/g' /usr/local/apache2/conf/httpd.conf \
#启动apache服务
&& /usr/local/apache2/bin/httpd \
&& echo -e "#!/bin/sh \n/usr/local/apache2/bin/httpd -D FOREGROUND" > /run_httpd.sh \
&& chmod +x /run_httpd.sh
EXPOSE 80
CMD ["/run_httpd.sh"]
