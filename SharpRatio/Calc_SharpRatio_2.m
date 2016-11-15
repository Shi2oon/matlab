clear;clc;
conn = database('data','root','66196619','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/data');
curs1 = exec(conn,'select symbol from data.nav_etf group by symbol');
curs1 = fetch(curs1);
data2 = curs1.Data;


fid=fopen('sharpratio_2016.txt','a+');
for i = 1:length(data2)
    sql = strcat('select clnav from data.nav_etf where symbol =" ',data2(i),'" and date>"2015-12-31" order by date asc');
    sql2 =sql{1};
    curs = exec(conn,sql2);
    curs = fetch(curs);
    data0 = curs.Data;
    %num = rows(curs);
    data1 = cell2mat(data0);
    %data2 = data1(1:num,1);
    dailyret = (data1(2:end)-data1(1:end-1))./data1(1:end-1);
    excessRet = dailyret - 0.03/252;
    sharpRatio = sqrt(252)*mean(excessRet)/std(excessRet);
    cumret = cumprod(1+dailyret)-1;
    %plot(cumret);
    [maxDrawdown maxDrawdownDuration]=calculateMaxDD(cumret); % count the maxdown and maxdown days
    
    fprintf(fid,'symbol= %s, ',char(data2(i)));
    fprintf(fid,'sharpRatio= %f, ',sharpRatio);
    fprintf(fid,'cumret= %f, ',cumret(end));
    fprintf(fid,'maxDrawdown= %f, ',maxDrawdown);
    fprintf(fid,'maxDrawdownDuration= %d \r\n',maxDrawdownDuration);
end
fclose(fid);