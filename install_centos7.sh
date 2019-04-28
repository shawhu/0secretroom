#download and install wget
sudo yum install wget -y
#install semanage
yum install policycoreutils-python -y

#download dotnet sdk and install it
wget https://swzbtest1.oss-cn-hangzhou.aliyuncs.com/dotnet-sdk-2.2.203-linux-x64.tar.gz
mkdir -p $HOME/dotnet && tar zxf dotnet-sdk-2.2.203-linux-x64.tar.gz -C $HOME/dotnet
export DOTNET_ROOT=$HOME/dotnet
export PATH=$PATH:$HOME/dotnet
#download 0secretroom
mkdir 0secretroom -p
wget https://github.com/ericgu2017/0secretroom/releases/download/0.1/latest.tar.gz
tar zxvf latest.tar.gz -C 0secretroom
cp 0secretroom/web.service /etc/systemd/system
systemctl enable web.service
systemctl start web
#add firewalld rules
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=81/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload
#add nginx
sudo yum install epel-release -y
sudo yum install nginx -y
sudo apt install nginx -y
systemctl enable nginx
systemctl start nginx

#put nginx to selinux permissive list
semanage permissive -a httpd_t

#generate self-signed cert
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
cp 0secretroom/my.conf /etc/nginx/conf.d/my.conf
nginx -s reload

#output results
echo All done, you should add 192.168.1.1 0secretroom.local to your hosts file and
echo then you can access your 0secretroom https://0secretroom.local/#/wschat?rid=aaa&uid=[your_user_name]
echo Sample url: https://0secretroom.local/#/wschat?rid=aaa&uid=harry
echo Please check our main github site for details: https://github.com/ericgu2017/0secretroom
