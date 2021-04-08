#!/bin/sh

CERT_DATE=`date "+%Y%m%d%H%M%S"`
CERT_PATH="/etc/letsencrypt/live/dii.dn.ua" # путь где лежат сертификаты
CERT_DOMAIN_NAME="dii-dn"                   # через черточки, а не точки
CERT_NAME=${CERT_DOMAIN_NAME}-${CERT_DATE}  # уникальное (домен+текущая дата) имя для сертификата в AWS

LOAD_BALANCER_NAME='diidn'                  # имя load-balancer'а в AWS

cd ${CERT_PATH}
echo "Deploy NEW certificate to AWS..."
aws iam upload-server-certificate --server-certificate-name ${CERT_NAME} --certificate-body file://cert.pem --private-key file://privkey.pem --certificate-chain file://chain.pem

NEW_CERT_ARN=`aws iam list-server-certificates | grep "Arn" | egrep "${CERT_DATE}" |  awk '{print $2}' | sed "s/[\",]*//g"`
echo "NEW Certificate ID: ${NEW_CERT_ARN}"

echo "Waiting 20 seconds for setup NEW certificate for load-balancer..."
sleep 20
aws elb set-load-balancer-listener-ssl-certificate --load-balancer-name $LOAD_BALANCER_NAME --load-balancer-port 443 --ssl-certificate-id $NEW_CERT_ARN

echo "Waiting 5 seconds for delete OLD certificate from AWS..."
sleep 5
aws iam list-server-certificates | egrep ".*ServerCertificateName.*${CERT_DOMAIN_NAME}" | awk '{print $2}' | sed "s/[\",]*//g" | grep -v "${CERT_DATE}" | xargs -I aaa aws iam delete-server-certificate --server-certificate-name aaa
