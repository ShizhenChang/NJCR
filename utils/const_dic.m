function [D, Da] = const_dic(X, p, nbSegments, Num_Di)
%const_dic Construct the background and anomaly subdictionaries of the
%dataset
%   Input: X = data matrix, number of samples-by-feature dimensions (N*L)
%          p = size of original data; [h,w,L]
%          nbSegments = number of segmentation desired; default=100
%          Num_Di = number of pixels extracted from each superpixel;
%          default=5
%  Output: D = background subdictionary
%          Da = anomaly subdictionary

if (nargin < 3)
    Num_Di = 5;
end
if (nargin < 2)
    nbSegments = 100;
end

RX_pred = Global_RX(X);
[~,num] = sort(RX_pred,'descend');
Da = X(num(1:50), :);%Highest 50 pixels after RX is utilized as anomaly subdictionary

X0 = bsxfun(@minus, X, mean(X));%Normalized data
CovarianceX = X0' * X0/ (p(1) * p(2));
[U, ~, ~] = svd(CovarianceX);
PC = X0 * U(:,1);%Extract the 1st PC of the data
I = reshape(PC, p(1), p(2));
[SegLabel, ~, ~, ~, ~, ~] = NcutImage(I, nbSegments);
%[SegLabel,NcutDiscrete,NcutEigenvectors,NcutEigenvalues,W,imageEdges]= NcutImage(I,nbSegments);
%figure(1);clf
%bw = edge(SegLabel,0.01);
%J1=showmask(I,imdilate(bw,ones(2,2)));
%imagesc(J1);axis off

for i = 1: nbSegments
    Label_i = find(SegLabel == i);
    X_i = X(Label_i, :);
    %if size of superpixel < or = Num_Di
    if(length(Label_i) < Num_Di)
        D(Num_Di*(i-1)+1:Num_Di*i, :) = 0;
        continue;
    end
    if(length(Label_i) == Num_Di)
         D_i = X_i;
         D(Num_Di*(i-1)+1:Num_Di*i, :) = D_i;
        continue;
    end
    %else, calculate the density peak and extract Num_Di center pixels
    Pdist = pdist2(X_i, X_i);
    para.method = 'gaussian';
    para.percent = 2.0;
    [~, center_idxs] = cluster_dp(Pdist, para, Num_Di);
    D_i = X_i(center_idxs, :);
    D(Num_Di*(i-1)+1: Num_Di*i, :) = D_i;
end
D(all(D == 0,2), :) = []; %Excludes all-zero columns