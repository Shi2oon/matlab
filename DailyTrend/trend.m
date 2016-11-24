function results = trend(data,mday)

ret = data(mday+1:end,:)./data(1:end-mday,:) -1; % calculate 19 days margin return
dailyret = data(mday+3:end,:)./data(mday+2:end-1,:) -1; % calculate 1 days return
maxValue=[];
indexValue=[];
[maxValue,indexValue] = max(ret,[],2);    % get column number of max margin return in 19 days

for j = 1:length(maxValue)
    if maxValue(j)< 0
        indexValue(j) = 0;
    end
end
for i = 1:length(indexValue)-2
    if indexValue(i) == 0
        pfret(i) = 0;
    else
        pfret(i) = dailyret(i,indexValue(i));
    end
end
% use column number to fill porfoli return from daily return 

excessRet = pfret - 0.03/252; % calculate excess return
results.sharpRatio = sqrt(252)*mean(excessRet)/std(excessRet); % calcualte sharp ratio
results.cumret = cumprod(1+pfret)-1;  % calcuate cumulative return
results.cumret(end);                % show portfolio final cumulative return

plot(results.cumret);% figure cumulative return 

[results.maxDrawdown results.maxDrawdownDuration]=calculateMaxDD(results.cumret); % count the maxdown and maxdown days
results.maxDrawdown;
results.maxDrawdownDuration;
end
