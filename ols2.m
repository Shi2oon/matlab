function [estimator,s2] = OLS(Y,X)

[nobs,nreg] = size(X);
estimator = (X' * X) \ (X' * Y);
resid = Y - X * estimator;
RSS = resid' * resid;
%SE_square = RSS / (nobs-nreg-1);
s2 = RSS / nobs;