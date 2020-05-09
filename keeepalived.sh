#keepalived
#https://www.keepalived.org/download.html
https://www.cnblogs.com/ywrj/p/9483427.html
https://www.cnblogs.com/tvkzy/p/9259664.html
https://www.jianshu.com/p/ab3a6ea95e3f

注意加上--privileged，获取真正的root权限；另外镜像里如果没有modprobe命令，apt-get install kmod
docker run -it --name kp --privileged centos
<<<<<<< HEAD
yum update -y
yum installl -y keepalived
#启动
/usr/sbin/keepalived/keepalived
=======
yum install -y gcc openssl-devel popt-devel make
yum install -y make    
#libnl libnl-devel,支持IPv6的IPVS,虚假加软件源再安装
yum install -y nginx
./configure --prefix=/usr/local/keepalived
make && make install
#将Keepalived注册为系统服务
>>>>>>> 7492f122cc5fa66746f9593124d84397c7c74f51
