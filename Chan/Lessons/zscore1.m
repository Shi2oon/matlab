%zscore���� ��׼���任
%�ڣ�zscore(X)
% [Z,mu��ֵ,sigma��׼��] = szcore(X)
%[...] = zscore(X,1)
%[...] = zscore(X,flag,dim)

clear;
x = [rand(10,1),5*rand(10,1),10*rand(10,1),500*rand(10,1)]
[xz,mu,sigma] = zscore(x)
mean(xz)
std(xz)

%�����һ���任 0~1�仯

rscore