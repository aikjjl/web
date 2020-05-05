#keepalived
#https://www.keepalived.org/download.html
FROM centos

yum install -y gcc openssl-devel popt-devel
yum install -y make
#libnl libnl-devel,支持IPv6的IPVS,虚假加软件源再安装
yum install -y nginx
#将Keepalived注册为系统服务
mkdir /etc/keepalived/

https://www.cnblogs.com/tvkzy/p/9259664.html