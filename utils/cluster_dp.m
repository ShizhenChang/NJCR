function [cluster_lables, center_idxs] = cluster_dp(dist, para, k)

%% Input and Output
% INPUT :
% dist : A nCases*nCases matrix. each dist(i, j) represents the distance
%        between the i-th datapoint and j-th datapoint.
% para : options
%        percent : The parameter to determine dc. 1.0 to 2.0 can often yield good performance.
%        method  : alternative ways to compute density. 'gaussian' or
%                  'cut_off'. 'gaussian' often yields better performance.
% OUTPUT :
% cluster_labels : a nCases vector contains the cluster labls. Lable equals to 0 means it's in the halo region
% center_idxs    : a nCluster vector contains the center indexes.

%% Estimate dc
% disp('Estimating dc...');
percent = para.percent;
N = size(dist,1);
position = round(N*(N-1)*percent/100);
tri_u = triu(dist,1);
sda = sort(tri_u(tri_u~=0));
dc = sda(position);
clear sda; clear tri_u;

%% Compute rho(density)
% fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);
switch para.method
    % Gaussian kernel
    case 'gaussian'
        rho = sum(exp(-(dist./dc).^2),2)-1;
        % "Cut off" kernel
    case 'cut_off'
        rho = sum((dist-dc)<0, 2);
end
[~,ordrho]=sort(rho,'descend');

%% Compute delta
% disp('Computing delta...');
delta = zeros(size(rho));
nneigh = zeros(size(rho));

delta(ordrho(1)) = -1;
nneigh(ordrho(1)) = 0;
for i = 2:N
    range = ordrho(1:i-1);
    [delta(ordrho(i)), tmp_idx] = min(dist(ordrho(i),range));
    nneigh(ordrho(i)) = range(tmp_idx); 
end
delta(ordrho(1)) = max(delta(:));

%% Decision graph, choose min rho and min delta
% figure(10000);
% plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
% title ('Decision Graph','FontSize',15.0)
% xlabel ('\rho')
% ylabel ('\delta')

%%
[index,position]=sort(delta,'descend');
delta_min=index(k+1)+10e-10;
rho_min=min(rho(position(1:k)))-10e-10;
bad_idx = find(rho <rho_min);
% rect = getrect(10000); % get user decision
% rho_min=rect(1);
% delta_min=rect(2);
% close all;
% bad_idx = find(rho < rho_min);

%% Find cluster centers
% disp('Finding cluster centers...');
center_idxs = (find(delta>delta_min));
% delete centers whose rho is samller than rho_min
for i = 1:length(center_idxs)
    if ~isempty(find(center_idxs(i)==bad_idx, 1))
        center_idxs(i) = -1;
    end
end
center_idxs(center_idxs==-1) = [];
% disp([num2str(length(center_idxs)),' cluster centers found...']);
%% Assignment
% raw assignment
% disp('Assigning data-points into clusters...');
cluster_lables = -1*ones(size(dist,1),1);
for i = 1:length(center_idxs)
    cluster_lables(center_idxs(i)) = i;
end
for i=1:length(cluster_lables)
    if (cluster_lables(ordrho(i))==-1)
        cluster_lables(ordrho(i)) = cluster_lables(nneigh(ordrho(i)));
    end
end
raw_cluster_lables = cluster_lables;

% find and cut off halo region
% disp('Cut off halo regions...');
for i = 1:length(center_idxs)
    tmp_idx = find(raw_cluster_lables==i);
    tmp_dist = dist(tmp_idx,:);
    tmp_dist(:,tmp_idx) = max(dist(:));
    tmp_rho = rho(tmp_idx);
    tmp_lables = raw_cluster_lables(tmp_idx);
    tmp_border = find(sum(tmp_dist<dc,2)>0);
    if ~isempty(tmp_border)
        rho_b = max(tmp_rho(tmp_border));
        halo_idx = rho(tmp_idx) < rho_b;
        tmp_lables(halo_idx) = 0;
        % lable equals to 0 means it's in the halo region
        cluster_lables(tmp_idx) = tmp_lables;
    end
end

end