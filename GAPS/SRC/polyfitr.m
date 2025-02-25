function p = polyfitr(x,y,n)

% if size(x,2)>size(x,1)
%     x=x';
%     y=y';
% end
% 
% for isamp = size(x,1):-1:1
%     for ideg = n+1:-1:1
%         A(isamp,ideg) = x(isamp)^(n+1-(ideg));
%     end
% end
% 
% p = (A'*A)\(A'*y);
% p=p';
% return;

%POLYFIT Fit polynomial to data.
%   P = POLYFIT(X,Y,N) finds the coefficients of a polynomial P(X) of
%   degree N that fits the data Y best in a least-squares sense. P is a
%   row vector of length N+1 containing the polynomial coefficients in
%   descending powers, P(1)*X^N + P(2)*X^(N-1) +...+ P(N)*X + P(N+1).
%
%   [P,S] = POLYFIT(X,Y,N) returns the polynomial coefficients P and a
%   structure S for use with POLYVAL to obtain error estimates for
%   predictions.  S contains fields for the triangular factor (R) from a QR
%   decomposition of the Vandermonde matrix of X, the degrees of freedom
%   (df), and the norm of the residuals (normr).  If the data Y are random,
%   an estimate of the covariance matrix of P is (Rinv*Rinv')*normr^2/df,
%   where Rinv is the inverse of R.
%
%   [P,S,MU] = POLYFIT(X,Y,N) finds the coefficients of a polynomial in
%   XHAT = (X-MU(1))/MU(2) where MU(1) = MEAN(X) and MU(2) = STD(X). This
%   centering and scaling transformation improves the numerical properties
%   of both the polynomial and the fitting algorithm.
%
%   Warning messages result if N is >= length(X), if X has repeated, or
%   nearly repeated, points, or if X might need centering and scaling.
%
%   Class support for inputs X,Y:
%      float: double, single
%
%   See also POLY, POLYVAL, ROOTS.

%   Copyright 1984-2004 The MathWorks, Inc.
%   $Revision: 5.17.4.5 $  $Date: 2004/07/05 17:01:37 $

% The regression problem is formulated in matrix format as:
%
%    y = V*p    or
%
%          3  2
%    y = [x  x  x  1] [p3
%                      p2
%                      p1
%                      p0]
%
% where the vector p contains the coefficients to be found.  For a
% 7th order polynomial, matrix V would be:
%
% V = [x.^7 x.^6 x.^5 x.^4 x.^3 x.^2 x ones(size(x))];

if ~isequal(size(x),size(y))
    error('MATLAB:polyfit:XYSizeMismatch',...
          'X and Y vectors must be the same size.')
end

x = x(:);
y = y(:);

if nargout > 2
   mu = [mean(x); std(x)];
   x = (x - mu(1))/mu(2);
end

% Construct Vandermonde matrix.
V(:,n+1) = ones(length(x),1,class(x));
for j = n:-1:1
   V(:,j) = x.*V(:,j+1);
end
ws = warning('off','all'); 

% Solve least squares problem.
[Q,R] = qr(V,0);
p = R\(Q'*y);    % Same as p = V\y;
p = p.';          % Polynomial coefficients are row vectors by convention.
return;


%warning(ws);

%r = y - V*p;
%
% S is a structure containing three elements: the triangular factor from a
% QR decomposition of the Vandermonde matrix, the degrees of freedom and
% the norm of the residuals.
%S.R = R;
%S.df = length(y) - (n+1);
%S.normr = norm(r);
