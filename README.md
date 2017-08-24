# docker-rutorrent

# 运行
`docker run -d -p 8090:8090 lyf362345/rutorrent`
默认端口 8090

# 相关目录
配置文件 /app/conf
会话状态 /app/sessions
下载目录 /app/downloads
自动挂种 /app/watch/

首次运行会自动把 rTorrent, ruTorrent, 访问验证 的配置文件放入到 /app/conf 下面

# 访问验证
默认登录用户为 admin 密码 123456
命令行运行命令生密码成: printf "admin:$(openssl passwd -crypt 123456)\n"
把输出的全部内容写入到 /app/conf/httpPassword

> 修改配置需要重启容器
