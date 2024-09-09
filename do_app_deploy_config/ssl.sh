
mkdir /var/www/ssl
cd /var/www/ssl
mkdir ca

#第一步：生成CA证书
openssl genrsa -out ca/ca-key.pem 2048
#2、创建证书请求
openssl req -new -out ca/ca-req.csr -key ca/ca-key.pem
#（这一步，Common Name要填写自己的域名）
#3、自签署证书，有效期10年
openssl x509 -req -in ca/ca-req.csr -out ca/ca-cert.pem -signkey ca/ca-key.pem -days 3650



mkdir server
#第二步：生成Server证书
#1、创建私钥
openssl genrsa -out server/server-key.pem 2048
#2、创建证书请求
openssl req -new -out server/server-req.csr -key server/server-key.pem
#（这一步，Common Name要填写自己的域名）
#3、用自己的CA证书，签署Server证书
openssl x509 -req -in server/server-req.csr -out server/server-cert.pem -signkey server/server-key.pem -CAkey ca/ca-key.pem -CAcreateserial -days 3650
#创建Server证书之后，与Ca证书合成完整的证书链：
cat server/server-cert.pem ca/ca-cert.pem > full.pem

nginx -t
service nginx reload