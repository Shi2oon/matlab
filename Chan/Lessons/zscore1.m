%zscore函数 标准化变换
%Ｚ＝zscore(X)
% [Z,mu均值,sigma标准差] = szcore(X)
%[...] = zscore(X,1)
%[...] = zscore(X,flag,dim)

clear;
x = [rand(10,1),5*rand(10,1),10*rand(10,1),500*rand(10,1)]
[xz,mu,sigma] = zscore(x)
mean(xz)
std(xz)

%极差归一化变换 0~1变化

rscore