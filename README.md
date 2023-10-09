* **aws-deploy-ssl.sh** - Деплой Letsencrypt'овского сертификата в load-balancer на AWS
* **ebs-snapshot.sh** - Бекап через snaphots разделов (volumes) инстансов в AWS
* **servers4ansible.sh** - Создает список для inventory файла для Ansible. Берет из DNS зон на idl-vpn-gate:/var/named/*.local, tas.local.slave
* **get_vms.py** - Получение списка виртуальных машин с vCenter (VMWare)
* **check-tunnel-strongswan.sh** - перезапуск strongswan в случае если он упал (характерно для CentOS 8)
* **zone-conv.sh** - конвертор прямой зоны в обратную для Named. Работает через DDNS, которое нужно настроить в named.conf. Пример настройки named.conf:
```sh
zone "1.20.10.in-addr.arpa"  { type master; notify yes; masterfile-format text; file "/var/named/1.20.10-rev_idl.local";  allow-transfer { 127.0.0.1; 10.20.1.253; }; update-policy local; };
```
`Это прописать для всех зон, которые будет обновлять скрипт.`

* **sonatype_nexus/** - скрипт и playbook для Ansible по установке Sonatype Nexus Repository Manager (registry для docker, python, nodejs и т.д.)
* **mail_log2telegram/** - сервис для отправки в Telegram ошибок 55* из лога почты (например Exim). Чтобы сразу видеть, что какое-то сообщение не ушло и причина какая
* **grep_mail_logs/** - Web сервис для поиска в логах почты определенного адреса. Поиск идет по любому полю, будь-то email адрес или внутренни ID почтовика
* **openvas/** - OpenVAS для сканирования уязвимостей
* **ssh_tunnel.sh** - поднятие SSH тунеля (например для проброса порта MySQL с виртуалки на виртуалку, чтобы не пробрасывать порты через iptables и роутинг)
* **backup_sites_w_bases.sh** - бекап базы и сайта сперва в tgz, а потом трансфер на удаленный бекап сервер.
* **backup_gitlab.sh** - бекап GitLab'а
* **krew_install.sh** - инсталяха для KREW (дополнение для kubectl)
* **apache2iptables_ban.sh** - BAN IP адресов на определенные web запросы при сильной атаке. Вариант для Apache
* **nginx2iptables_ban.sh** - BAN IP адресов на определенные web запросы при сильной атаке. Вариант для nginx
* **china_ban.sh** - BAN только IP Китая
* **block_us.sh** - Сети Google в whitelist через ipset чтобы не забанить
* **skype_repo_fix.sh** - Скачивание нового PGP ключа для Skype репозитория (для Ubunu/Mint)
* **domain_date.sh** - получение даты, когда истекает регистрация доменов. Можно чуть видоименить скрипт, чтобы подключить его, например к Zabbix и таким образом мониторить expire доменов.
* **create-instance-over-qemu.sh** - создание виртуальной машины в QEMU через Ubuntu/CentOS/Fedora с провиженингом через cloud-init
* **docker_swarm** - все, что нужно для менеджмента docker swarm при работе через Auto-Scale в AWS
* **docker-compose-gitlab2telegram.yml** - Gitlab Webhook в Telegram. В docker-compose.yml поменять url и токен Telegram бота
* **cloudflare_iptables.sh** - начитка IP с CloudFlare и создание таблицы с этими адресами

# Сайт сканера безопасности для сайтов

https://sitecheck.sucuri.net/

# Скрипт для проверки сайта на предмет заражения

https://revisium.com/

Скрипт на PHP. Нужно скачать и просканировать сайт внутри самого сервера.

# Сайт сканера на SSL

https://www.ssllabs.com/ssltest/

# Некоторые команды и/или скрипты в одну строку

### Поиск того, что в swap'е
```sh
for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | more
```

### Добавление IP адреса на RedHat's "на лету"
```sh
nmcli con mod enp1s0 +ipv4.addresses "192.168.1.51/24"
nmcli con up enp0s3
```

### Telnet в Alpine Linux
```sh
apk update
apk add busybox-extras
busybox-extras telnet localhost 6900
```
