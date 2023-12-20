
1) 
# Сделать дамп базы "testdb"
pg_dump -U postgres -Fc -d testdb -f "C:/University Labs/Databases/Postgres/Files/testdb.dump"

2) 
# Восстановить базу в базу "testdb2"
CREATE DATABASE testdb2;
pg_restore -U postgres -Fc -d testdb2 "C:/University Labs/Databases/Postgres/Files/testdb.dump"


3) 
# Сделать дамп таблицы "geo"
pg_dump -U postgres -Fc -d testdb -t geo -f "C:/University Labs/Databases/Postgres/Files/geo.dump"

4) 
# Восстановить таблицу в базу "testdb2"
pg_restore -U postgres -Fc -d testdb2 -t geo "C:/University Labs/Databases/Postgres/Files/geo.dump"


5) 
# Сделать дамп только данных таблицы "table1"
pg_dump -U postgres -Fc -d testdb -t table1 --data-only --column-inserts -f "C:/University Labs/Databases/Postgres/Files/table1_data.dump"

# Восстановить данные таблицы "employ"
TRUNCATE table1;
pg_restore -U postgres -Fc --data-only -d testdb -t table1 "C:/University Labs/Databases/Postgres/Files/table1_data.dump"


6)
# Сделать дамп только схемы базы данных "testdb"
pg_dump -U postgres -Fc -d testdb --schema-only -f "C:/University Labs/Databases/Postgres/Files/testdb_schema.dump"

# Восстановить схему базы в базу "testdb3"
CREATE DATABASE testdb3;
pg_restore -U postgres -Fc -d testdb3 "C:/University Labs/Databases/Postgres/Files/testdb_schema.dump"


7)
# Выполнить дамп базы "testdb" в формате скрипта SQL
pg_dump -U postgres -Fp -d testdb -f "C:/University Labs/Databases/Postgres/Files/testdb_dump.sql"

8)
# Зайти в базу "testdb4", восстановив дамп базы из скрипта
CREATE DATABASE testdb4;
psql -U postgres -d testdb4 -f "C:/University Labs/Databases/Postgres/Files/testdb_dump.sql"