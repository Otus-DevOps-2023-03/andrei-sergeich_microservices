# OTUS HW microservices

## ДЗ по модулю "Docker контейнеры. Docker под капотом"

### В ходе ДЗ выполнено

* Установил ***docker***, ***docker-compose***, ***docker-machine***
* Создал свой ```docker image```
* Описал различия между контейнером и образом
* С помощью ```yc cli``` создал ВМ в облаке (команды обернул в скрипты)
* С помощью ```docker-machine``` инициализировал на инстансе докер хост систему (команды обернул в скрипты)
* Собрал образ *reddit* на инстансе, запустил контейнер на его оснве
* Загрузил образ на *docker hub*
* Запустил контейнер на основе образа из *docker hub* на локальной машине

Для сборки:

* перейти в каталог **docker-monolith**
* поднять инстанс, запустив скрипт:

    ``` bash
    bash intra_create.sh
    ```

* подставить IP адрес созданной VM в скрипт ```env_init.sh``` и запустить его:

    ``` bash
    bash env_init.sh
    ```

* переключиться на удаленный докер демон в Yandex Cloud:

    ``` bash
    eval $(docker-machine env docker-host)
    ```

* собрать образ на удаленном хосте:

    ``` bash
    docker build -t reddit:latest .
    ```

    > точка в конце обязательна, она указывает на путь до Docker-контекста

* запустить контейнер на удаленном хосте:

    ``` bash
    docker run --name reddit -d --network=host reddit:latest
    ```

Для проверки:

* открыть в браузере <http://IP_адрес_созданной_VM:9292>

### Задание со *

* Все файлы находятся в каталоге **docker-monolith/infra**
* Реализовал поднятие инстансов с помощью ```Terraform``` (на основе образа *ubuntu-1604-lts*),
их количество задается переменной
* Динамический инвентори генерируется с помощью ```Terraform```
* Написал 2 плейбука ```Ansible``` для установки ```Docker``` и запуска там образа приложения

  Для сборки:

  * перейти в каталог **docker-monolith/infra**
  * поднять инстанс, выполнив команды:

      ``` bash
      terraform init
      terraform plan
      terraform apply
      ```

  * запустить плейбуки ```Ansible``` для установки ```Docker``` и запуска там образа приложения:

      ``` bash
      ansible-playbook install_docker.yml
      ansible-playbook start_container.yml
      ```
