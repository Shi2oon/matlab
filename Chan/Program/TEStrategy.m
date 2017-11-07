%% 清理工作
clear;
clc;
close all;

%% 定义初始数据，universe和时间段
% universe = {'510500';'159901';'159919';'159902';'518880';'510500';'511010';'159915';'159905';'159903';'510900'}; % 定义Universe
universe = {'510880';'510500';'513500';'513100';'159901';'510160';'510900'}; % 定义Universe
% period = 22;
days = (1:30);
sDate = '2017-01-01';
eDate = '2017-08-26';
%% 连接数据库获取历史数据,保存为mat文件(nav_etf source)
% conn = database('data', 'root', '66196619', 'com.mysql.jdbc.Driver', 'jdbc:mysql://localhost:3306/data');
% 
% for i = 1:length(universe)
%     sqlStr = strcat('select symbol,date,cgrate from data.nav_etf where date BETWEEN ''',sDate,''' and ''',eDate ,''' and symbol =''', cellstr(universe{i}) , ''' order by date asc');
%     dbdata = fetch(conn, char(sqlStr));
%     savePath = char(strcat('C:\\Matlab\\Mathwork\\Program\\data\\',cellstr(universe{i}),'.mat'));
%     save(savePath,'dbdata');
% end
% clear i;
% close(conn);
%% 连接数据库获取历史数据,保存为mat文件 (his_etf source)
conn = database('data', 'root', '66196619', 'com.mysql.jdbc.Driver', 'jdbc:mysql://localhost:3306/data');

for i = 1:length(universe)
    sqlStr = strcat('select symbol,date,closeprice from data.his_etf where date BETWEEN ''',sDate,''' and ''',eDate ,''' and symbol =''', cellstr(universe{i}) , ''' order by date asc');
    dbdata = fetch(conn, char(sqlStr));
    for j = 1:length(dbdata)
        if j == 1
            dbdata(j,4) = num2cell(0);
        else
            dbdata(j,4) = num2cell(100*(dbdata{j,3} - dbdata{j-1,3})/dbdata{j-1,3});
        end
    end
    dbdata(:,3) = [];       
    savePath = char(strcat('C:\\Matlab\\Mathwork\\Program\\data\\',cellstr(universe{i}),'.mat'));
    save(savePath,'dbdata');
end
clear i j;
close(conn);
%% 读取和协整数据，对齐日期，处理空值与未交易日情况
for i=1:length(universe)
    files = char(strcat('C:\\Matlab\\Mathwork\\Program\\data\\',universe{i},'.mat'));
    load(files);
    eval(['price_',char(universe{i}),'= dbdata(:,2:3);']) ;% 读取mat数据中日期和closeprice，并自动命名变量
    clear dbdata;
end
clear i;
% Join所有symbol的日期，或者一个最完备的日期列表
% dateArray = cell(1,1);
dateArray = cell(2,1);dateArray{1,1} = sDate;dateArray{2,1} = eDate;
for j=1:length(universe)
    symbolId = strcat('price_',universe{j}); 
    eval(['dateList', '=', char(symbolId),'(:,1);']) ; 
%     dateArray = union(price_159901(:,1),dateList);
    dateArray = union(dateArray,dateList);
%     dateArray = sortrows(dateArray,1);
end
clear j dateList;

dataPrice = cell(length(dateArray),length(universe)); % 开辟存储空间
% dataPrice(:,1) = dateArray; % 日期填入第一列
for k = 1:length(universe)
    symbolId = strcat('price_',universe{k});
    eval(['dateList', '=', char(symbolId),'(:,1);']) ;
    [c,ia,ib] = intersect(dateList,dateArray,'stable'); 
    eval(['dataPrice(ib,k)', '=', char(symbolId),'(:,2);']); 
end
clear k;

dataPrice(cellfun(@isempty,dataPrice))= {0};

% 遍历数组找寻空值,以前一个交易日值填充
% for a = 2:n
%     for b = 1:m
%         if isempty(dataPrice{a,b}) == 1
% %             dataPrice{a,b} = dataPrice{a-1,b};
%             dataPrice{a,b} = 0;
%         end
%     end
% end

% 2015-4-15 日期截断
% [row col]=find(cellfun(@(x) strcmp(x,'2014-09-01'),dataPrice));
% dataPrice = dataPrice(row:end,:);

% 画一个初始价格走势图
% figure
% x = datenum((dataPrice(:,1)))';
% y = cell2mat(dataPrice(:,2:end)');
% title('价格走势图');xlabel('Date');ylabel('Price');
% plot(x,y);
% datetick('x','yyyy/mm/dd','keepticks'); 

% 画159901的价格走势图
% figure;
% x = datenum((dataPrice(:,1)))';
% y = cell2mat(dataPrice(:,2)');
% title('159901价格走势图');xlabel('Date');ylabel('Price');
% plot(x,y), grid on;
% datetick('x','yyyy/mm/dd','keepticks'); 

% figure;
% movavg(y,5,20,1); 
% grid on;
% ylabel('Price');
% legend('Close Price','Lagging Long','Leading Short');

% %% 计算收盘价收益情况
% samplePrice = sortrows(price_159901,1);
% samplePrice = samplePrice(18:end,1:5);
% closePrice = samplePrice (:,5);
% retData = cell2mat(closePrice); 
% ret = [0]; % 第一行return为0
% for r = 2:length(retData)
%     ret(r) = (retData(r) - retData(r-1))./retData(r-1); %计算每日return，并赋值
% end
% ret = ret';
% retData = [retData, ret];
% 
% ret2 =zeros(1,period);
% for s = period+1:length(retData)
%     ret2(1,s) = (retData(s) - retData(s-20))./retData(s-20); % 计算每20日return，并赋值
% end
% ret2 = ret2';
% retData = [retData, ret2];  
% 
% yPrice = cell2mat(closePrice');
% [lead, lag] = movavg(yPrice,5,20,1); % 计算均线值
% retData = [retData,lead,lag];

% %% ATR止损计算
% xDate = datenum((samplePrice(:,1)))';
% sPrice = cell2mat(samplePrice(:,2:5));
% 
% for t = 1:length(retData)
%     if t == 1
%         todayVib = sPrice(t,2)-sPrice(t,3);
%         twodaysVib = abs(sPrice(t,1)-sPrice(t,2));
%         towdaysVib2 = abs(sPrice(t,1)-sPrice(t,3));
%         rawATR(t) = max([todayVib,twodaysVib,towdaysVib2]);
% %         clear todayVib，twodaysVib，towdaysVib2；
%     elseif t > 1
%         todayVib = sPrice(t,2)-sPrice(t,3);
%         twodaysVib = abs(sPrice(t-1,4)-sPrice(t,2));
%         towdaysVib2 = abs(sPrice(t-1,4)-sPrice(t,3));
%         rawATR(t) = max([todayVib,twodaysVib,towdaysVib2]); % 计算每日rawATR，并赋值
% %         clear todayVib，twodaysVib，towdaysVib2；
%     end
% end
% rawATR = rawATR';
% retData = [retData,rawATR];
% 
% [rATR, rATR2] = movavg(rawATR,period,period+2,1); % ATR移动平均计算
% retData = [retData,rATR];

%% 策略计算
% 20天正负收益的持仓策略；
%http://api.money.126.net/data/feed/1000001?callback=ne1fb846bfd2958e

% 获取实时价格
% for i = 1:length(universe)
%     if strncmp(universe{1},'5',1) == 1
%         symbolReq = ['0',char(universe{i})];
%     else 
%         symbolReq = ['1',char(universe{i})];
%     end
%     reqStr = ['http://api.money.126.net/data/feed/',symbolReq];
%     dataWeb = urlread(reqStr)
% 
%     regStr1 = '(?<=percent":).*?(?=,)';
%     dataPercent = regexp(dataWeb,regStr1,'match')
%     regStr2 = '(?<=time": ").*?(?=",)';
%     dataTime = regexp(dataWeb,regStr2,'match')
% end


% 计算period期间首尾收益的正负状况，为正保存period累计收益，为负置为零
n = 0;
regressionResult = zeros(length(days)*3,4);
for period = days(1) : days(end)
    n = n + 1 ;
    dataTrend = 1 + cell2mat(dataPrice)/100;
    dataTrend = log(dataTrend);
    dataReturn = zeros(length(dataTrend)-period+1,length(universe));
    
    for i = period :length(dataTrend)
        for k = 1:length(universe)
            if sum(dataTrend(i+1-period:i,k)) > 0
                dataReturn(i+1-period,k) = sum(dataTrend(i+1-period:i,k)); % 求过去period期间收益情况
            else
                dataReturn(i+1-period,k) = 0;
            end
        end
    end
    clear i k dataTrend;
    
    % 排序，选取前三只为正收益标的，如果不够三只，置零
    dataOperation = zeros(length(dataReturn)-1,3*3);
    for i = 1 : length(dataReturn)-1
        %     dataOperation(i,1) = dateArray(i+period-1);
        for j = 1: 3
            if max(dataReturn(i,:)) == 0
                dataOperation(i,j:3) = 0; % 最大值为零，则不操作
                dataOperation(i,j+3:6) = 0; % 最大值为零则收益为零
            else
                [max_val,max_idx] = max(dataReturn(i,:)); % 获取行最大值坐标
                dataOperation(i,j) = str2double(universe{max_idx}); % 填入最大值交易代码
                dataOperation(i,j+3) = dataPrice{i+period,max_idx}; % +3列填入最大值第二日收益（每日收盘操作，获取第二天收益）
                dataReturn(i,max_idx) = 0; % 最大值置零，循环中获得第二第三最大值
            end
        end
    end
    clear dataReturn i j;
    
    % 止损策略： 当日（实际为持有第二日）跌幅超过-3%，卖出止损且第二日收益为零；
    for i = 1 : length(dataOperation)
        for j = 4:6
            if dataOperation(i,j) <= -3
                if i < length(dataOperation)
                    dataOperation(i,j) = -3;
                    dataOperation(i+1,j) = 0;
                else
                    dataOperation(i,j) = -3;
                end
            end
        end
    end
    
    
    % 最后三列，分别计算单指标，双指标和三指标的累积收益率
    for i = 1 : length(dataOperation)
        if i == 1
            dataOperation(i,7) = 1 + dataOperation(i,4)/100;
            dataOperation(i,8) = 1 + 0.5*dataOperation(i,4)/100 + 0.5* dataOperation(i,5)/100;
            dataOperation(i,9) = 1 + 0.334*dataOperation(i,4)/100+ 0.333* dataOperation(i,5)/100 + 0.333* dataOperation(i,6)/100;
        else
            dataOperation(i,7) = (1 + dataOperation(i,4)/100) * dataOperation(i-1,7);
            dataOperation(i,8) = (1 + 0.5*dataOperation(i,4)/100+ 0.5* dataOperation(i,5)/100) * dataOperation(i-1,8);
            dataOperation(i,9) = (1 + 0.334*dataOperation(i,4)/100+ 0.333* dataOperation(i,5)/100 + 0.333* dataOperation(i,6)/100) * dataOperation(i-1,9);
        end
    end
    
    % 计算累计收益率，最大回测和年化收益率
    dataResult = zeros(3,3);
    xDate = datenum(dateArray(period+1:end))';
    for i = 1: length(dataResult)
        dataResult(i,1) = (dataOperation(end,i+6)-1)*100;
        dataResult(i,2) = maxdrawdown(dataOperation(:,i+6))*100;
        dataResult(i,3) = 100*(dataOperation(end,i+6)^(365/(xDate(end)-xDate(1))) - 1);
    end
    dataResult = roundn(dataResult,-2);
   
	regressionResult(3*n-2:3*n,1) = period ;
	regressionResult(3*n-2:3*n,2:4) = dataResult;
    
end

regressionResult = sortrows(regressionResult,-2);
px = regressionResult(:,1);
py = regressionResult(:,4);
plot(py,px,'*');

% 画出三种策略的收益累计曲线图
% figure;
% plot(xDate,dataOperation(:,7:9));
% % xlabel('Date');
% datetick('x','dd/mm/yy','keepticks'); 
% ylabel('Cumulative Return');
% 
% maxOne = ['Max 1，总收益: ',num2str(dataResult(1,1)),'%，最大回撤: ',num2str(dataResult(1,2)),'%，年化收益: ',num2str(dataResult(1,3)),'%'];
% maxTwo = ['Max 2，总收益: ',num2str(dataResult(2,1)),'%，最大回撤: ',num2str(dataResult(2,2)),'%，年化收益: ',num2str(dataResult(2,3)),'%'];
% maxThree = ['Max 3，总收益: ',num2str(dataResult(3,1)),'%，最大回撤: ',num2str(dataResult(3,2)),'%，年化收益: ',num2str(dataResult(3,3)),'%'];
% legend(maxOne,maxTwo,maxThree,'Location','northoutside');
% grid on;
