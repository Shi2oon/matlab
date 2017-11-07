clear;
%一维中值滤波
% y = medfilt1(x,n)
% y = medfilt1(x,n,blksz)
% y = medfilt1(x,n,blksz,dim)

t = linspace(0,2*pi,500)';
y =  100*sin(t);
noise = normrnd(0,15,500,1);%噪声产生，均值0，标准差15，500个数值
y = y + noise;
figure;
plot(t,y);
xlabel('t')
ylabel('y = sin(t) + 噪声');

yy=medfilt1(y,20);
figure;
plot(t,y,'k:');
hold on;
plot(t,yy,'k','linewidth',3);
xlable('t');
ylable('中值滤波');
legend('加噪波形','平滑后波形')