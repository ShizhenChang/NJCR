function [alpha] = NJCR(data, D, lambda, thr, maxIter)
%
%   Input: data = data matrix, feature dimensions-by-number of samples (L*N)
%          D = Dictionary
%          lambda = penalty scalar of the objective function;
%  Output: alpha = coeficient matrix

if (nargin < 5)
    %default maximum number of iterations of ADMM
    maxIter = 30;
end
if (nargin < 4)
    %default coefficient error threshold to stop ADMM
    %default threshold to stop ADMM
    thr = 10e-3;
end
if (nargin < 3)
    lambda = 1;
end

if (length(thr) == 1)
    thr1 = thr(1);
    thr2 = thr(1);
elseif (length(thr) == 2)
    thr1 = thr(1);
    thr2 = thr(2);
end

N = size(data, 2);
Num_Di=size(D,2);


% initialization
eta=zeros(N,1);
Delta=zeros(Num_Di,N);
omega=zeros(Num_Di,N);
one_N=ones(N,1);
one_K=ones(Num_Di,1);
rho=10e-3;
err1=10*thr1;
err2=10*thr2;


i=1;
%iterations
while((err1 >= thr || max(err2) >= thr) && i <= maxIter)
    alpha = inv(2 * D' * D + (lambda+rho) * eye(Num_Di) + rho * one_K * one_K') * (2 * D' * data - rho * (Delta-omega-one_K * one_N' + one_K * eta'));
    omega0 = omega;
    omega = max(alpha + Delta, 0);
    Delta = Delta + alpha - omega;
    eta = eta + alpha'*one_K - one_N;
    err1 = max(max( [alpha-omega; one_K'*alpha-one_N'] ));
    %err1 = norm([alpha-omega; one_K'*alpha-one_N'], 'fro');
    err2 = norm(-rho * (omega-omega0), 'fro');
    fprintf('The iteration time: %d, rho: %.4f, err1: %.4f, err2: %.4f \n', i, rho, err1, err2);
    i = i + 1;
end
