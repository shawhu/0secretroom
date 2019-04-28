#install file for CentOS 7
#yum update
echo "Let's run yum update first? Highly recommended. "
echo ""
read -p "Enter Y or y to start, anything else to bypass" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    yum update -y
fi
echo "Now we are going to start the installation, it normally takes several minutes to complete and it can't be interupted in the middle"
echo 
read -p "Shall we start the process? Enter Y or y to start, anything else to quit" -n 1 -r
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
echo "All done, you should add 192.168.1.1 0secretroom.local to your local hosts file and"
echo -e "then you shall be able to access by entering the following in your browser \e[34mhttps://0secretroom.local/#/wschat?rid=aaa&uid=yourUsername\e[0m"
echo -e "Sample URL: \e[34mhttps://0secretroom.local/#/wschat?rid=aaa&uid=harry\e[0m"
echo -e "Please check-out our project site for details: \e[34mhttps://github.com/ericgu2017/0secretroom\e[0m"

