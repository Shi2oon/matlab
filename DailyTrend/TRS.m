clear; clc;
conn = database('data','root','66196619','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/data');
curs = exec(conn,'select symbol, date, open, high,low, close,volume from data.his_stk_qfq where symbol ="002456" and date between "2014-06-01" and "2016-11-11" order by date asc');
curs = fetch(curs);
data = curs.Data;


scrsz = get(0,'ScreenSize');
figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);

% load IF-20120104.mat;
F = data(360:end, :);

MAline = cell2mat(F(:,6));

subplot(14,1,[1 7]);

S = 5;
L = 20;
[SMA, LMA] = movavg(MAline, S, L);
SMA(1:S-1) = NaN;
LMA(1:L-1) = NaN;
EMAvalue = EMA(MAline, S);
AMAvalue = AMA(MAline, S);


OHLC = cell2mat(F(:,3:6));

Kplot(OHLC,0,'r','b','k');
xlim([1,length( OHLC )]);

hold on;
H1 = plot(SMA,'g','LineWidth',1.5);
H2 = plot(EMAvalue,'k','LineWidth',1.5);
H3 = plot(AMAvalue,'r','LineWidth',1.5);
H4 = plot(LMA,'b','LineWidth',1.5);
% title('常见技术指标SMA(简单移动平均线)Matlab实现Demo', 'FontWeight','Bold', 'FontSize', 15);
M = {'SMA5';'EMA5'; 'AMA5'; 'MA20'};
legend([H1,H2,H3,H4],M);

    % % Tick Label Set

%     set(gca,'XTick', XTick);
%     set(gca,'XTickLabel', XTickLabel);
%     TickLabelRotate(gca, 'x', 30, 'right');

title('K线图Matlab实现', 'FontWeight','Bold', 'FontSize', 15);

subplot(14,1,[8 8]);
bar( cell2mat(F(:,7)));
xlim([1,length( OHLC )]);
% title('成交量', 'FontWeight','Bold', 'FontSize', 15);

%     set(gca,'XTick', XTick);
%     set(gca,'XTickLabel', XTickLabel);
%     TickLabelRotate(gca, 'x', 30, 'right');


% load IF-20120104.mat;

subplot(14,1,[9 10]);

SC = 12;
LC = 26;
EMA1 = EMA(MAline, SC);
EMA2 = EMA(MAline, LC);

DIFF = EMA1-EMA2;

DIFF(1:LC-1) = 0;

M = 10;
DEA = EMA(DIFF, M);
MACD = 2*(DIFF-DEA);

MACD_p = MACD;
MACD_n = MACD;
MACD_p(MACD_p<0) = 0;
MACD_n(MACD_n>0) = 0;
bar(MACD_p,'r','EdgeColor','r');
hold on;
bar(MACD_n,'b','EdgeColor','b');
plot(DIFF,'k','LineWidth',1.5);

plot(DEA,'g','LineWidth',1.5);

xlim([1,length( OHLC )]);

subplot(14,1,[11 12]);

SD = 5;
LD = 20;
[MA1, MA2] = movavg(MAline, SD, LD);
MA1(1:SD-1) = NaN;
MA2(1:LD-1) = NaN;
DMA = MA1-MA2;
M = 5;
MDMA = movavg(DMA, M, M);
MDMA(1:M-1) = NaN;

hold on;
plot(DMA,'k','LineWidth',1.5);
plot(MDMA,'r--','LineWidth',1.5);
% title('常见技术指标DMA(平均线差指标)Matlab实现Demo', 'FontWeight','Bold', 'FontSize', 15);
legend('DMA','MDMA');
xlim([1,length( OHLC )]);

subplot(14,1,[13 14]);

N = 2;
ema = EMA(MAline, N);
M = 20;
TR = EMA( EMA(ema,N) , N);
TRIX = ( TR(2:end)-TR(1:end-1) )./TR(1:end-1)*100;
TRIX = [NaN; TRIX];
MATRIX = movavg(TRIX, M, M);

hold on;
plot(TRIX,'k','LineWidth',1.5);
plot(MATRIX,'r','LineWidth',1.5);
% title('常见技术指标TRIX(三重指数平滑移动平均指标)Matlab实现Demo', 'FontWeight','Bold', 'FontSize', 15);
legend('TRIX','MATRIX');
xlim([1,length( OHLC )]);
%     set(gca,'XTick', XTick);
%     set(gca,'XTickLabel', XTickLabel);
%     TickLabelRotate(gca, 'x', 30, 'right');
  