clear;
clc;
close all;

%游标fetch的方法获取数据
conn = database('data', 'root', '66196619', 'com.mysql.jdbc.Driver', 'jdbc:mysql://localhost:3306/data');
curs = exec(conn, 'select * from data.his_etf limit 100');
dbdata = fetch(curs);
cur = dbdata.Data;
symbol = cur(1,1)
date = cur(1,2)
close(curs);
close(conn);

%数据库fetch的方法获取数据
conn2=database('data', 'root', '66196619', 'com.mysql.jdbc.Driver', 'jdbc:mysql://localhost:3306/data');
dbdata2=fetch(conn2, 'select * from data.his_etf limit 100');
symbol = dbdata2(1,1)
date = dbdata2(1,2)
close(conn2)
   