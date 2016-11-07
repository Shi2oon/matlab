function results = ols(y,x,alpha)
% PURPOSE: least-squares regression 
%---------------------------------------------------
% USAGE: results = ols(y,x)
% where: y = dependent variable vector    (nobs x 1)
%        x = independent variables matrix (nobs x nvar)
%        alpha - confidence level for t-stat (usually .05)
%---------------------------------------------------
% RETURNS: a structure
%        results.meth  = 'ols'
%        results.beta  = bhat     (nvar x 1)
%        results.tstat = t-stats  (nvar x 1)
%        results.pval  = p-value of t-stats
%        results.bstd  = std deviations for bhat (nvar x 1)
%        results.yhat  = yhat     (nobs x 1)
%        results.resid = residuals (nobs x 1)
%        results.sige  = e'*e/(n-k)   scalar
%        results.rsqr  = rsquared     scalar
%        results.rbar  = rbar-squared scalar
%        results.fregr = F-test for overal significance of regression
%        results.dw    = Durbin-Watson Statistic
%        results.nobs  = nobs
%        results.nvar  = nvars
%        results.y     = y data vector (nobs x 1)
%        results.bint  = (nvar x2 ) vector with 95% confidence intervals on beta
%        results.aic   = Akakike Information Criteria
%        results.sic   = Schwarz Information Criteria
%---------------------------------------------------
% SEE ALSO: prt(results), plt(results)
%---------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com
%
% Barry Dillon (CICG Equity)
% added the 95% confidence intervals on bhat
%
% modified by S. Radchenko

if (nargin ~= 3); error('Wrong # of arguments to ols'); 
else
 [nobs nvar] = size(x); [nobs2 junk] = size(y);
 if (nobs ~= nobs2); error('x and y must have same # obs in ols'); 
 end;
end;

results.meth = 'ols';
results.y = y;
results.nobs = nobs;
results.nvar = nvar;

if nobs < 10000
  [q r] = qr(x,0);
  xpxi = (r'*r)\eye(nvar);
else % use Cholesky for very large problems
  xpxi = (x'*x)\eye(nvar);
end;

results.beta    = xpxi*(x'*y);                      % estimates of beta
results.yhat    = x*results.beta;                   % fitted values of y
results.resid   = y - results.yhat;
sigu            = results.resid'*results.resid;     % sum of squared residuals
results.sige    = sigu/(nobs-nvar);                 % estimate of sigma
tmp             = (results.sige)*(diag(xpxi));                          % variance of estim. beta
sigb            = sqrt(tmp);
results.bstd    = sigb;
%tcrit           = -tdis_inv(.025,nobs);          % critical value
tcrit           = tinv(1-alpha/2, nobs-nvar);     % the critical value (mod. S. Radchenko)

results.bint    = [results.beta-tcrit.*sigb, results.beta+tcrit.*sigb]; % confidence intervals
results.tstat   = results.beta./(sqrt(tmp));
ym = y - mean(y);
rsqr1 = sigu;
rsqr2 = ym'*ym;
results.rsqr = 1.0 - rsqr1/rsqr2;           % r-squared
rsqr1 = rsqr1/(nobs-nvar);
rsqr2 = rsqr2/(nobs-1.0);
if rsqr2 ~= 0
results.rbar = 1 - (rsqr1/rsqr2);           % rbar-squared
else
    results.rbar = results.rsqr;
end;
ediff = results.resid(2:nobs) - results.resid(1:nobs-1);
results.dw = (ediff'*ediff)/sigu;           % durbin-watson

% ======== Added by S. Radchenko ============
results.tpval = 2*(1 - tcdf(abs(results.tstat), nobs-nvar));     %computation of p-value for t-statistics
results.freg  = (nobs-nvar)*results.rsqr/((nvar-1)*(1-results.rsqr)); % computation of test of overal significance
results.fpval = 1-fcdf(results.freg, nvar-1, nobs-nvar);

% ======== Information Criteria =============
results.aic = log(results.sige)+2*nvar/nobs;
results.sic = log(results.sige)+nvar*log(nobs)/nobs;
results.tpval
results.tstat
results.beta