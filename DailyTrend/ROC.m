function ROCValue=ROC(Price,Length)
%----------------------此函数用来计算ROC指标(变动速率)---------------------
%----------------------------------编写者--------------------------------
%Lian Xiangbin(连长,785674410@qq.com),DUFE,2014
%----------------------------------参考----------------------------------
%[1]姜金胜.指标精萃：经典技术指标精解与妙用.东华大学出版社,2004年01月第1版
%[2]交易开拓者(TB).公式应用ROC的算法
%----------------------------------简介----------------------------------
%ROC(Rate of Change)指标又叫变动速率指标，是一种重点研究价格变动动力大小的中
%短期技术分析工具。ROC指标是Gerald Apple和Fred Hitschler在《Stock Market 
%Trading System》一书中最先提出的，它结合了RSI、WMS、KDJ和CCI等指标的特点，
%同时检测价格的常态性和极端性两种走势，从而比较准确地把握买卖时机。ROC指标是
%利用物理学上的加速度原理，以当前周期的收盘价和N周期前的收盘价做比较，通过计算
%价格在某一段时间内收盘价变动的速率，应用价格的波动来测量价格移动的动量，衡量
%多空双方买卖力量的强弱，达到分析预测价格的趋势及是否有转势意愿的目的。
%----------------------------------基本用法------------------------------
%1)当ROC线从下往上突破0线时，表明价格的变动动力由下跌动力转为上升动力，多方
%力量开始强于空方力量，价格将进入强势区域，是较强的买入信号
%2)当ROC线从上向下跌破0线时，表明价格的变动动力由上涨动力转为下跌动力，空方
%力量开始强于多方力量，价格将进入弱势区域，是较强的卖出信号
%该指标和MTM的原理很相似，更多用法查看参考
%----------------------------------调用函数------------------------------
%ROCValue=ROC(Price,Length)
%----------------------------------参数----------------------------------
%Price-价格序列，常用收盘价序列
%Length-计算ROC所考虑的周期，常用12
%----------------------------------输出----------------------------------
%ROCValue-变动速率

ROCValue=zeros(length(Price),1);
ROCValue(Length+1:end)=(Price(Length+1:end)-Price(1:end-Length))./...
    Price(1:end-Length)*100;
end