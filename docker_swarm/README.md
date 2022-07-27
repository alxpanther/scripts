Скрипты и сервис скрипты для поднятия и нормальной работы Docker Swarm в Auto-Scale режиме для AWS

* **auto_scale.sh** - должен запускаться по крону (раз в минуту, например), чтобы на новые worker'ы запулить и поднять инстансы. В том числе и убрать из manager упоминания об уже отсутсвующих в случае, когда AWS удалил ноду.
* **node_rm.sh** - убирает упоминания о нодах, которые уже в Down режиме

* **docker-swarm-connect.service** - сервис для systemd, который подключает новую ноду к docker swarm и отключает, когда AWS закрывает (shutdown) ноду.
* **swarm_connect.sh** - скрипты подключения к docker swarm. Нужен для работы сервиса systemd "docker-swarm-connect"
* **swarm_leave.sh** - скрипты отключения от docker swarm при shutdown'е. Нужен для работы сервиса systemd "docker-swarm-connect"

* **docker-compose-aws.yml** - примерный docker-compose.yml файл со строчками для деплоя и обновления при изминении image
