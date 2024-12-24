DROP DATABASE IF EXISTS @db_name;
CREATE DATABASE @db_name CHARACTER SET latin1 COLLATE latin1_general_ci;
USE @db_name;

SOURCE init.sql;