* **aws-deploy-ssl.sh** - Деплой Letsencrypt'овского сертификата в load-balancer на AWS
* **ebs-snapshot.sh** - Бекап через snaphots разделов (volumes) инстансов в AWS
* **servers4ansible.sh** - Создает список для inventory файла для Ansible. Берет из DNS зон на idl-vpn-gate:/var/named/*.local, tas.local.slave
* **get_vms.py** - Получение списка виртуальных машин с vCenter (VMWare)
* **check-idl-tunnel.sh** - перезапуск strongswan в случае если он упал (характерно для CentOS 8)
* **zone-conv.sh** - конвертор прямой зоны в обратную для Named. Работает через DDNS, которое нужно настроить в named.conf. Пример настройки named.conf:
```sh
zone "1.20.10.in-addr.arpa"  { type master; notify yes; masterfile-format text; file "/var/named/1.20.10-rev_idl.local";  allow-transfer { 127.0.0.1; 10.20.1.253; }; update-policy local; };
```
`Это прописать для всех зон, которые будет обновлять скрипт.`

* **sonatype_nexus/** - скрипт и playbook для Ansible по установке Sonatype Nexus Repository Manager (registry для docker, python, nodejs и т.д.)
* **ssh_tunnel.sh** - поднятие SSH тунеля (например для проброса порта MySQL с виртуалки на виртуалку, чтобы не пробрасывать порты через iptables и роутинг)
* **backup_sites_w_bases.sh** - бекап базы и сайта сперва в tgz, а потом трансфер на удаленный бекап сервер.
