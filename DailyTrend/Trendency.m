% Initialization
clear;clc;
universe = [159915,510500,513500,513100];
mday =19;

% Get close price for each ETF in mday's ago
conn = database('data','root','66196619','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/data');
for i = 1:length(universe)
    sql = strcat('select closeprice from data.his_etf where symbol ="',num2str(universe(i)),'" order by date desc limit',{32},num2str(mday));
    curs = exec(conn,char(sql));
    curs = fetch(curs);
    data = curs.Data;
    data = cell2mat(data);
    closeprice(i)=data(mday);
end    

% Get name for each ETF
for i = 1:length(universe)
    sql = strcat('select name from data.id_list where symbol ="',num2str(universe(i)),'";');
    curs = exec(conn,char(sql));
    curs = fetch(curs);
    data = curs.Data;
    name(i)=data();
end  
close(conn)

% Get latest price for each ETF
codes = num2str(universe);
codes = strrep(codes,'159','s_sz159');
codes = strrep(codes,'51','s_sh51');
codes = strrep(codes,'  ',',');
url = strcat('http://qt.gtimg.cn/q=',codes);
[sourcefile, status] =urlread(url);
source = regexp(sourcefile, '\n', 'split'); 
source(end)=[];
for j=1:length(source)
    temp = char(source(j));   
    expr1 ='~.*?~';
    [datafile, data_tokens]= regexp(temp, expr1, 'match', 'tokens');
    temp_price = strrep(char(datafile(2)),'~','');
    retprice(j)=str2num(temp_price);
end

% Calculate return based on latestprice/closeprice(mdays' ago)*100
t_return = round(100*(retprice./closeprice - 1),3);

% Combine symbol, name and return into one list
for k=1:length(universe)
    symbol{k}=num2str(universe(k));
end
for g=1:length(t_return)
        ret{g}=strcat(num2str(t_return(g)),'%');
end
list = [symbol;name;ret]';

% Sort from largest return to smallest and show final result.
list = sortrows(list,-3)

%---The end---