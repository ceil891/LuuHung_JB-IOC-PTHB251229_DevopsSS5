-- Only creates databases and roles; Hibernate creates all application tables.
\getenv db_name USER_DB_NAME
\getenv db_user USER_DB_USERNAME
\getenv db_pass USER_DB_PASSWORD
SELECT format('CREATE ROLE %I LOGIN PASSWORD %L', :'db_user', :'db_pass')
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = :'db_user') \gexec
SELECT format('CREATE DATABASE %I OWNER %I', :'db_name', :'db_user')
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = :'db_name') \gexec

\getenv db_name RESTAURANT_DB_NAME
\getenv db_user RESTAURANT_DB_USERNAME
\getenv db_pass RESTAURANT_DB_PASSWORD
SELECT format('CREATE ROLE %I LOGIN PASSWORD %L', :'db_user', :'db_pass')
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = :'db_user') \gexec
SELECT format('CREATE DATABASE %I OWNER %I', :'db_name', :'db_user')
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = :'db_name') \gexec

\getenv db_name ORDER_DB_NAME
\getenv db_user ORDER_DB_USERNAME
\getenv db_pass ORDER_DB_PASSWORD
SELECT format('CREATE ROLE %I LOGIN PASSWORD %L', :'db_user', :'db_pass')
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = :'db_user') \gexec
SELECT format('CREATE DATABASE %I OWNER %I', :'db_name', :'db_user')
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = :'db_name') \gexec

\getenv db_name NOTIFICATION_DB_NAME
\getenv db_user NOTIFICATION_DB_USERNAME
\getenv db_pass NOTIFICATION_DB_PASSWORD
SELECT format('CREATE ROLE %I LOGIN PASSWORD %L', :'db_user', :'db_pass')
WHERE NOT EXISTS (SELECT FROM pg_roles WHERE rolname = :'db_user') \gexec
SELECT format('CREATE DATABASE %I OWNER %I', :'db_name', :'db_user')
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = :'db_name') \gexec
