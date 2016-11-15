function data = CopyPre(data)

% PURPOSE: replace all NaN with pre-data 
%---------------------------------------------------
% USAGE: results = CopyPre(data,target)
% where: data = data which need to be replaced with pre-data
%---------------------------------------------------
% written by:
% Guo Jun
% guouoo@163.com

[i,j] = find(isnan(data));

if length(i) ~= 0
    for a =1:length(i)
        data(i(a),j(a)) = data(i(a)-1,j(a));
    end
end