% select ifnull(a.clnav,'NaN'),ifnull(b.clnav,'NaN'),ifnull(c.clnav,'NaN'),ifnull(d.clnav,'NaN')from ( 
% select date, clnav from data.nav_etf 
% where symbol='159915'  and date > '2013-07-30' ) a 
% left join (select date, clnav from data.nav_etf 
% where symbol='159905'  and date > '2013-07-30') b on a.date=b.date
% left join (select date, clnav from data.nav_etf 
% where symbol='510500'  and date > '2013-07-30') c on a.date=c.date
% left join (select date, clnav from data.nav_etf 
% where symbol='513500'  and date > '2013-07-30') d on a.date=d.date
% order by a.date asc

% 159905	深红利
% 159915	创业板
% ----159919	300ETF
% 510500	500ETF
% ----511010	国债ETF
% 513500	标普500

clear;clc;
data = csvread('trend.csv'); % read data
data = CopyPre(data);         % clean 'Nan', copy them from pre-day
mday = 20;                    % set mday as 20 days

ret = data(mday+1:end,:)./data(1:end-mday,:) -1; % calculate 20 days margin return
dailyret = data(mday+3:end,:)./data(mday+2:end-1,:) -1; % calculate 1 days return
[max,index]=max(ret,[],2);    % get column number of max margin return in 20 days
for i = 1:length(index)-2
    pfret(i)=dailyret(i,index(i));
end
% use column number to fill porfoli return from daily return 

excessRet = pfret - 0.03/252; % calculate excess return
sharpRatio = sqrt(252)*mean(excessRet)/std(excessRet) % calcualte sharp ratio
cumret = cumprod(1+pfret)-1;  % calcuate cumulative return
cumret(end)                     % show portfolio final cumulative return

plot(cumret);                   % figure cumulative return 
[maxDrawdown maxDrawdownDuration]=calculateMaxDD(cumret); % count the maxdown and maxdown days
maxDrawdown
maxDrawdownDuration