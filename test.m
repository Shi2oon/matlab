% a =66.38;
% b=37.85;
% c=ols2(a,b);
% mean(a);
% std(a);
% c=zeros
% conn = database('data','root','66196619','com.mysql.jdbc.Driver','jdbc:mysql://localhost:3306/data');
% symbols = [518880,159905,510900,159901,159903,510500,511010,159902,159915];
% curs = exec(conn,
% curs = fetch(curs);
% data = curs.Data;

clear;clc;
% A=[0 17 50;-12 40 3;5 -10 2;30 4 3]
% [Y_row,Ind_col]=max(A') 
% [max_a,index]=max(A,[],2)

p=[0:0.01:1];
h=-1*(p.*log2(p)+(1-p).*log2(1-p));
plot(p,h); grid on;