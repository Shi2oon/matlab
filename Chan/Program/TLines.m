%% ������
clear;
clc;
close all;

%% ��ȡ399001_t.xls��ʷ����
% ��������, date,high,low,open,close
[~, ~, tData] = xlsread('C:\Matlab\Mathwork\Program\002456_t.xls','Sheet1','A2:E1143');
tData(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),tData)) = {''};
pData = cell2mat(tData(:,2:5));
%% ������ͼ
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
%% ����ָ�����̽��,100%��ȥW%R���ʲ���Ϊ����Ӧ���գ�����Ϊ����Ӧ����
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
    % �������
    wrOperation = zeros(length(wrData),1); % Ԥ�����ڴ�
    % ��һ��Ĳ���
    if wrData(1) >= wrHL
        wrOperation(1) = -1;
    elseif wrData(1) <= wrLL
        wrOperation(1) = 1;
    else
        wrOperation(1) = 0;
    end
    %�������ڵĲ���
    for i = 2: length(wrData)
        if wrData(i) >= wrHL && wrOperation(i-1) <= 0 % W%Rֵ���ڵ��������ߣ���ǰһ��״̬Ϊ-1/0����������ղ֣������Ϊ�ղ�״̬
            wrOperation(i) = 0;
        elseif wrData(i) >= wrHL && wrOperation(i-1) > 0 % W%Rֵ���ڵ��������ߣ���ǰһ��״̬Ϊ1/2�����������У�����״̬Ϊ����
            wrOperation(i) = -1;
        elseif wrData(i) <= wrLL && wrOperation(i-1) <= 0 % W%Rֵ���ڵ��������ߣ���ǰһ��״̬Ϊ-1/0����������ղ֣�����״̬Ϊ����
            wrOperation(i) = 1;
        elseif wrData(i) <= wrLL && wrOperation(i-1) > 0 % W%Rֵ���ڵ��������ߣ���ǰһ��״̬Ϊ1/2�����������У�����״̬Ϊ����
            wrOperation(i) = 2;
        elseif wrData(i) < wrHL && wrData(i) > wrLL && wrOperation(i-1) <= 0 % W%Rֵλ����������֮�䣬��ǰһ��״̬Ϊ-1/0����������ղ֣�����״̬Ϊ�ղ�
            wrOperation(i) = 0;
        elseif wrData(i) < wrHL && wrData(i) > wrLL && wrOperation(i-1) > 0 % W%Rֵλ����������֮�䣬��ǰһ��״̬Ϊ1/2�����������У�����״̬Ϊ����
            wrOperation(i) = 2  ;
        end
    end
    
    % �����ۼ����棬�껯���棬���ز⣬����ratio���Լ��������ߵ�
    retData = zeros(length(wrOperation),5); % Ԥ���ռ�
    xDate = tData(:,1); % ��ȡ��������
    retData(:,1) = pData(:,4); % ��һ�и�ֵcloseprice
    retData(:,2) = wrOperation; % �ڶ��и�ֵ��������
    retData(1,3) = 0;retData(1,4) = 0; retData(1,5) = 1; % ��ʼ����һ��
    for j =2: length(retData)
        retData(j,3) = (retData(j,1)-retData(j-1,1))/retData(j-1,1); % ���������ÿ������
        % ���ݵڶ��в������룬��ȡʵ��������ۼ����棬�ֱ�ֵ��������
        if retData(j,2) == -1 || retData(j,2) == 2 % �ֲֻ����������õ��յ�����
            retData(j,4) = retData(j,3);
            retData(j,5) = retData(j-1,5)*(1+retData(j,4)); % �����ۼ�����
        else % ������߿ղ֣�����Ϊ��
            retData(j,4) = 0;
            retData(j,5) = retData(j-1,5); % �ۼ������ͬǰһ��������
        end
    end
    
    years = (datenum(xDate(end))  - datenum(xDate(1)))/365; % Ͷ�����ڣ�����Ϊ��λ
    annualRet = retData(end,end)^(1/years) - 1; % �껯����
    basicRet = (1 + (retData(end,1) - retData(1,1))/retData(1,1))^(1/years) - 1 ; % ������������
    sharpRatio = (annualRet - 0.03) / std(retData(:,3)); % ��������
    infoRatio = (annualRet - basicRet) / std(retData(:,3)); % �뵥��������Ƚϵ���Ϣ����
    maxDD = maxdrawdown(retData(:,1)); % ���س�

    retResult(w,1) = wrN;  
    retResult(w,2) = wrHL;
    retResult(w,3) = wrLL;
    retResult(w,4) = retData(end,end); % ������
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