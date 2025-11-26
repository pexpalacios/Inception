#!/bin/bash
set -e

MYSQL_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
MYSQL_PASSWORD="$(cat $MYSQL_PASSWORD_FILE)"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
mkdir -p /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql

#Ensure database folder exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo " [+] Creando base de datos MariaDB"
	mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	echo " [+] Base de datos inicializada"
fi

#Start config
mysqld &

#mysqld --skip-networking \
#       --socket=/run/mysqld/mysqld-init.sock &
#pid="$!"

#Wait for server to start
for i in {30..0}; do
 if mysqladmin ping --silent; then
  break;
 fi
 sleep 1
done

if [ "$i" = 0 ]; then
 echo "MariaDB init process failed."
 exit 1
fi

#Create user, db and password from env
mysql -e "CREATED DATABASE IF NOT EXISTS $MYSQL_DATABASE;"
mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' INDETIFIED BY '$MYSQL_PASSWORD';"
mysql -e "GRANT ALL PRIVILAGES ON $MYSQL_DATABSE.* TO '$MYSQL_USER¡@'%';"
mysql -e "FLUSH PRIVILEGES;"

#Stop config server
mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown
#mysqladmin --socket=/run/mysqld/mysqld-init.sock -u root shutdown

wait

#Execute real mariadb server
exec mysqld