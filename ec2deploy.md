<!--

Kendi domain adresinizde Node.js uygulamanızı yayınlamak için aşağıdaki adımları izleyebilirsiniz. Örnek olarak AWS EC2 üzerinde uygulamanızı çalıştıracak ve domain adresinizi bu sunucuya yönlendireceksiniz.

Adımlar
EC2 Instance Kurulumu
Node.js Uygulamanızı EC2'ye Dağıtma
EC2 Güvenlik Gruplarını Yapılandırma
Domain DNS Ayarlarını Yapılandırma
EC2'de Nginx ile Reverse Proxy Kurulumu (Opsiyonel)
1. EC2 Instance Kurulumu
AWS Management Console'a gidin ve EC2 hizmetini seçin.
"Launch Instance" butonuna tıklayın.
Bir Amazon Machine Image (AMI) seçin (örn. Amazon Linux 2).
Instance türünü seçin (örn. t2.micro).
Diğer ayarları yapın ve instance'ı başlatın.
Key pair'inizi indirin ve kaydedin (SSH bağlantısı için gereklidir).
2. Node.js Uygulamanızı EC2'ye Dağıtma
EC2 instance'ınıza SSH ile bağlanın:

bash
Code kopieren
ssh -i /path/to/your-key-pair.pem ec2-user@your-ec2-instance-ip
Node.js ve PM2'yi kurun:

bash
Code kopieren
sudo yum update -y
sudo yum install -y nodejs npm
sudo npm install -g pm2
Uygulamanızı EC2 instance'ına kopyalayın:

bash
Code kopieren
scp -r my-node-app ec2-user@your-ec2-instance-ip:/home/ec2-user/
3. EC2 Güvenlik Gruplarını Yapılandırma
AWS Management Console'da EC2 hizmetine gidin.
"Security Groups" kısmına gidin.
EC2 instance'ınızın bağlı olduğu güvenlik grubunu seçin.
"Inbound rules" kısmına HTTP (80) ve/veya HTTPS (443) portlarını ekleyin.
4. Domain DNS Ayarlarını Yapılandırma
Domain sağlayıcınızın yönetim paneline gidin ve DNS ayarlarını aşağıdaki gibi yapılandırın:

Yeni bir A kaydı ekleyin.
Hostname olarak "@" veya istediğiniz subdomain'i girin.
Value olarak EC2 instance'ınızın IP adresini girin.
TTL süresini ayarlayın (genelde 3600 saniye).
5. EC2'de Nginx ile Reverse Proxy Kurulumu (Opsiyonel)
Nginx kullanarak uygulamanızı reverse proxy ile yayına alabilirsiniz. Bu, uygulamanızın port 80 (HTTP) veya 443 (HTTPS) üzerinden erişilebilir olmasını sağlar.

Nginx'i kurun:

bash
Code kopieren
sudo amazon-linux-extras install nginx1 -y
sudo service nginx start
Nginx konfigürasyonunu yapılandırın:

bash
Code kopieren
sudo vi /etc/nginx/conf.d/my-node-app.conf
Aşağıdaki içeriği ekleyin:

nginx
Code kopieren
server {
    listen 80;
    server_name sumeyyedev.site;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
Nginx'i yeniden başlatın:

bash
Code kopieren
sudo service nginx restart
Node.js uygulamanızı başlatın:

bash
Code kopieren
cd /home/ec2-user/my-node-app
npm install
pm2 start app.js
-->