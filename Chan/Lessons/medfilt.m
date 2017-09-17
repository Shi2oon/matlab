clear;
x = xlsread('data1.xls');
price = x(:,4)';
figure;
plot(price,'k','LineWidth',2);
xlabel('�۲����');
ylabel('���������̼�');

% %���ӷ�ƽ������
% output1 =  smoothts(price,'b',30);
% output2 =  smoothts(price,'b',100);
% figure;
% plot(price,'.');
% hold on
% plot(output1,'k','LineWidth',2);
% plot(output2,'k-','LineWidth',2);
% xlabel('�۲����');ylabel('Box method');
% legend('ԭʼɢ��','ƽ�����ߣ�����30��','ƽ�����ߣ�����100��','location','northwest');

% %��˹����ƽ������
% output3 =  smoothts(price,'g',30);
% output4 =  smoothts(price,'g',100,100);
% figure;
% plot(price,'.');
% hold on
% plot(output3,'k','LineWidth',2);
% plot(output4,'k-','LineWidth',2);
% xlabel('�۲����');ylabel('Gaussian window method');
% legend('ԭʼɢ��','ƽ�����ߣ�����30,��׼��0.65��','ƽ�����ߣ�����100����׼��100��','location','northwest');

%ָ����ƽ������
output5 =  smoothts(price,'e',30);
output6 =  smoothts(price,'e',100);
figure;
plot(price,'.');
hold on
plot(output5,'-','LineWidth',2);
plot(output6,'--r','LineWidth',2);
xlabel('�۲����');ylabel('Exponential method');
legend('ԭʼɢ��','ƽ�����ߣ�����30��','ƽ�����ߣ�����100��','location','northwest');