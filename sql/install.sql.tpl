DROP DATABASE IF EXISTS @db_name;
CREATE DATABASE @db_name;
USE @db_name;

SOURCE init.sql;