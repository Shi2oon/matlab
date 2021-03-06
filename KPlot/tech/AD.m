function ADValue=AD(High,Low,Close,Volume)
%--------------------此函数用来计算AD指数(收集派发指标)--------------------
%----------------------------------编写者--------------------------------
%Lian Xiangbin(连长,785674410@qq.com),DUFE,2014
%----------------------------------参考----------------------------------
%[1]光大证券.技术指标系列(六)——chaikinAD六年年化收益71%，2012-05-15
%[2]交易开拓者.AD指标算法
%[3]同花顺.AD指标算法
%----------------------------------简介----------------------------------
%离散指标(A/D)——Accumulation/Distribution是由价格和成交量的变化
%而决定的。成交量在价格的变化中充当重要的权衡系数。系数越高(成交量)，
%价格的变化的分布就越能被这个技术指标所体现(在当前时段内)。实际上，
%这个指标是另外一个更为普遍使用的能量潮指标成交量的变体。这两个指
%标都用来通过衡量各自的成交量来确认价格的变化。以中间价为准，如果
%收盘价高于当日中间价，则当日成交量视为正值。收盘价越接近当日最高
%价，其多头力道越强。如果收盘价低于当日中间价，则当日成交量视为负
%值。收盘价越接近当日最低价，其空头力道越强。当离散指标增长时，就
%意味着积累(购买)了某一特定的证券，因为此时，占绝对份额的成交量与
%正在上升的价格趋势相关了。当该指标下降时，意味着分配(卖出)某一证
%券，此时在价格运动下降的同时，有更多的销售正在进行。 离散指标和证
%券价格之间的差异表明即将到来的价格变化。原则上，在这样的差异情况
%下，价格的趋势会向着该指标移动的方向顺时移动。
%----------------------------------基本用法------------------------------
%1)视AD指标为领先指标，AD上升则买入，AD下降则卖出(等价于收盘价高于中
%间价则买入，收盘价低于中间价则卖出)
%2)计算Chaikin＝AD的(m)日指数移动平均-AD的(n)日指数移动平均 
%  Chaikin指标由负值向上穿越0轴时，为买进信号 
%  Chaikin指标由正值向下穿越0轴时，为卖出信号
%更多用法，请查找相关文献
%----------------------------------调用函数------------------------------
%ADValue=AD(High,Low,Close,Volume)
%----------------------------------参数----------------------------------
%High-最高价序列
%Low-最低价序列
%Close-收盘价序列
%Volume-成交量序列
%----------------------------------输出----------------------------------
%ADValue-收集派发指标

ADValue=zeros(length(High),1);
Drift=(Close-Low)-(High-Close);%偏移量，即2C-(L+H)
Range=High-Low;%振幅
ADValue=cumsum((Drift./Range.*Volume));
end

