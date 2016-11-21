function EMAvalue = EMA(Price, len, coef)
% ָ���ƶ�ƽ���� ����
% Last Modified by LiYang 2014/5/1
% Email:faruto@163.com

%% ����������
error(nargchk(1, 3, nargin))
if nargin < 3
    coef = [];
end
if nargin< 2
    len = 2;
end
%% ָ��EMAϵ��
if isempty(coef)
    k = 2/(len + 1);
else
    k = coef;
end
%% ����EMAvalue
EMAvalue = zeros(length(Price), 1);
EMAvalue(1:len-1) = Price(1:len-1);

for i = len:length(Price)
    
    EMAvalue(i) = k*( Price(i)-EMAvalue(i-1) ) + EMAvalue(i-1);
    
end
