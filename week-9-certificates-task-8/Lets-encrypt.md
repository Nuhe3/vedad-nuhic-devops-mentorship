# Task 8 - Let's Encrypt SSL Certificate on EC2 Amazon Linux AMI3 (Nginx) step by step solution

### Zadatak 1 

* Od postojeceg AMI image sam kreirao EC2 instancu `ec2-vedad-nuhic-task-8`

![ami-ec2-vedad-nuhic-web-server](.//screenshots/AMI-web-server.png)

![ec2-created-from-AMI](.//screenshots/ec2-from-AMI-web-server.png)

### Zadatak 2

* Kreiran DNS record `vedad-nuhic.awsbosnia.com` za Hosted Zone awsbosnia.com (`Hosted Zone: Z3LHP8UIUC8CDK`) koji ce da pokazuje na EC2 instancu koju sam prethodno kreirao. Za kreiranje DNS zapisa koristio sam AWS CLI sa AWS kredincijalima koji su se nalazili unutar proslijedjenog excel file. AWS CLI sam konfigurisao tako da koristi named profile aws-bosnia.
* Komande koje sma koristio prilikom izrade ovog dijela zadatka su sljedece:

* `aws configure --profile aws-bosnia` - komanda za konfigurisanje profila `aws-bosnia`

* `aws configure list-profiles` - komanda koja ipisuje listu svih dostupnih profila - ukljucujuci i `aws-bosnia`

* Komanda `change-resouce-record`
```bash 
* `aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"vedad-nuhic.awsbosnia.com.","Type":"A","TTL":60,"ResourceRecords":[{"Value":"52.59.217.85"}]}}]}'`
```
* `Name` - upisujemo svoj DNS record
* `Value` - upisujemo IP adresu instance

* Napomena:
    * Prije svega navedenog u rijesavanju zadatka 2 nepohodno je instalirati `jq` tool prije toga komandom - `yum install jq`

![Kreiranje-DNS-Record](.//screenshots/Kreiranje-DNS-recorda.png)

### Zadatak 3

* *Na EC2 instanci `ec2-ime-prezime-task-8` kreirati Let's Encrypt SSL certifikat za vasu domenu. Neophodno je omoguciti da se nodejs aplikaciji moze pristupiti preko linka `https://<ime>-<prezime>.awsbosnia.com`, to verifikujte skrinsotom gdje se vidi validan certifikat u browseru.*

