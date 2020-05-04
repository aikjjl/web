#修订时间20200504
#动静分离和负载均衡
#同一个nginx容器不建议同时做调度器和静态web
#客户端请求的动态页面和静态页面分开处理
#动态请求用apache ，nginx 做静态和反向

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


#ssh和nginx的静态web服务器
#源码包http://nginx.org/
FROM centos
COPY ./nginx-1.18.0.tar.gz /usr/src
WORKDIR /usr/src
RUN yum -y update gcc pcre-devel zlib-devel \
&& yum install -y openssh-server \
&& echo "root:aikjjl"|chpasswd \
&& ssh-keygen -A \
&& tar zxf nginx-1.18.0.tar.gz /
WORKDIR /usr/src/nginx-1.18.0
RUN ./configure --prefix=/usr/local/nginx \
&& make && make install \
#启动nginx和ssh
&& echo "/usr/local/nginx/sbin/nginx \n/usr/sbin/sshd -D" >/run_ssh_nginx.sh \
&& chmod +x /run_ssh_nginx.sh
EXPOSE 22
EXPOSE 80
CMD ["/run_ssh_nginx.sh"]

  
#ssh和nginx调度器
#源码包http://nginx.org/
FROM centos
COPY ./nginx-1.18.0.tar.gz /usr/src
WORKDIR /usr/src
RUN yum -y update gcc pcre-devel zlib-devel \
&& yum install -y openssh-server \
&& echo "root:aikjjl"|chpasswd \
&& ssh-keygen -A \
&& tar zxf nginx-1.18.0.tar.gz /
WORKDIR /usr/src/nginx-1.18.0
RUN ./configure --prefix=/usr/local/nginx \
&& make && make install \
#启动nginx和ssh
&& echo "/usr/local/nginx/sbin/nginx \n/usr/sbin/sshd -D" >/run_ssh_nginx.sh \
&& chmod +x /run_ssh_nginx.sh
EXPOSE 22
EXPOSE 80s
CMD ["/run_ssh_nginx.sh"]










