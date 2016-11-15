function [L,B,Wc,sigma2,J]= ols(L,X,Y,B,Wc)
%OLS Ordinary least squares (with weights)

%  Copyright 2000-2005 The MathWorks, Inc. and Ford Global Technologies, Inc.


if nargin<5
    Wc=[];
end

DATA= [X,Y];


% need to initialise parameter estimates
if ~isempty(Wc)
    [res,J,yhat]= gls_costB(B,L,DATA);
    for i=1:size(Y,3)
        if isempty(Wc{i}) && ~isempty(L.covmodel)
            % have to calculate weights
            Wc{i}= choltinv(L.covmodel,yhat{i},X{i});
        end
    end
end

% fit with current weights
[B,yhat,res,J] = gls_fitB(L,B,DATA,Wc);

df = (size(Y,1)- size(Y,3)*size(L,1));
Cost = sqrt(sum(double(res).^2)/df);
sigma2 = Cost.^2;

str = sprintf('    %9s %9s %9s %9s','sigma','norm(B)','norm(C)','cparam');
DisplayFit(L, str);
DisplayFit(L, @() i_CreateDisplayString(Cost, B, L.covmodel));



function str = i_CreateDisplayString(Cost, B, cm)
str = ['OLS:', ...
    sprintf('%9.5g ', Cost,  i_SafeNorm(B), i_SafeNorm(double(cm)), double(cm))];


%--------------------------------------------------------------------------
function n = i_SafeNorm( x )
% NORM protected against INF and NAN
%
% If x constrain Inf or NaN than norm x errors with "NaN or Inf prevents
% convergence". As we know how to respond to these cases, we look from them
% and return an appropriate value.

if any( isnan( x(:) ) ),
    % If there are NANs then the norm must also be NAN
    n = NaN;
elseif any( isinf( x(:) ) ),
    % If there are no NANs but there are INFs then any sensible norm should
    % return INF.
    n = Inf;
else
    % if no NAN and no INF, we should safely be able to call NORM
    n = norm( x );
end
