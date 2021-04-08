# Описание
[zabbix-kubernetes-monitoring](https://gitlab.indevlab.com/SysAdm/scripts/-/tree/master/zabbix/zabbix-kubernetes-monitoring) Монитор кластера Kubernetes через Zabbix. Автоматически появляются все сущности для pods, deployments, services, и д.р.
Как ставить можно почитать ниже где английский вариант.
Здесь некоторая адаптация этого мониторинга под возможность мониторить сразу множество кластеров, а не один. Для этого несколько изменен шаблон, конфигурационный файл zabbix-agent'а и сам Python'овский скрипт.

Также, необходимо для каждого кластера задавать свои макросы: ``{$K8S_HTTPS}`` и ``{$K8S_TOKEN}``. Где и как взять ``{$K8S_HTTPS}`` макрос описано ниже в английском вараинте там где "..**API SERVER**". Вот с ``{$K8S_TOKEN}`` сложнее обстоит дело:
1. Тот токен, который можно создать и потом показать в пунктах описанных ниже, слишком длинный, чтобы его вставлять в макрос.
2. Я рекомендую использовать токен от админской учетки - брать в config файле, который подсовывается для работы самому kubectl (~/.kube/config) - там токен короче на много.
---


# Description (english OLD)
[zabbix-kubernetes-monitoring](https://github.com/sleepka/zabbix-kubernetes-monitoring) is zabbix-agent script and template for zabbix server. It is used for Kubernetes monitoring by Zabbix.
Easy to deploy and configure. Auto discovery of pods, deployments, services, etc.

# Installation (english OLD)
1. Copy [k8s-stats.py](https://raw.githubusercontent.com/sleepka/zabbix-kubernetes-monitoring/master/k8s-stats.py) to /etc/zabbix/scripts/ and
   [k8s.conf](https://raw.githubusercontent.com/sleepka/zabbix-kubernetes-monitoring/master/k8s.conf) to /etc/zabbix/zabbix_agentd.d/. Remind to give execute permission to the file: ``chmod +x k8s-stats.py``
2. Import Zabbix template ([k8s-zabbix-template.xml](https://raw.githubusercontent.com/sleepka/zabbix-kubernetes-monitoring/master/k8s-zabbix-template.xml)) to Zabbix server
3. Create zabbix user in Kubernetes (can use [zabbix-user-example.yml](https://raw.githubusercontent.com/sleepka/zabbix-kubernetes-monitoring/master/zabbix-user-example.yml)) and set it's token and API server url in [k8s-stats.py](https://raw.githubusercontent.com/sleepka/zabbix-kubernetes-monitoring/master/k8s-stats.py).
4. Apply template to host

## How to create zabbix user in Kubernetes
```bash
$ kubectl apply -n kube-system -f zabbix-user-example.yml
serviceaccount/zabbix-user created
clusterrole.rbac.authorization.k8s.io/zabbix-user created
clusterrolebinding.rbac.authorization.k8s.io/zabbix-user created
```

## How to retrieve TOKEN and API SERVER
1. **TOKEN**:
```bash
$ TOKENNAME=$(kubectl get sa/zabbix-user -n kube-system -o jsonpath='{.secrets[0].name}')
$ TOKEN=$(kubectl -n kube-system get secret $TOKENNAME -o jsonpath='{.data.token}'| base64 --decode)
$ echo $TOKEN
```
2. **API SERVER**:
```bash
$ APISERVER=https://$(kubectl -n default get endpoints kubernetes --no-headers | awk '{ print $2 }')
$ echo $APISERVER
```
