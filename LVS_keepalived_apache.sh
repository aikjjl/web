#LVS ，apache，keepalived

LVS
#开启路由转发，关闭重定向
cat /etc/sysctl.conf
net.ipv4.ip_forward=1	#开启路由转发
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.ens33.send_redirects = 0			#proc响应关闭重定向功能

systcl -p #即时生效

#创建虚拟网卡
cd /etc/sysconfig/network-scripts
cp ifcfg-ens33 ifcfg-ens33:0
vim ifcfg-ens33:0
	DEVICE=ens33:0
	ONBOOT=yes
	IPADDR=192.168.1.2	#虚拟网卡地址
	NETMASK=255.255.255.0
	
#开启虚拟网卡
ifup ens33:0






















