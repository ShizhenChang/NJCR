clear;
%addpath '/Users/ehsanelhamifar/Documents/MatlabCode/SSC_motion_face/';
load('data/Sandiego.mat');
p = size(Sandiego);
gt = reshape(Sandiego_gt, p(1)*p(2), 1);
X = reshape(Sandiego, p(1)*p(2), p(3));
X = hyperNormalize(X); 
Num_Sup = 100;
Num_i = 5;
[Db, Da] = const_dic(X, p, Num_Sup, Num_i);
D =[Db; Da]';

%%
%demo for NJCR
lambda = 100;
[alpha] = NJCR(X', D, lambda);

% detection result
alpha_b=alpha(1:size(Db,1),:);
r=sqrt(sum((X - alpha_b' * Db).^2,2));
x = roc_i(r',gt',58);

%%
%demo for KNJCR
lambda = 100;
sigma = 4;
[kalpha] = KNJCR(X', D, sigma, lambda);
%detection result
K_DbDb = Kernel_function(Db', Db', sigma);
K_DaDa = Kernel_function(Da', Da', sigma);
K_XDb = Kernel_function(X', Db', sigma);
K_XX = Kernel_function(X', X', sigma);
K_XX = diag(K_XX);
kalpha_b = kalpha(1:size(Db,1), :);
kalpha_a = kalpha(size(Db,2)+1:size(alpha,1), :);
r = sqrt(K_XX'-2*sum(K_XDb'.*kalpha_b,1)+sum((kalpha_b'*K_DbDb)'.*kalpha_b, 1));%+sqrt(sum((alpha_a'*K_DaDa)'.*alpha_a,1));
% for i = 1: size(X,1)
%     r(i, 1) = sqrt(K_XX(i) + kalpha_b(:, i)' * K_DbDb * kalpha_b(:,i) - 2 * kalpha_b(:, i)' * K_XDb(i,:)');
% end
x = roc_i(r,gt',58);
