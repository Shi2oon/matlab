%% 清理工作
clear;
clc;
close all;

%% 读取399001_t.xls历史数据
% 导入数据, date,high,low,open,close
[~, ~, tData] = xlsread('C:\Matlab\Mathwork\Program\002456_t.xls','Sheet1','A2:E1143');
tData(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),tData)) = {''};
pData = cell2mat(tData(:,2:5));
%% 画蜡烛图
% % period=20;
% centPoint = 0.5*(0.618*(pData(:,3) + pData(:,4)) + 0.382*(pData(:,1)+ pData(:,2)));
% [mv5, mv20] = movavg(pData(:,4),5,20,1);
% 
% candle(pData(21:end,1),pData(21:end,2),pData(21:end,4),pData(21:end,3)) ;
% hold on
% plot([mv5(21:end),mv20(21:end)],'LineWidth',1);
% hold on
% 
% % subplot([mv5(21:end),mv20(21:end)],'LineWidth',1);;
% 
% % len=length(pData);
% % pData2=pData;pData3=pData;
% % rise=find(pData(:,4)>pData(:,3))
% % pData2(rise,:)=0; 
% % down=find(pData(:,4)<pData(:,3));
% % pData3(down,:)=0;
% % candle(pData2(:,1),pData2(:,2),pData2(:,4),pData2(:,3),'b');
% % hold on
% % candle(pData3(:,1),pData3(:,2),pData3(:,4),pData3(:,3),'r');
% % hold on
%% 威廉指标策略探索,100%减去W%R，故波峰为超买应卖空，波谷为超卖应买入
n = (1:15); hl = (51:99);ll = (18:48);
% n = (2:2); hl=(71:71);ll=(38:38);
varGroup = zeros(length(n)*length(hl)*length(ll),3);
vG = 1;
for i = 1:length(n)
    for j = 1:length(hl)        
        for k = 1:length(ll)            
            varGroup (vG,1) = n(i);
            varGroup (vG,2) = hl(j);
            varGroup (vG,3) = ll(k);
            vG = vG + 1;
        end
    end
end

tic

retResult = zeros(length(varGroup),9);

for w = 1 : length(varGroup)
    wrN= varGroup(w,1);
    wrHL= varGroup(w,2);
    wrLL= varGroup(w,3);


    for i= 1:length(pData)
        if i <= wrN
            wrHn = max (pData(1:i,1));
            wrLn = min (pData(1:i,2));
            wrData(i) = 100 * (1 - (wrHn - pData(i,4))/(wrHn - wrLn));
        else
            wrHn = max (pData(i-wrN:i,1));
            wrLn = min (pData(i-wrN:i,2));
            wrData(i) = 100 * (1 - (wrHn - pData(i,4))/(wrHn - wrLn));
        end
    end
    % 计算操作
    wrOperation = zeros(length(wrData),1); % 预分配内存
    % 第一天的操作
    if wrData(1) >= wrHL
        wrOperation(1) = -1;
    elseif wrData(1) <= wrLL
        wrOperation(1) = 1;
    else
        wrOperation(1) = 0;
    end
    %后续日期的操作
    for i = 2: length(wrData)
        if wrData(i) >= wrHL && wrOperation(i-1) <= 0 % W%R值高于等于抛售线，且前一天状态为-1/0，即卖出或空仓，则继续为空仓状态
            wrOperation(i) = 0;
        elseif wrData(i) >= wrHL && wrOperation(i-1) > 0 % W%R值高于等于抛售线，且前一天状态为1/2，即买入或持有，则当日状态为卖出
            wrOperation(i) = -1;
        elseif wrData(i) <= wrLL && wrOperation(i-1) <= 0 % W%R值低于等于买入线，且前一天状态为-1/0，即卖出或空仓，则当日状态为买入
            wrOperation(i) = 1;
        elseif wrData(i) <= wrLL && wrOperation(i-1) > 0 % W%R值低于等于买入线，且前一天状态为1/2，即买入或持有，则当日状态为持有
            wrOperation(i) = 2;
        elseif wrData(i) < wrHL && wrData(i) > wrLL && wrOperation(i-1) <= 0 % W%R值位于买卖入线之间，且前一天状态为-1/0，即卖出或空仓，则当日状态为空仓
            wrOperation(i) = 0;
        elseif wrData(i) < wrHL && wrData(i) > wrLL && wrOperation(i-1) > 0 % W%R值位于买卖入线之间，且前一天状态为1/2，即买入或持有，则当日状态为持有
            wrOperation(i) = 2  ;
        end
    end
    
    % 计算累计收益，年化收益，最大回测，夏普ratio，以及收益曲线等
    retData = zeros(length(wrOperation),5); % 预留空间
    xDate = tData(:,1); % 获取交易日期
    retData(:,1) = pData(:,4); % 第一列赋值closeprice
    retData(:,2) = wrOperation; % 第二列赋值操作代码
    retData(1,3) = 0;retData(1,4) = 0; retData(1,5) = 1; % 初始化第一行
    for j =2: length(retData)
        retData(j,3) = (retData(j,1)-retData(j-1,1))/retData(j-1,1); % 计算第三列每日收益
        % 根据第二列操作代码，获取实际收益和累计收益，分别赋值到第四列
        if retData(j,2) == -1 || retData(j,2) == 2 % 持仓或者买出，获得当日的收益
            retData(j,4) = retData(j,3);
            retData(j,5) = retData(j-1,5)*(1+retData(j,4)); % 计算累计收益
        else % 买入或者空仓，收益为零
            retData(j,4) = 0;
            retData(j,5) = retData(j-1,5); % 累计收益等同前一个交易日
        end
    end
    
    years = (datenum(xDate(end))  - datenum(xDate(1)))/365; % 投资周期，以年为单位
    annualRet = retData(end,end)^(1/years) - 1; % 年化收益
    basicRet = (1 + (retData(end,1) - retData(1,1))/retData(1,1))^(1/years) - 1 ; % 单纯持有收益
    sharpRatio = (annualRet - 0.03) / std(retData(:,3)); % 夏普收益
    infoRatio = (annualRet - basicRet) / std(retData(:,3)); % 与单持有收益比较的信息收益
    maxDD = maxdrawdown(retData(:,1)); % 最大回撤

    retResult(w,1) = wrN;  
    retResult(w,2) = wrHL;
    retResult(w,3) = wrLL;
    retResult(w,4) = retData(end,end); % 总收益
    retResult(w,5) = annualRet;
    retResult(w,6) = basicRet;
    retResult(w,7) = sharpRatio;
    retResult(w,8) = infoRatio;
    retResult(w,9) = maxDD;
%     plot([pData(:,:),retData(:,5)*100,wrData'*4]);
%     hold on
%     plot(wrOperation*200)
end
retResult = sortrows(retResult,-4);

toc

% retResult 