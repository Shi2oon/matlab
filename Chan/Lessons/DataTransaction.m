clear; %�����ڴ�
clc;%������Ļ
close all; 
%format comnact;%����������ʾ��ʽΪ���ո�ʽ
%tic ��ʼ��ʱ�� toc ������ʱ

A = [10:0.01:12];%���������
prices = randsrc(100,1,A);%
dates = [today-99:today]';
TimeSeries = fints(dates,prices,'close')

%%��ȡfints��������
TimeSeries.dates
%��ȡ���ݣ�0��ʾֻ��ȡ���ݣ�1��ʾ��ȡ���ݺ�����
TimeSeries1 = fts2mat(TimeSeries,0,'close')
TimeSeries('06/06/17')%������ȡ
TimeSeries.close('06/06/17::06/15/17')%��ʱ�����ȡ
TimeSeries.close([1 3 95:end])%�������ȡ

%%����ʱ���������ڵ�ת��
TimeSeries2 = convertto(TimeSeries,'w')
%TimeSeries2 = convertto(TimeSeries,'m')
%ת��Ϊ�����ݣ� d - �죬w/m/q/s - ����/a - ��

%%�����ʺͼ۸����е�ת��
returns  = price2ret(TimeSeries1) %����������
NormPrices = ret2price(returns)%�������ʵõ��ı�׼���۸����۸�Ϊ1

%%�쳣���ݴ���
%Ѱ�ҿջ��߸���������λ�ã�����ֵΪ0
TimeSeries3= [NaN -10 NaN 12 -10]';
location1 = isnan(TimeSeries3)
TimeSeries3(location1) = 0 %NaNλ�ø�ֵΪ0
location2 = find(TimeSeries3 <0)
TimeSeries3(location2)= 0

%%���ʲ��������ڵĶ�Ӧ
load WKEA
load HLSW
A = WKEA.DATE(2996:end);
B = HLSW.DATE;
C = union(A,B);
n1 = length(C);
data1 = cell(n1,3);%���ٴ洢�ռ�
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
%���Բ�ֵ������������ cubic - ���β�ֵ��spline - ������ֵ
%nearst - �����, pchip - ��ι⻬������Hemite����ʽ��
figure
subplot(2,1,1)

%%����Table��������
Name = {'stock1';'stock2';'stock3';'stock4';'stock5'};
open = [38;43;38;40;49];
yclose = [71;69;64;67;64];
tprice = [176;163;131;133;119];
T = table(open,yclose,tprice,'RowNames',Name)
%%��ȡTable����
T.open %��ȡ������
T{3,:} %��ȡ��3������
T.Properties.RowNames %��ȡ��Ʊ���ƣ���ͷ��s
T.Properties.VariableNames %��ȡ�������ƣ���ͷ��

%%����DataSet��������
%DataSet���ݽṹΪStatistics�����䶨������ͣ���Ҫ�����У�
%cat(����);cellstr;datasetfun;disp;sisplay;double;end;
%get;grpstats;horzcat;isempty;join;length;ndims;numel
%set;single;size;sortrows;stack;subsref;summary;unique;vertcat
date1 = {'2014/1/1','2014/1/3','2014/1/5'}';
date2 = {'2014/1/2','2014/1/3','2014/1/5'}';
price1 = [2 3 5]';
price2 = [3 4 2]';
y = cell(1,2);%���ٴ洢�ռ�
y{1,1} = dataset(date1,price1,'VarNames',{'date','close'});
y{1,2} = dataset(date2,price2,'VarNames',{'date','close'});

%%DataSet�������͵Ķ�ȡ
a = y{1,1}; %����Ϊ�ṹ����
a1 = a(:,1) %��1�У�����
a2 = a(:,2) 
a3 = a.date %Ԫ�����飬
a4 = a.close

%%Join�����ϲ�����
a = y
