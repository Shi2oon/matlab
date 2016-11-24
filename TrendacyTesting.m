% select ifnull(a.clnav,'NaN'),ifnull(b.clnav,'NaN'),ifnull(c.clnav,'NaN'),ifnull(r.clnav,'NaN') from (
% select date, clnav from data.nav_etf 
% where symbol='159915'  and date > '2013-12-04' ) a 
% left join (select date, clnav from data.nav_etf 
% where symbol='513100'  and date > '2013-12-04') b on a.date=b.date
% left join (select date, clnav from data.nav_etf 
% where symbol='513500'  and date > '2013-12-04') c on a.date=c.date
% left join (select date, clnav from data.nav_etf 
% where symbol='510500'  and date > '2013-12-04') r on a.date=r.date
% order by a.date asc 

% 159915	创业板
% 513100	纳斯达克100
% 510500	500ETF
% 513500	标普500

clear;clc;
data = csvread('trend.csv'); % read data
data = CopyPre(data);         % clean 'Nan', copy them from pre-day
mday = 19;                    % set mday as 19 days


ret = data(mday+1:end,:)./data(1:end-mday,:) -1; % calculate 19 days margin return
dailyret = data(mday+3:end,:)./data(mday+2:end-1,:) -1; % calculate 1 days return
[max,index]=max(ret,[],2);   % get column number of max margin return in 19 days

for j = 1:length(max)
    if max(j)< 0
        index(j) = 0;
    end
end

for i = 1:length(index)-2
    if index(i) == 0
        pfret(i) = 0;
    else
        pfret(i) = dailyret(i,index(i));
    end
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