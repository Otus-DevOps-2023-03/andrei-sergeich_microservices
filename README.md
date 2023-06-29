# andrei-sergeich_microservices
andrei-sergeich microservices repository

## ДЗ по модулю "Docker контейнеры. Docker под капотом"

В ходе ДЗ выполнено:

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
    eval $(docker-machine env <имя>)
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
