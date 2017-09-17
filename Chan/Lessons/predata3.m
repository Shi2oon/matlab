clear;
%һά��ֵ�˲�
% y = medfilt1(x,n)
% y = medfilt1(x,n,blksz)
% y = medfilt1(x,n,blksz,dim)

t = linspace(0,2*pi,500)';
y =  100*sin(t);
noise = normrnd(0,15,500,1);%������������ֵ0����׼��15��500����ֵ
y = y + noise;
figure;
plot(t,y);
xlabel('t')
ylabel('y = sin(t) + ����');

yy=medfilt1(y,20);
figure;
plot(t,y,'k:');
hold on;
plot(t,yy,'k','linewidth',3);
xlable('t');
ylable('��ֵ�˲�');
legend('���벨��','ƽ������')