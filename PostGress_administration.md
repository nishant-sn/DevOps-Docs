---PostGress DB Administration---

psql -U postgres
psql -U postgres hotel_checkin_master						(Login to db directly)
psql -U postgres hotel_checkin_master -W  					(If password prompt not given)
hotel_checkin_master=# \list								(To list/ show databases)
CREATE DATABASE <dbname>;									(To create database)
\connect <dbname> \c <dbname>;								(To connect/ use/ change database)
\dt 														(To Show tables)
\d <hotel>													(To describe table)
ALTER DATABASE db RENAME TO newdb;							(To rename db)
DROP DATABASE [IF EXISTS] name;								(To Delete db)
\du                                                         (To List Users)

__________________________________________________
Note: Delete database that has active connections:-
__________________________________________________

SELECT * FROM pg_stat_activity WHERE datname = 'testdb1'; 	(to find what activities are taking place against the testdb1database)
SELECT pg_terminate_backend (pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'testdb1'; 
DROP DATABASE testdb1;

________________________________________________
PostgreSQL copy database within the same server:-
________________________________________________

CREATE DATABASE targetdb WITH TEMPLATE sourcedb;


_________________________________________________
PostgreSQL copy database from a server to another:-
_________________________________________________

pg_dump -U postgres -O sourcedb sourcedb.sql
CREATE DATABASE targetdb;
psql -U postgres -d targetdb -f sourcedb.sql


IF database size is not so big

pg_dump -C -h local -U localuser sourcedb | psql -h remote -U remoteuser targetdb
