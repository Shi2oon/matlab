%% ��չ����ռ䡢�����
clc;clear;
close all;
format compact;

%% ����������� : 
data = csvread('data.csv');
data = CopyPre(data); 
standard = repmat(data (1,:),length(data),1);
data = data./standard;
% data = data(:,1:8);

mday =19;
fid=fopen('sharpratio4.txt','a+');
n = size(data,2);
for j = 1:n
    a = combnk(1:n,j);
    for i = 1:size(a,1)
        result = trend(data(:,[a(i,:)]),mday);
        fprintf(fid,'%f, ',result.sharpRatio);
        fprintf(fid,'%f, ',result.cumret(end));
        fprintf(fid,'%f, ',result.maxDrawdown);
        fprintf(fid,'%d,',result.maxDrawdownDuration);
        fprintf(fid,'%s \r\n',num2str(a(i,:)));
    end
end
fclose(fid);

% ShortLen = 5;
% LongLen = 10;
% [MA5, MA20] = movavg(IFdata, ShortLen, LongLen);
% MA5(1:ShortLen-1) = IFdata(1:ShortLen-1);
% MA20(1:LongLen-1) = IFdata(1:LongLen-1);
% 
% scrsz = get(0,'ScreenSize');
% figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
% plot(IFdata,'b','LineStyle','-','LineWidth',1.5);
% hold on;
% plot(MA5,'r','LineStyle','--','LineWidth',1.5);
% plot(MA20,'k','LineStyle','-.','LineWidth',1.5);
% grid on;
% legend('159915','MA5','MA20','Location','Best');
% title('���ײ��Իز����','FontWeight', 'Bold');
% hold on;
% %% ���׹��̷���
% 
% % ��λ Pos = 1 ��ͷ1��; Pos = 0 �ղ�; Pos = -1 ��ͷһ��
% Pos = zeros(length(IFdata),1);
% % ��ʼ�ʽ�
% InitialE = 5e4;
% % �������¼
% ReturnD = zeros(length(IFdata),1);
% % ��ָ����
% scale = 1;
% 
% for t = LongLen:length(IFdata)
%     
%     % �����ź� : 5�վ����ϴ�20�վ���
%     SignalBuy = MA5(t)>MA5(t-1) && MA5(t)>MA20(t) && MA5(t-1)>MA20(t-1) && MA5(t-2)<=MA20(t-2);
%     % �����ź� : 5�վ�������20�վ���
%     SignalSell = MA5(t)<MA5(t-1) && MA5(t)<MA20(t) && MA5(t-1)<MA20(t-1) && MA5(t-2)>=MA20(t-2);
%     
%     % ��������
%     if SignalBuy == 1
%         % �ղֿ���ͷ1��
%         if Pos(t-1) == 0
%             Pos(t) = 1;
%             text(t,IFdata(t),' \leftarrow��������','FontSize',8);
%             plot(t,IFdata(t),'ro','markersize',8);
%             continue;
%         end
%         % ƽ��ͷ����ͷ1��
% %         if Pos(t-1) == -1
% %             Pos(t) = 1;
% %             ReturnD(t) = (IFdata(t-1)-IFdata(t))*scale;
% %             text(t,IFdata(t),' \leftarrowƽ�տ���1��','FontSize',8);
% %             plot(t,IFdata(t),'ro','markersize',8);           
% %             continue;
% %         end
%     end
%     
%     % ��������
%     if SignalSell == 1
%         % �ղֿ���ͷ1��
%         if Pos(t-1) == 0
% %             Pos(t) = -1;
% %             text(t,IFdata(t),' \leftarrow����1��','FontSize',8);
% %             plot(t,IFdata(t),'rd','markersize',8);
%             continue;
%         end
%         % ƽ��ͷ����ͷ1��
%         if Pos(t-1) == 1
%             Pos(t) = 0;
%             ReturnD(t) = IFdata(t)/IFdata(t-1)-1;
%             text(t,IFdata(t),' \leftarrowƽ�����','FontSize',8);
%             plot(t,IFdata(t),'rd','markersize',8);
%             continue;
%         end
%     end
%     
%     % ÿ��ӯ������
%     if Pos(t-1) == 1
%         Pos(t) = 1;
%         ReturnD(t) = IFdata(t)/IFdata(t-1)-1;
%     end
% %     if Pos(t-1) == -1
% %         Pos(t) = -1;
% %         ReturnD(t) = (IFdata(t-1)-IFdata(t))*scale;
% %     end
%     if Pos(t-1) == 0
%         Pos(t) = 0;
%         ReturnD(t) = 0;
%     end    
%     
%     % ���һ��������������гֲ֣�����ƽ��
%     if t == length(IFdata) && Pos(t-1) ~= 0
%         if Pos(t-1) == 1
%             Pos(t) = 0;
%             ReturnD(t) = IFdata(t)/IFdata(t-1)-1;
%             text(t,IFdata(t),' \leftarrowƽ�����','FontSize',8);
%             plot(t,IFdata(t),'rd','markersize',8);
%         end
% %         if Pos(t-1) == -1
% %             Pos(t) = 0;
% %             ReturnD(t) = (IFdata(t-1)-IFdata(t))*scale;
% %             text(t,IFdata(t),' \leftarrowƽ��1��','FontSize',8);
% %             plot(t,IFdata(t),'ro','markersize',8);
% %         end
%     end
%     
% end
% %% �ۼ�����
% ReturnCum = cumprod(ReturnD+1)-1;
% ReturnCum = (ReturnCum +1)* InitialE;
% %% �������س�
% MaxDrawD = zeros(length(IFdata),1);
% for t = LongLen:length(IFdata)
%     C = max( ReturnCum(1:t) );
%     if C == ReturnCum(t)
%         MaxDrawD(t) = 0;
%     else
%         MaxDrawD(t) = (ReturnCum(t)-C)/C;
%     end
% end
% MaxDrawD = abs(MaxDrawD);
% %% ͼ��չʾ
% scrsz = get(0,'ScreenSize');
% figure('Position',[scrsz(3)*1/4 scrsz(4)*1/6 scrsz(3)*4/5 scrsz(4)]*3/4);
% subplot(3,1,1);
% plot(ReturnCum);
% grid on;
% axis tight;
% title('��������','FontWeight', 'Bold');
% 
% subplot(3,1,2);
% plot(Pos,'LineWidth',1.8);
% grid on;
% axis tight;
% title('��λ','FontWeight', 'Bold');
% 
% subplot(3,1,3);
% plot(MaxDrawD);
% grid on;
% axis tight;
% title(['���س�����ʼ�ʽ�',num2str(InitialE/1e4),'��'],'FontWeight', 'Bold');