Za kreiranje Lets Encrypt certifikata iskorisiti cemo [certbot](https://certbot.eff.org/) alat. **Certbot** je alat koji nam omogucava da automatski generisemo i instaliramo SSL certifikat.
*Na Amazon Linux Ami 3 cert bot cemo instalirati koristeci **pip alat**.*

```bash
Komande u AWS CLI

sudo dnf install python3 augeas-libs
sudo python3 -m venv /opt/certbot/
sudo /opt/certbot/bin/pip install --upgrade pip
sudo /opt/certbot/bin/pip install certbot certbot-nginx
sudo ln -s /opt/certbot/bin/certbot /usr/bin/certbot
sudo ls -la /usr/bin/certbot # da vidimo link 
sudo certbot certonly --nginx # I am feeling conservative :) you can use sudo certbot --nginx instead to automatize the process
```
#### Zahtjev certifikata za nasu domenu
Output komande `sudo certbot certonly --nginx`:

* dodamo email adresu
* prihvatimo uslove koristenja
* Mozemo i ne moramo prihvatiti da na email salju emails sa ponudama i sl.
* unesemo domene u dole oznacenom polju  `Please enter the domain name(s)...`

```bash
[root@ip-172-31-91-148 ~]# sudo certbot certonly --nginx
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Please enter the domain name(s) you would like on your certificate (comma and/or
space separated) (Enter 'c' to cancel): vedad-nuhic.awsbosnia.com.awsbosnia.com, www.vedad-nuhic.awsbosnia.com.awsbosnia.com
Requesting a certificate for ssl.awsbosnia.com and www.ssl.awsbosnia.com 
# !!!U OVOM DIJELU UNESEMO DOMENU ZA KOJU ZAHTJEVAMO CERTIFIKAT!!!

Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/vedad-nuhic.awsbosnia.com/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/vedad-nuhic.awsbosnia.com/privkey.pem
This certificate expires on 2023-07-14.
These files will be updated when the certificate renews.

NEXT STEPS:
- The certificate will need to be renewed before it expires. Certbot can automatically renew the certificate in the 
background, but you may need to take steps to enable that functionality. See https://certbot.org/renewal-setup for instructions.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```
![certbot-nginx](.//screenshots/certbot-nginx-certificate.png)

Vidimo da su nasli certifikati na sljedecoj lokaciji:

```
Certificate is saved at: /etc/letsencrypt/live/vedad-nuhic.awsbosnia.com/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/vedad-nuhic.awsbosnia.com/privkey.pem
```

Prilikom izvrsenja komande
 `$ ls -la /etc/letsencrypt/live/vedad-nuhic.awsbosnia.com/` i `cat README` trebamo zapamtiti sljedece termine:
`privatekey.pem` - privatni kljuc za nas certifikat
`fullchain.pem` - fajl certifikata koristen od strane server softvera tj. nginx i OS

**Potvrditi email od certbot-a!!**

## Nakon izdavanja certifikata sljedece sto trebamo uraditi jeste omogucivanje zahtjeva za HTTPS

* To radimo kroz sljedece korake: 

1. Azuriramo `security group` na nacin da dodamo inbound rule `HTTPS port 443 anywhere`

2. Azuriramo `node-app.conf` koji se nalazi na putanji `etc/nginx/conf.d` te postojeci sadrzaj izbrisemo i dodamo sljedece:

```bash
server {
  listen 80;
  server_name <domensko-ime.com>;
  return 301 https://$server_name$request_uri;
}

server {
  listen 443 ssl;
  server_name <domensko-ime.com>;

  ssl_certificate /etc/letsencrypt/live/<domensko-ime.com>/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/<domensko-ime.com>/privkey.pem;

  location / {
    proxy_pass http://127.0.0.1:8008;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection 'upgrade';
    proxy_set_header Host $host;
    proxy_cache_bypass $http_upgrade;
  }
}
ECS 
:wq
```
3. Restartujemo nginx server komandom `sudo systemctl restart nginx` (ako smo user) ili `systemctl restart nginx` (ako smo root)

4. Kucamo komandu `nginx -t` koja nam daje povratnu informaciju da li je nasa skripta sintaksicki ispravna i da li ima nekih gresaka

* Nakon sto smo ispunili navedene korake, mozemo pristupiti nasoj web aplikaciji preko sigurne HTTPS veze koristeci domensko ime: 
`https://vedad-nuhic.awsbosnia.com`

### Zadatak 4
* *Omoguciti autorenewal SSL certifikata*

* To radimo uz pomoc sljedece skripte:
```bash
SLEEPTIME=$(awk 'BEGIN{srand(); print int(rand()*(3600+1))}'); echo "0 0,12 * * * root sleep $SLEEPTIME && certbot renew -q" | sudo tee -a /etc/crontab > /dev/null
```
* detaljnije na [certbot dokumentacija za renewal](https://eff-certbot.readthedocs.io/en/stable/using.html#setting-up-automated-renewal)

### Zadatak 5
* *Koristeci openssl komande prikazati koji SSL certitikat koristite i datum njegovog isteka. Probajte korisitit razlicite openssl komande (HINT: Biljeskama za office hours imate knjigu u kojoj mozete pronaci recepte za razlicite openssl komande)*

## Komande za prikazivanje certifikata i datuma njegovog isteka - openssl komande

Komande:
```bash
echo | openssl s_client -showcerts -servername <ime-prezime>.awsbosnia.com -connect <ime-prezime>.awsbosnia.com:443 2>/dev/null | openssl x509 -inform pem -noout -text
```
![openssl](.//screenshots/echo-command.png)

ili 
```bash
openssl s_client -showcerts -connect vedad-nuhic.awsbosnia.com:443 2>/dev/null | openssl x509 -noout -text
```
![openssl](.//screenshots/task-8-slika-6.png)


### Zadatak 6
* *Importujte Lets Encrypt SSL certifikat unutar AWS Certified Managera*

![ACM](.//screenshots/task-8-slika-10.png)

### Zadatak 7
*  *Kreirajte Load Balancer gdje cete na nivou Load Balancera da koristite SSL cert koji ste ranije importovali. (Hint: NGINX config je nophodno auzrirati). Load Balancer u pozadini koristi EC2 instancu ec2-ime-prezime-task-8, nije potrebno kreirati ASG.*

![ALB-sa-SSL-Cert](.//screenshots/accesing-web-app-via-alb.png)

### Zadatak 8
* *Koristeci openssl komande prikazati koji SSL certitikat koristite za vasu domenu i datum njegovog isteka.* 

```bash
openssl s_client -showcerts -connect ime-prezime.awsbosnia.com:443 2>/dev/null | openssl x509 -noout -text
```

![openssl](.//screenshots/echo-command.png)

### Zadatak 9
* *Kreirajte novi SSL certifikat unutar AWS Certified Managera, azurirajte ALB da koristi novi SSL cert koji ste kreirali.*

![alb-with-sss-cert](.//screenshots/alb-with-ssl-cert.png)
![target-groups](.//screenshots/target-groups-for-alb.png)

### Zadatak 10
* *Koristeci openssl komande prikazati koji SSL certitikat koristite za vasu domenu i datum njegovog isteka.*

![slika-isteka](.//screenshots/task-8-slika-12.png)

### Zadatak 11
* *Kada zavrsite sa taskom kreirajte AMI image pod nazivom `ami-ec2-ime-prezime-task-8` i terminirajte resurse koje ste koristili za izradu taska.*

![ami-za-kraj](.//screenshots/ami-task-8.png)