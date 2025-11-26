FROM debian:12

#INstall MariaDB
RUN apt-get update && apt-get install -y mariadb-server && apt-get clean
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

#Copy custom config
COPY ./conf/my.cnf /etc/mysql/my.cnf

#Copy initialization script
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

HEALTHCHECK --start-period=30s \
	CMD mysqladmin ping --silent || exit 1

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD ["mysqld"] runs the server, ["mariadb"] runs the client
