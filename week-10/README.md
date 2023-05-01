# TASK-9: Static website with S3 and CloudFront

*TASK-9 dostupan na [linku](https://github.com/allops-solutions/devops-aws-mentorship-program/issues/63)*

1. Kreirao staticki direktoriji i dodao `index.html`, `error.html` i `mentorship-img.PNG` fajlove.

2. Kreirao S3 bucket `vedad-nuhic-devops-mentorship-program-week-11` u eu-central-1 regiji, te upload-ovao prethodno kreirane fajlove za staticki website( kreirane fajlove mozete pronaci u `HTML` folderu). Takodjer omogucio sam `public access`, `bucket versioning` i omogucio `static website hosting`.

![S3-bucket-objects](.//Screenshots/S3-bucket-uploaded-files.png)

3. Konfigurisao `bucket policy` kako bih omogucio javni pristup za sve S3 bucket objekte.

```bash
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::example-bucket/*" 
            ]
        }
    ]
}
```
![bucket-policy](.//Screenshots/Bucket-policy.png)

4. S3 website endpoint: http://vedad-nuhic-devops-mentorship-program-week-11.s3-website.eu-central-1.amazonaws.com/

![S3-website-endpoint](.//Screenshots/Static-website-hosting.png)

Prikaz website-a:

![prikaz-S3-website](.//Screenshots/Static-website-prikaz.png)

5. Prije kreiranja CloudFront distribucije, moramo generisati Amazon SSL certifikat koristeci AWS Certificate Manager iz razloga sto se certifikat mora nalaziti unutar `us-east-1` regije kako bi mogli koristiti CludFront. Kreirao certifikat koji je izdat od strane Amazona u `us-east-1` regiji, te verifikovao ownership domenskog imena `vedad-nuhic.awsbosnia.com` koristeci komandu u AWS CloudShell-u:

```bash
`aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"_28a6188cb64189c8e8d2b13d36b04f00.www.vedad-nuhic.awsbosnia.com.","Type":"CNAME","TTL":60,"ResourceRecords":[{"Value":"__68f293f82b464c473abbf23152fe5fc9.fpgkgnzppq.acm-validations.aws."}]}}]}' --profile aws-bosnia`

```

![ACM-certificate](.//Screenshots/ACM-certifikat.png)

6. Kreirao CloudFront distribuciju sa Origin domenom koja pokazuje na S3 bucket website endpoint `http://vedad-nuhic-devops-mentorship-program-week-11.s3-website.eu-central-1.amazonaws.com`, Ime `vedad-nuhic-devops-mentorship-program-week-11.s3-website.eu-central-1.amazonaws.com`, Viewer protocol policy `Redirect HTTP to HTTPS`, zakacio prethodno generisani Amazon SSL certifikat te dodao alternativni naziv domene(CNAME) koja ce biti koristena za pristup stranici preko URL `www.vedad-nuhic.awsbosnia.com` za fajlove koje sluzi ova distribucija.

![CloudFront-overview](.//Screenshots/CloudFront-Distribution.png)

![CloudFront-origin](.//Screenshots/CloudFront-Origin.png)

![CloudFront-Behaviors](.//Screenshots/CloudFront-Behaviors.png)

7. Kreirao DNS CNAME record `www.vedad-nuhic.awsbosnia.com` unutar Hosted zone `awsbosnia.com` sa `Hosted Zone ID: Z3LHP8UIUC8CDK` koristeci kredincijale unutar profila `aws-bosnia` koji se nalaze na putanji `~/.aws/credentials` koji ce pokazivati na CloudFront distribucijsko ime `dsr6qms55zply.cloudfront.net`, koristeci sljedecu komandu:

```bash
# Route 53 konfiguracija
aws route53 change-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"www.vedad-nuhic.awsbosnia.com","Type":"CNAME","TTL":60,"ResourceRecords":[{"Value":"dsr6qms55zply.cloudfront.net"}]}}]}' --profile aws-bosnia
```

```bash
`aws route53 list-resource-record-sets --hosted-zone-id Z3LHP8UIUC8CDK | jq '.ResourceRecordSets[] | select(.Name == "www.vedad-nuhic.awsbosnia.com.") | {Name, Value}'`
```

![list-record](.//Screenshots/aws-route53-command.png)

8. Kopiramo domenu u browser `www.vedad-nuhic.awsbosnia.com`

![domena-browser](.//Screenshots/myDNS.png)

![domena-certifikat](.//Screenshots/myDNS-certifikat.png)