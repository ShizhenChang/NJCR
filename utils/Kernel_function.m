function [K] = Kernel_function(X1,X2,sigma)
%KERNEL_FUNCTION Summary of this function goes here
%   Input: X1, X2 = data matrix, feature dimensions-by-number of samples (L*N)
%          sigma = kernel width
%   Detailed explanation goes here

n1 = size(X1,2);
n2 = size(X2,2);

K = zeros(n1,n2);

for i = 1:n1
    for j = 1:n2
        K(i,j) = exp(-(norm(X1(:,i)-X2(:,j))^2)/sigma);
    end
end


end

