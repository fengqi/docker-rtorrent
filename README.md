# docker-rutorrent

# 运行
`docker run -d -p 8090:8090 lyf362345/rutorrent`
默认端口 8090

# 相关目录
配置文件 /app/conf
会话状态 /app/sessions
下载目录 /app/downloads

首次运行会自动把 rTorrent 和 ruTorrent 的配置文件放入到 /app/conf 下面

# 访问验证
默认登录用户为 admin 密码 123456
如需修改, 在首次启动后, 修改 /app/conf 目录下的 httpPassword
密码为加密方式, nginx 支持多种认证方式, 示例 printf "admin:$(openssl passwd -crypt 123456)\n"
把输出的全部内容写入到 httpPassword

目前镜像比较大, 稍后使用 alpine 优化
