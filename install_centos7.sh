#install file for CentOS 7
#yum update
echo "我们推荐先跑一边yum update更新一下系统"
echo "Let's run yum update first? Highly recommended for a new system."
echo ""
echo "输入Y/y开始，输入空格取消"
read -p "Enter Y or y to start, anything else to bypass." -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    yum update -y
fi
echo "安装正式开始，大概需要几分钟时间中间不能打断"
echo "Now we are going to start the installation, it takes several minutes and can't be interupted"
echo 
echo "按Y/y开始，其他键取消"
read -p "Shall we start the process? Enter Y or y to start, anything else to quit." -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi
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
wget https://github.com/ericgu2017/0secretroom/releases/download/0.2/latest.tar.gz
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
systemctl enable nginx
systemctl start nginx

#put nginx to selinux permissive list
semanage permissive -a httpd_t

#generate self-signed cert
echo "接下来要系统要产生一个自签名用于https加密的ssl证书，请根据英语界面提示输入"
echo "Common name请输入0secretroom.local"
echo "We will generate a self-signed ssl certificate, please follow the instruction to enter various information"
echo "Common name must be 0secretroom.local"
echo "按任意键开始"
read -p "Press anykey to continue" -n 1 -r
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/certs/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
#install nginx config file
curl https://raw.githubusercontent.com/ericgu2017/0secretroom/master/nginx.conf -o /etc/nginx/conf.d/nginx.conf
nginx -s reload


#output results
#get local ip
myip=`hostname -I`
echo -e "All done, you should add  \e[34m$myip 0secretroom.local\e[0m  to /etc/hosts and"
echo -e "in your browser \e[34mhttps://0secretroom.local/#/wschat?rid=aaa&uid=testadmin\e[0m"
echo -e "Please check-out our project site for details: \e[34mhttps://github.com/ericgu2017/0secretroom\e[0m"
echo -e "请自行把 \e[34m$myip 0secretroom.local\e[0m  添加到/etc/hosts文件中"
echo -e "你可以试下访问 \e[34mhttps://0secretroom.local/#/wschat?rid=aaa&uid=testadmin\e[0m"
echo -e "如有问题请访问项目网站 \e[34mhttps://github.com/ericgu2017/0secretroom\e[0m"
