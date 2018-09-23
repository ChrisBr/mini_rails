require "sqlite3"

conn = SQLite3::Database.new "db/test.db"
conn.execute <<SQL
  create table article (
  id INTEGER PRIMARY KEY,
  title VARCHAR(30),
  body VARCHAR(32000));
SQL
