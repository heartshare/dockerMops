
这是[docker-createrepo](https://github.com/marksugar/dockerMops/tree/master/docker-createrepo)的第三个版本，添加了ftp与docker-createrepo组合中使用，并且加了
```
- build

docker build --build-arg version="1.15.12" -t marksugar/nginx_createrepo:v0.3 .

- image

docer pull marksugar/nginx_createrepo:v0.3 

- docker-compsoe

可以往vhost下挂载文件,修改配置文件和升级到1.15.12

```
   include vhost/*.conf;
```

```
version: '3'
services:
  nginx_createrepo:
    image: marksugar/nginx_createrepo:v0.3
    container_name: nginx_createrepo
    restart: always
    privileged: true
    network_mode: "host"
    volumes:
    - /data/mirrors:/data
    - /data/logs:/data/logs
    - /data/mirrors/wwwroot:/data/wwwroot
    - /etc/localtime:/etc/localtime:ro
    - /data/mirrors/footer.html:/tmp/footer.html
    - /data/mirrors/header.html:/tmp/header.html
    - /data/linuxea:/data/linuxea
    - /etc/nginx/vhost:/etc/nginx/vhost
    - /etc/nginx/cert:/etc/nginx/cert
    environment:
    - NGINX_PORT=443
    - SERVER_NAME=ftp.linuxea.com
    - USERNAME=marksugar
    - FTPPASSWD=MTU1NTgzNTA2Ngo
    - FTPDATA=/data/wwwroot
    - NGINX_PORT=80
    - WELCOME="welome to linuxea.com"
    logging:
      driver: "json-file"
      options:
        max-size: "1G"
```



![mage](https://raw.githubusercontent.com/marksugar/dockerMops/master/docker-createrepo/vsftp/img/20181231-2.png)
## 快速使用
```
curl -Lk https://raw.githubusercontent.com/marksugar/dockerMops/master/docker-createrepo/vsftp-arg/deploy|bash
```
## 须知
你至少需要挂载目录，如果你不想修改默认的变量参数，就会使用默认参数
```
    environment:
    - NGINX_PORT=443
    - SERVER_NAME=ftp.linuxea.com
    - USERNAME=marksugar
    - FTPPASSWD=MTU1NTgzNTA2Ngo
    - FTPDATA=/data/wwwroot
    - NGINX_PORT=80
    - WELCOME="welome to linuxea.com"
```
如果你要修改网络模式，请自己加端口映射。
## eval
用作eval来进行替换，这是一个好方法。在这个ftp与docker-createrepo组合中使用
```
eval "echo \"$(cat /opt/.supervisord.conf)\"" > /etc/supervisord.conf
```

## ftp配置参数
```
anonymous_enable=YES    //匿名访问 开启
local_enable=YES    //本地实体用户访问 开启
write_enable=YES    //允许用户上传数据
local_umask=022    //建立新目录和文件的权限
dirmessage_enable=YES    //目录下有 .message 文件则显示该文件的内容 ???
xferlog_enable=YES     //日志文件记录 记录于 /var/log/vferlog
connect_from_port_20=YES  //支持主动式连接功能
xferlog_std_format=YES    //支持 WuFTP 的日志文件格式
listen=YES    //使用 stand along 方式启动 vsftpd
pam_service_name=vsftpd    //支持 PAM 模块的管理
userlist_enable=YES    //支持 /etc/vsftpd/user_list 文件内的登陆账号控制
tcp_wrappers=YES    //支持 TCP Wrappers 的防火墙机制
use_localtime=YES   //本地时间
no_anon_password=YES    //匿名登录时,不检验密码
idle_session_timeout=600    //匿名用户10分钟无操作则掉线
banner_file=/etc/vsftpd/anon_welcome.txt    //匿名用户登录后看到的欢迎信息
anon_mkdir_write_enable=YES    //匿名用户建立目录的权限
anon_upload_enable=YES    //匿名用户上传文件的权限
#anon_other_write_enable=YES    //匿名用户删除和重命名文件的权限
```

```
chroot_list_enable=YES/NO（NO）
设置是否启用chroot_list_file配置项指定的用户列表文件。默认值为NO。
chroot_list_file=/etc/vsftpd.chroot_list
用于指定用户列表文件，该文件用于控制哪些用户可以切换到用户家目录的上级目录。
chroot_local_user=YES/NO（NO）
用于指定用户列表文件中的用户是否允许切换到上级目录。默认值为NO。
```

```
chroot_local_user=NO
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/vsftpd.chroot_list
```
添加锁定目录用户
```
marksugar
```      
    
