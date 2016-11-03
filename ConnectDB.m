conn = database('data','root','66196619','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/data')
curs = exec(conn,'select closeprice,highprice,lowprice,openprice from data.his_idx where symbol ="399006" order by date desc limit 10')
curs = fetch(curs)
data0 = curs.Data
num = rows(curs)
data1 = cell2mat(data0)
data2 = data(1:num,1)