%% ������
clear;
clc;
close all;

%% �����ʼ���ݣ�universe��ʱ���
% universe = {'510500';'159901';'159919';'159902';'518880';'510500';'511010';'159915';'159905';'159903';'510900'}; % ����Universe
universe = {'510880';'510500';'513500';'513100';'159901';'510160';'510900'}; % ����Universe
% period = 22;
days = (1:30);
sDate = '2017-01-01';
eDate = '2017-08-26';
%% �������ݿ��ȡ��ʷ����,����Ϊmat�ļ�(nav_etf source)
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
%% �������ݿ��ȡ��ʷ����,����Ϊmat�ļ� (his_etf source)
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
%% ��ȡ��Э�����ݣ��������ڣ������ֵ��δ���������
for i=1:length(universe)
    files = char(strcat('C:\\Matlab\\Mathwork\\Program\\data\\',universe{i},'.mat'));
    load(files);
    eval(['price_',char(universe{i}),'= dbdata(:,2:3);']) ;% ��ȡmat���������ں�closeprice�����Զ���������
    clear dbdata;
end
clear i;
% Join����symbol�����ڣ�����һ�����걸�������б�
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

dataPrice = cell(length(dateArray),length(universe)); % ���ٴ洢�ռ�
% dataPrice(:,1) = dateArray; % ���������һ��
for k = 1:length(universe)
    symbolId = strcat('price_',universe{k});
    eval(['dateList', '=', char(symbolId),'(:,1);']) ;
    [c,ia,ib] = intersect(dateList,dateArray,'stable'); 
    eval(['dataPrice(ib,k)', '=', char(symbolId),'(:,2);']); 
end
clear k;

dataPrice(cellfun(@isempty,dataPrice))= {0};

% ����������Ѱ��ֵ,��ǰһ��������ֵ���
% for a = 2:n
%     for b = 1:m
%         if isempty(dataPrice{a,b}) == 1
% %             dataPrice{a,b} = dataPrice{a-1,b};
%             dataPrice{a,b} = 0;
%         end
%     end
% end

% 2015-4-15 ���ڽض�
% [row col]=find(cellfun(@(x) strcmp(x,'2014-09-01'),dataPrice));
% dataPrice = dataPrice(row:end,:);

