\set db_name `echo "whitebox_$RAILS_ENV"`
\echo :db_name
CREATE DATABASE :db_name;
CREATE DATABASE whitebox_test;
