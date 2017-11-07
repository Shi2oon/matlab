clear;
clc;
close all;

% a = [1:3]
% b = a'
% c = rand(2,3)
% d = eye(4)
% e = zeros(3,2)
% f = ones(2,3)

A = [1,2,3;4,5,6]
B = ['abcde','fffee']
C = {'123',123;'abc','edf'} %元胞数组
whos A B
D = num2str(A)
whos A D
E = str2num(D)
F = num2cell(A)
whos E F

G = {'123','','dfg'}
H = cell2mat(G) %元胞转字符串，空的位置会被忽略
I = {'abc','1 3';'edd','fdd'}
L = cell2mat(I) %元胞转字符串，每行字符串长度必须一致

K = ['what';'edit';'play']
L = cellstr(K) %字符串转元胞

%%日期的格式
%日期有三种格式：双精度数字（从公元到今天的天数）；日期格式
%数值向量格式
datestr(736289) %数值转字符串
datenum([2015 11 21]) %数值向量转数字
datevec(736289) %数字转数值向量
%Excel 数值日期转Matlab DataNumber = x2mdate(ExcelDateNumber,Convention0

%%日期算术运算
n1 = datenum('14/11/2015','dd/mm/yyyy')
n2 = n1 + 3
n3 = datestr(n2,'dd/mm/yyyy')

%%数字还原为日期
d1 = datestr(n1,'yyyy/mm/dd')
d2 = datestr(n2,'mm/dd/yyyy')

%%日期格式转化
d = datestr(datenum('07/08/2013','dd/mm/yyyy'))

%%定义结构变量
FIELD1 = 'CODE'; %股票代码
VALUE1 = '000002';

FIELD2 = 'NAME';
VALUE2 = '万科A';

FIELD3 = 'DATE';
VALUE3 = {'2015/9/1';'2015/9/2';'2015/9/3'};

FIELD4 = 'CLOSE';
VALUE4 = [23;25;22];

FIELD5 = 'VOL';
VALUE5 = [203;206;220];

WKA = struct(FIELD1,VALUE1,FIELD2,VALUE2,FIELD3,VALUE3,FIELD4,VALUE4,FIELD5,VALUE5);

%%读取结构变量
WKA.NAME
WKA.DATE
WKA.VOL

%%Table数据类型
clear;clc;close all;
load patients

T1 = table(Age,Gender,Smoker);
T2 = table(Height,Weight);

T = [T1 T2];

T(1:5,:)

T.BloodPressure= [Diastolic Systolic]

T.Smoker = []; %删除一列

T.BMI = (T.Weight*0.453592)./(T.Height*0.0254);
T(1:5,:)
T(:,[3,4]) = []; %删除多列






