clear;
[num,txt]=xlsread('IGE.csv');
[num2,txt2]=xlsread('SPY.csv');

tday=txt(2:end,1);
tday=datestr(datenum(tday,'yyyy/mm/dd'),'yyyymmdd');
tday=str2double(cellstr(tday));

tday2=txt2(2:end,1);
tday2=datestr(datenum(tday2,'yyyy/mm/dd'),'yyyymmdd');
tday2=str2double(cellstr(tday2));

cls=num(:,end);
cls2=num2(:,end);

[tday sortIndex] = sort(tday,'ascend');
cls = cls(sortIndex);
[tday2 sortIndex] = sort(tday2,'ascend');
cls2 = cls2(sortIndex);

dailyret=(cls(2:end)-cls(1:end-1))./cls(1:end-1);
dailyret2=(cls2(2:end)-cls2(1:end-1))./cls2(1:end-1);

netRet = (dailyret-dailyret2)/2
excessRet = dailyret - 0.04/252;

sharpRatio = sqrt(252)*mean(excessRet)/std(excessRet);
sharpRatio2 = sqrt(252)*mean(netRet)/std(netRet);

sharpRatio
sharpRatio2

cumret = cumprod(1+netRet)-1;
plot(cumret);
[maxDrawdown maxDrawdownDuration]=calculateMaxDD(cumret);
maxDrawdown
maxDrawdownDuration
