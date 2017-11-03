## Описание

Это Dockerfile, позволяющие собрать образ Docker для создания резервных копий баз данных MySQL.

## Репозиторий Git

Репозиторий исходных файлов данного проекта: [https://github.com/pgallery/mysql-backup](https://github.com/pgallery/mysql-backup)

## Репозиторий Docker Hub

Расположение образа в Docker Hub: [https://hub.docker.com/r/pgallery/mysql-backup/](https://hub.docker.com/r/pgallery/mysql-backup/)

## Использование Docker Hub

```
sudo docker pull pgallery/mysql-backup
```

## Доступные параметры конфигурации

### Основные параметры

**Обратите внимание**, если Вы используете данный образ для создания резервных копий pGallery, то данные параметры будут получены из файла /var/www/html/gallery/.env

 - **TIMEZONE**: временная зона контейнера, по умолчанию Europe/Moscow
 - **DB_HOST**: хост или IP сервера MySQL, по умолчанию 127.0.0.1
 - **DB_PORT**: порт, на котором работает MySQL, по умолчанию 3306
 - **DB_USERNAME**: имя пользователя MySQL, по умолчанию root
 - **DB_PASSWORD**: пароль пользователя MySQL
 - **DB_DATABASE**: имя базы данных MySQL

 - **DUMP_STORAGE**: тип хранилища резервных копий, доступные значения: local - на локальный диск, ssh - копирование по SSH на удаленный сервер, aws - AWS S3 удаленное хранилище
 - **DUMP_INTERVAL**: интервал создания резервных копий, в минутах, по умолчанию 1440 минут (раз в сутки)
 - **DUMP_BEGIN**: интервал времени, через который после запуска контейнера будет выполнена первая резервная копия, по умолчанию установлено 15 минут
 - **DUMP_PREFIX**: префикс имени архива резервной копии, по умолчанию 'db_'

 - **BACKUP_USER**: имя пользователя на удаленном сервере для сохранения резервной копии (необходимо доступ по SSH)
 - **BACKUP_PASSWORD**: пароль пользователя на удаленном сервере для сохранения резервной копии
 - **BACKUP_HOST**: хост или IP удаленного сервера
 - **BACKUP_DIR**: директория для сохранения резервной копии на удаленном сервере

#### Примеры использования

Загрука резервной копии на удаленный сервер по SSH:

```
sudo docker run -d \
    -e 'DB_USER=user_db' \
    -e 'DB_PASSWORD=NNNN' \
    -e 'DUMP_INTERVAL=240' \
    -e 'DUMP_PREFIX=docker1_' \
    -e 'BACKUP_USER=dockerbackup' \
    -e 'BACKUP_PASSWORD=NNNN' \
    -e 'BACKUP_HOST=192.168.1.100' \
    -e 'BACKUP_DIR=/home/dockerbackup/dump' \
    pgallery/mysql-backup

```

Сохранение резервных копий на локальном хранилище:

```
sudo docker run -d \
    --link mymysql:mysql \
    -v /home/username/sitename/dump/:/backup/ \
    -e 'DB_HOST=mysql' \
    -e 'DB_PASSWORD=MysqlRootPass' \
    pgallery/mysql-backup
```
