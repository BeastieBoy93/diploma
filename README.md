В данном README.md описывается создание инфраструктуры при помощи Terraform, подготовка инфраструктуры при помощи Ansible в рамках дипломного задания для Эсадова Романа.
1. Предварительно мною был подготвлено подключение к Yandex Cloud при помощи yandex cli и затем уже инциализиован Terraform для управления объектами Yandex Cloud.
![terr+yc](https://github.com/BeastieBoy93/diploma/blob/master/terr%2Byc.png)
---
2. В рамках задния по подготовке инфраструктуры были созданы конфиги main.tf, web-vms.tf, zabbix.tf, kibana.tf, elastic.tf. За основу ОС ВМ был взят образ Ubuntu 22.04
В файле main.tf описывается провайдер Terraform и id облака и папки в которых будут созданы объекты YC.
Остальные же файты описывают параметры виртуальных машин, в рамках которых будет поднято соответствующее ППО.
Также для управленя хостами был создан отдельный файл описывающий jump host для управления целевыми ресурсами.
В файле network.tf подготовлена сеть, подсети для вм, шлюз для машин на которых установлен веб-сервер, группы безопасности определяющие входящий и исходящий трафик только к необходимым портам.
Файл alb.tf описывает балансировщик и резервирует внешний IP направляющит трафик наизолированные машины с веб-серверами.
snapshot_create.tf создает начальный снепшот всех виртуальных машин, а snapshot-schedule.tf определяет правило создания и сроки хранения последующих снепшотов.
Для запуска инфраструктуры использую комманду ```terraform apply``` после чего происходит создание ресурсов YC, подтверждаю создание ресурсов командой ```yes```:
![terrarom_apply](https://github.com/BeastieBoy93/diploma/blob/master/terraform_apply.png)
![yes](https://github.com/BeastieBoy93/diploma/blob/master/yes.png)
---
3. После создания инфраструктуры, мною редактируется inventory.ini для указания выделенного IP bastion host. Затем для проверки доступности хостов при помощи Ansible выполняю команду ```ansible -i inventory.ini -m ping all```
![ping](https://github.com/BeastieBoy93/diploma/blob/master/ping.png)
После успешного выполнения операции начинаю устанавливать ППО nginx при помощий ansible-playbook nginx.yaml ```ansible-playbook -i inventory.ini nginx.yaml```
![nginx](https://github.com/BeastieBoy93/diploma/blob/master/nginx.png)
Обратившись к IP балансировщика получаем web страницу от одной из машин, принцип балансировки RR.
![web](https://github.com/BeastieBoy93/diploma/blob/master/web.png)
Начинаю установку ППО для сбора логов, было принято решение установки стека ELK через Docker. Для чего устанавливаю Docker на все целевые машины: web - для становки filebeat, kibana и elastic для утсановки одноименного ППО.
Выполняю команду ```ansible-playbook -i inventory.ini docker-install.yaml --limit '!bastion,!zabbix'``` для ограничения списка хостов на которые должен быть установлен Docker, результат:
![docker](https://github.com/BeastieBoy93/diploma/blob/master/docker.png)
После установки Docker приступаю к установке компонентов ELK, конмады:
* ```ansible-playbook -i inventory.ini elastic-install.yaml --ask-vault-pass```
* ```ansible-playbook -i inventory.ini elastic-install.yaml --ask-vault-pass```
![elk-kibana](https://github.com/BeastieBoy93/diploma/blob/master/elk-kibana.png)
* ```ansible-playbook -i inventory.ini filebeat-install.yaml --ask-vault-pass```
![filebeat](https://github.com/BeastieBoy93/diploma/blob/master/filebeat.png)
В рамках данных playbook создаются из шаблонов конфиг filebeat и compose файлы для Docker. После завершения установки, по белому IP хоста Kibana можем залогиниться для просмотра логов.
![логи](https://github.com/BeastieBoy93/diploma/blob/master/%D0%BB%D0%BE%D0%B3%D0%B8.png)
Логи попадают в целовой индекс `web-nginx-logs-*`.
Командами ```ansible-playbook -i inventory.ini pg.yaml``` и ```ansible-playbook -i inventory.ini zabbix.yaml --ask-vault-pass``` Запускаю БД PostgreSql и Zabbix сервер для создания средств мониторинга:
![pg](https://github.com/BeastieBoy93/diploma/blob/master/pg.png)
![zbx](https://github.com/BeastieBoy93/diploma/blob/master/zbx.png)
После поднятия ППО Zabbix на сервере, запускаю установку агентов на целевые хосты командой ```ansible-playbook -i inventory.ini zabbix-agent.yaml```
![agents](https://github.com/BeastieBoy93/diploma/blob/master/agents.png)
Приступаю к созданию хостов в Zabbix для подгтовки инфраструктурного мониторинга, хосты создаю с коннектом по FQDN:
![hosts](https://github.com/BeastieBoy93/diploma/blob/master/hosts.png)
