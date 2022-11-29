git pull && 
gitbook install && 
gitbook build &&
docker stop nginx-ssl &&
docker rm -v nginx-ssl &&
docker run \
-p 443:443 \
-p 80:80 \
-d --name nginx-ssl \
-v /home/rice/BookRead-Nginx/nginx:/etc/nginx/conf.d \
-v /home/rice/BookRead/_book:/usr/share/nginx/html \
-v /home/rice/BookRead-Nginx/nginx/cert/scs1651763427407_www.ricemarch.com_server.key:/etc/nginx/cert/scs1651763427407_www.ricemarch.com_server.key \
-v /home/rice/BookRead-Nginx/nginx/cert/scs1651763427407_www.ricemarch.com_server.crt:/etc/nginx/cert/scs1651763427407_www.ricemarch.com_server.crt \
nginx
