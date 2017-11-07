clear;
x = xlsread('data1.xls');
price = x(:,4)';
figure;
plot(price,'k','LineWidth',2);
xlabel('观测序号');
ylabel('沪市日收盘价');

% %盒子法平滑处理
% output1 =  smoothts(price,'b',30);
% output2 =  smoothts(price,'b',100);
% figure;
% plot(price,'.');
% hold on
% plot(output1,'k','LineWidth',2);
% plot(output2,'k-','LineWidth',2);
% xlabel('观测序号');ylabel('Box method');
% legend('原始散点','平滑曲线（窗宽30）','平滑曲线（窗宽100）','location','northwest');

% %高斯窗法平滑处理
% output3 =  smoothts(price,'g',30);
% output4 =  smoothts(price,'g',100,100);
% figure;
% plot(price,'.');
% hold on
% plot(output3,'k','LineWidth',2);
% plot(output4,'k-','LineWidth',2);
% xlabel('观测序号');ylabel('Gaussian window method');
% legend('原始散点','平滑曲线（窗宽30,标准差0.65）','平滑曲线（窗宽100，标准差100）','location','northwest');

%指数法平滑处理
output5 =  smoothts(price,'e',30);
output6 =  smoothts(price,'e',100);
figure;
plot(price,'.');
hold on
plot(output5,'-','LineWidth',2);
plot(output6,'--r','LineWidth',2);
xlabel('观测序号');ylabel('Exponential method');
legend('原始散点','平滑曲线（窗宽30）','平滑曲线（窗宽100）','location','northwest');