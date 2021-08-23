# svn https


## 创建容器
```shell
docker run -d --name my_svn_https \
  --network test-tier \
  -p 52121:443 \
  -v /root/my/svn_data:/var/svn \
  customized/svn-https
```


## 容器配置（可选）
/etc/apache2/sites-available/svn-site.conf  
例：修改AuthName
```
AuthName "Example.Inc Subversion Repository"
```
例：指定其他SSL证书
```
SSLCertificateFile      /etc/ssl/appcerts/server.cert
SSLCertificateKeyFile   /etc/ssl/appcerts/server.key
```


## 容器创建后需要做的事情
容器运行需要另外2个文件放在`/var/svn`目录下：
- `/var/svn/svn-users.htpasswd`  用户名密码列表文件（由`htpasswd`创建管理）
- `/var/svn/authz` SVN仓库访问授权文件

如果容器挂载的目录不存在上述2个文件，则需要创建或添加。

```
# 进入容器
docker exec -it container /bin/bash
# 创建用户名密码列表文件并添加名为 xiaoming 的用户
htpasswd -c /var/svn/svn-users.htpasswd xiaoming
# 在 /var/svn 目录下放置 authz 文件（本仓库中提供了该文件的模板），这一步不演示
...
# 由于在容器中是名为www-data的用户运行apache服务器，所以容器中的www-data用户要对/var/svn目录拥有读写权限，所以容器创建完成后，要更改/var/svn目录的所有者为www-data用户。
chown -R www-data:www-data /var/svn
```

然后，即可通过 https://ip:52121/ 访问。


## 创建SVN仓库
```
# 进入容器
docker exec -it container /bin/bash
# 切换用户身份为 www-data
su - www-data -s /bin/bash

# 切换到/var/svn目录下，并创建svn仓库
cd /var/svn
svnadmin create repos1

# 编辑 /var/svn/authz 文件，配置仓库授权
vi /var/svn/authz

```


## SVN用户管理
```
# 进入容器
docker exec -it container /bin/bash
# 添加用户或更新现有用户的密码
htpasswd /var/svn/svn-users.htpasswd xiaoming
# 删除用户
htpasswd -D /var/svn/svn-users.htpasswd xiaoming
```

