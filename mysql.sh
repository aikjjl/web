#centos7
https://blog.csdn.net/weixin_44666068/article/details/97101226
https://yq.aliyun.com/articles/670111
依赖包
yum -y install gcc gcc-c++ ncurses ncurses-devel cmake bison bison-devel

启动用户
useradd -M -s /sbin/nologin mysql
-M  不创建用户的家目录
-s  指定一个不能登录的 shell

对安装目录进行授权
mkdir -p /usr/local/mysql/data
chown -R mysql:mysql /usr/local/mysql
chmod 750 /usr/local/mysql/data

