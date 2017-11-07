clear; %清理内存
clc;%清理屏幕
close all; 
%format comnact;%定义数据显示样式为紧凑格式
%tic 开始计时， toc 结束记时

A = [10:0.01:12];%生成随机数
prices = randsrc(100,1,A);%
dates = [today-99:today]';
TimeSeries = fints(dates,prices,'close')

%%读取fints数据类型
TimeSeries.dates
%提取数据，0表示只提取数据，1表示提取数据和日期
TimeSeries1 = fts2mat(TimeSeries,0,'close')
TimeSeries('06/06/17')%按天提取
TimeSeries.close('06/06/17::06/15/17')%按时间段提取
TimeSeries.close([1 3 95:end])%按标号提取

%%金融时间序列周期的转化
TimeSeries2 = convertto(TimeSeries,'w')
%TimeSeries2 = convertto(TimeSeries,'m')
%转化为周数据， d - 天，w/m/q/s - 半年/a - 年

%%收益率和价格序列的转化
returns  = price2ret(TimeSeries1) %对数收益率
NormPrices = ret2price(returns)%由收益率得到的标准化价格，起点价格为1

%%异常数据处理
%寻找空或者负数的数据位置，并赋值为0
TimeSeries3= [NaN -10 NaN 12 -10]';
location1 = isnan(TimeSeries3)
TimeSeries3(location1) = 0 %NaN位置赋值为0
location2 = find(TimeSeries3 <0)
TimeSeries3(location2)= 0

%%多资产交易日期的对应
load WKEA
load HLSW
A = WKEA.DATE(2996:end);
B = HLSW.DATE;
C = union(A,B);
n1 = length(C);
data1 = cell(n1,3);%开辟存储空间
data1(:1) = C;
[c,ia,ib] = intersect(A,C);
data1(ib,2) = num2cell(WKEA.CLOSE(2996:end));
[c,ia,ib] = intersect(B,C);
data1(ib,3) = num2cell(HLSW.CLOSE);
xlswrite('data1.xlsx',data1)

location = cellfun(@(x)isempty(x),data1(:3));
data2 = data1(:,3);
data2(location) =[NaN];
HLSW1 = fints(C,cell2mat(data2));

TimeSeries4 = fillts(HLSW1,'linear');
%线性插值法，其他还有 cubic - 三次插值，spline - 样条插值
%nearst - 最近法, pchip - 逐段光滑的三次Hemite多项式法
figure
subplot(2,1,1)

%%定义Table数据类型
Name = {'stock1';'stock2';'stock3';'stock4';'stock5'};
open = [38;43;38;40;49];
yclose = [71;69;64;67;64];
tprice = [176;163;131;133;119];
T = table(open,yclose,tprice,'RowNames',Name)
%%读取Table数据
T.open %读取列数据
T{3,:} %读取第3行数据
T.Properties.RowNames %读取股票名称，表头列s
T.Properties.VariableNames %读取变量名称，表头行

%%定义DataSet数据类型
%DataSet数据结构为Statistics工具箱定义的类型，主要函数有：
%cat(连接);cellstr;datasetfun;disp;sisplay;double;end;
%get;grpstats;horzcat;isempty;join;length;ndims;numel
%set;single;size;sortrows;stack;subsref;summary;unique;vertcat
date1 = {'2014/1/1','2014/1/3','2014/1/5'}';
date2 = {'2014/1/2','2014/1/3','2014/1/5'}';
price1 = [2 3 5]';
price2 = [3 4 2]';
y = cell(1,2);%开辟存储空间
y{1,1} = dataset(date1,price1,'VarNames',{'date','close'});
y{1,2} = dataset(date2,price2,'VarNames',{'date','close'});

%%DataSet数据类型的读取
a = y{1,1}; %本质为结构变量
a1 = a(:,1) %第1列，日期
a2 = a(:,2) 
a3 = a.date %元胞数组，
a4 = a.close

%%Join函数合并数据
a = y
