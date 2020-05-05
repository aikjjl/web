#ssh和nginx的静态web服务器
#源码包http://nginx.org/
FROM centos
COPY ./nginx-1.18.0.tar.gz /usr/src
WORKDIR /usr/src
RUN yum update -y \
&& yum install -y gcc pcre-devel zlib-devel openssl openssl-devel make \
&& yum install -y openssh-server \
&& echo "root:aikjjl"|chpasswd \
&& ssh-keygen -A \
&& tar zxf nginx-1.18.0.tar.gz
WORKDIR /usr/src/nginx-1.18.0
RUN ./configure --prefix=/usr/local/nginx  --with-http_ssl_module  --with-http_stub_status_module \
&& make && make install \
#启动nginx和ssh
&& echo "/usr/local/nginx/sbin/nginx \n/usr/sbin/sshd -D" >/run_ssh_nginx.sh \
&& chmod +x /run_ssh_nginx.sh
EXPOSE 22
EXPOSE 80
CMD ["/run_ssh_nginx.sh"]