% ��һ����ʼ�۸�����ͼ
% figure
% x = datenum((dataPrice(:,1)))';
% y = cell2mat(dataPrice(:,2:end)');
% title('�۸�����ͼ');xlabel('Date');ylabel('Price');
% plot(x,y);
% datetick('x','yyyy/mm/dd','keepticks'); 

% ��159901�ļ۸�����ͼ
% figure;
% x = datenum((dataPrice(:,1)))';
% y = cell2mat(dataPrice(:,2)');
% title('159901�۸�����ͼ');xlabel('Date');ylabel('Price');
% plot(x,y), grid on;
% datetick('x','yyyy/mm/dd','keepticks'); 

% figure;
% movavg(y,5,20,1); 
% grid on;
% ylabel('Price');
% legend('Close Price','Lagging Long','Leading Short');

% %% �������̼��������
% samplePrice = sortrows(price_159901,1);
% samplePrice = samplePrice(18:end,1:5);
% closePrice = samplePrice (:,5);
% retData = cell2mat(closePrice); 
% ret = [0]; % ��һ��returnΪ0
% for r = 2:length(retData)
%     ret(r) = (retData(r) - retData(r-1))./retData(r-1); %����ÿ��return������ֵ
% end
% ret = ret';
% retData = [retData, ret];
% 
% ret2 =zeros(1,period);
% for s = period+1:length(retData)
%     ret2(1,s) = (retData(s) - retData(s-20))./retData(s-20); % ����ÿ20��return������ֵ
% end
% ret2 = ret2';
% retData = [retData, ret2];  
% 
% yPrice = cell2mat(closePrice');
% [lead, lag] = movavg(yPrice,5,20,1); % �������ֵ
% retData = [retData,lead,lag];

% %% ATRֹ�����
% xDate = datenum((samplePrice(:,1)))';
% sPrice = cell2mat(samplePrice(:,2:5));
% 
% for t = 1:length(retData)
%     if t == 1
%         todayVib = sPrice(t,2)-sPrice(t,3);
%         twodaysVib = abs(sPrice(t,1)-sPrice(t,2));
%         towdaysVib2 = abs(sPrice(t,1)-sPrice(t,3));
%         rawATR(t) = max([todayVib,twodaysVib,towdaysVib2]);
% %         clear todayVib��twodaysVib��towdaysVib2��
%     elseif t > 1
%         todayVib = sPrice(t,2)-sPrice(t,3);
%         twodaysVib = abs(sPrice(t-1,4)-sPrice(t,2));
%         towdaysVib2 = abs(sPrice(t-1,4)-sPrice(t,3));
%         rawATR(t) = max([todayVib,twodaysVib,towdaysVib2]); % ����ÿ��rawATR������ֵ
% %         clear todayVib��twodaysVib��towdaysVib2��
%     end
% end
% rawATR = rawATR';
% retData = [retData,rawATR];
% 
% [rATR, rATR2] = movavg(rawATR,period,period+2,1); % ATR�ƶ�ƽ������
% retData = [retData,rATR];

%% ���Լ���
% 20����������ĳֲֲ��ԣ�
%http://api.money.126.net/data/feed/1000001?callback=ne1fb846bfd2958e

% ��ȡʵʱ�۸�
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


% ����period�ڼ���β���������״����Ϊ������period�ۼ����棬Ϊ����Ϊ��
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
                dataReturn(i+1-period,k) = sum(dataTrend(i+1-period:i,k)); % ���ȥperiod�ڼ��������
            else
                dataReturn(i+1-period,k) = 0;
            end
        end
    end
    clear i k dataTrend;
    
    % ����ѡȡǰ��ֻΪ�������ģ����������ֻ������
    dataOperation = zeros(length(dataReturn)-1,3*3);
    for i = 1 : length(dataReturn)-1
        %     dataOperation(i,1) = dateArray(i+period-1);
        for j = 1: 3
            if max(dataReturn(i,:)) == 0
                dataOperation(i,j:3) = 0; % ���ֵΪ�㣬�򲻲���
                dataOperation(i,j+3:6) = 0; % ���ֵΪ��������Ϊ��
            else
                [max_val,max_idx] = max(dataReturn(i,:)); % ��ȡ�����ֵ����
                dataOperation(i,j) = str2double(universe{max_idx}); % �������ֵ���״���
                dataOperation(i,j+3) = dataPrice{i+period,max_idx}; % +3���������ֵ�ڶ������棨ÿ�����̲�������ȡ�ڶ������棩
                dataReturn(i,max_idx) = 0; % ���ֵ���㣬ѭ���л�õڶ��������ֵ
            end
        end
    end
    clear dataReturn i j;
    
    % ֹ����ԣ� ���գ�ʵ��Ϊ���еڶ��գ���������-3%������ֹ���ҵڶ�������Ϊ�㣻
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
    
    
    % ������У��ֱ���㵥ָ�꣬˫ָ�����ָ����ۻ�������
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
    
    % �����ۼ������ʣ����ز���껯������
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

% �������ֲ��Ե������ۼ�����ͼ
% figure;
% plot(xDate,dataOperation(:,7:9));
% % xlabel('Date');
% datetick('x','dd/mm/yy','keepticks'); 
% ylabel('Cumulative Return');
% 
% maxOne = ['Max 1��������: ',num2str(dataResult(1,1)),'%�����س�: ',num2str(dataResult(1,2)),'%���껯����: ',num2str(dataResult(1,3)),'%'];
% maxTwo = ['Max 2��������: ',num2str(dataResult(2,1)),'%�����س�: ',num2str(dataResult(2,2)),'%���껯����: ',num2str(dataResult(2,3)),'%'];
% maxThree = ['Max 3��������: ',num2str(dataResult(3,1)),'%�����س�: ',num2str(dataResult(3,2)),'%���껯����: ',num2str(dataResult(3,3)),'%'];
% legend(maxOne,maxTwo,maxThree,'Location','northoutside');
% grid on;
