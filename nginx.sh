#ssh和nginx
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


https://blog.51cto.com/11134648/2130987
nginx访问量统计


PV(访问量)：即Page View, 即页面浏览量或点击量，用户每次刷新即被计算一次。
UV(独立访客)：即Unique Visitor,访问您网站的一台电脑客户端为一个访客。00:00-24:00内相同的客户端只被计算一次。
IP(独立IP)：即Internet Protocol,指独立IP数。00:00-24:00内相同IP地址之被计算一次。

1.根据访问IP统计UV
awk '{print $1}'  access.log|sort | uniq -c |wc -l

2.统计访问URL统计PV
awk '{print $7}' access.log|wc -l

3.查询访问最频繁的URL
awk '{print $7}' access.log|sort | uniq -c |sort -n -k 1 -r|more

4.查询访问最频繁的IP
awk '{print $1}' access.log|sort | uniq -c |sort -n -k 1 -r|more

5.根据时间段统计查看日志
cat  access.log| sed -n '/14\/Mar\/2015:21/,/14\/Mar\/2015:22/p'|more

6.统计IP访问个数（和根据访问IP统计UV一样）
cat access.log | awk '{ips[$1]+=1} END{for(ip in ips) print ips[ip],ip}' | sort -nr | wc -l

7.查看3点-6点之间的Ip访问个数
grep "2016:0[3-6]" access.log | awk '{ips[$1]+=1} END{for(ip in ips) print ips[ip],ip}' | sort –nr | wc -l

8.查看3点-6点之间的ip访问数，并且访问数>=200的ip.
grep '2016:0[3-12]' access.log | awk '{ips[$1]+=1}END{for(ip in ips) if(ips[ip]>=200) print ips[ip],ip}' | sort -nr

9.查看并发连接数
netstat -nat|grep ESTABLISHED|wc -l

10.获取每分钟的请求数量，输出成csv文件
cat /usr/local/nginx/logs/access.log  | awk '{print substr($4,14,5)}' | uniq -c | awk '{print $2","$1}' > access.csv

11.获取最耗时的请求时间、url、耗时，前10名, 可以修改后面的数字获取更多，不加则获取全部
cat /usr/local/nginx/logs/access.log | awk '{print $4,$7,$NF}' | awk -F '"' '{print $1,$2,$3}' | sort -k3 -rn | head -10

12.查看http的并发请求数与其TCP连接状态
netstat -n | awk '/^tcp/ {++b[$NF]} END {for(a in b) print a,"\t",b[a]}'
netstat -n | awk '/^tcp/ {++state[$NF]} END {for(key in state) print key,"\t",state[key]}'
