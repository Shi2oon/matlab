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
C = {'123',123;'abc','edf'} %Ԫ������
whos A B
D = num2str(A)
whos A D
E = str2num(D)
F = num2cell(A)
whos E F

G = {'123','','dfg'}
H = cell2mat(G) %Ԫ��ת�ַ������յ�λ�ûᱻ����
I = {'abc','1 3';'edd','fdd'}
L = cell2mat(I) %Ԫ��ת�ַ�����ÿ���ַ������ȱ���һ��

K = ['what';'edit';'play']
L = cellstr(K) %�ַ���תԪ��

%%���ڵĸ�ʽ
%���������ָ�ʽ��˫�������֣��ӹ�Ԫ������������������ڸ�ʽ
%��ֵ������ʽ
datestr(736289) %��ֵת�ַ���
datenum([2015 11 21]) %��ֵ����ת����
datevec(736289) %����ת��ֵ����
%Excel ��ֵ����תMatlab DataNumber = x2mdate(ExcelDateNumber,Convention0

%%������������
n1 = datenum('14/11/2015','dd/mm/yyyy')
n2 = n1 + 3
n3 = datestr(n2,'dd/mm/yyyy')

%%���ֻ�ԭΪ����
d1 = datestr(n1,'yyyy/mm/dd')
d2 = datestr(n2,'mm/dd/yyyy')

%%���ڸ�ʽת��
d = datestr(datenum('07/08/2013','dd/mm/yyyy'))

%%����ṹ����
FIELD1 = 'CODE'; %��Ʊ����
VALUE1 = '000002';

FIELD2 = 'NAME';
VALUE2 = '���A';

FIELD3 = 'DATE';
VALUE3 = {'2015/9/1';'2015/9/2';'2015/9/3'};

FIELD4 = 'CLOSE';
VALUE4 = [23;25;22];

FIELD5 = 'VOL';
VALUE5 = [203;206;220];

WKA = struct(FIELD1,VALUE1,FIELD2,VALUE2,FIELD3,VALUE3,FIELD4,VALUE4,FIELD5,VALUE5);

%%��ȡ�ṹ����
WKA.NAME
WKA.DATE
WKA.VOL

%%Table��������
clear;clc;close all;
load patients

T1 = table(Age,Gender,Smoker);
T2 = table(Height,Weight);

T = [T1 T2];

T(1:5,:)

T.BloodPressure= [Diastolic Systolic]

T.Smoker = []; %ɾ��һ��

T.BMI = (T.Weight*0.453592)./(T.Height*0.0254);
T(1:5,:)
T(:,[3,4]) = []; %ɾ������






