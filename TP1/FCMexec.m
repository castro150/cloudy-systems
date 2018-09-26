clear all;
close all;
clc;

% carregando e plotando os dados
load fcm_dataset.mat;
X = x;

m = 2;
n = size(X,1);
d = size(X,2);

if d==2
    figure(1);
    hold on;
    plot(X(:,1), X(:,2),'b.');
    grid on;
end;

%------------------------------------------------------------------------
% Algoritmo K-Means

% define o numero de grupos e a tolerância
K = 4;          
e = 10^-2;

% % step 1: randomly assign a cluster to each one of the patterns
% n = size(X,1);
% U = zeros(n,K);    % partition matrix
% idx = zeros(n,1);
% for i = 1:n,
%     rnd = randi(K);
%     U(i,rnd) = 1;  
%     idx(i) = rnd;
% end

% randomly assign membership degrees to each observation
U = rand(n,K);
idx = zeros(n,1);
for i=1:n,
    U(i,:)=U(i,:)/sum(U(i,:)); % normalized
    [~, cluster] = max(U(i,:)); % cluster of actual sample
    idx(i) = cluster;
end

% calculating the objective function 
W = zeros(K,1);
for j = 1:K,
   indexes = find(idx==j);
   Clusj = X(indexes,:);
   W(j) = (1/length(indexes)) * sum(pdist(Clusj)); % pdist calculates the n(n-1)/2 distances among all patterns in the Cluster K
end
J(1) = sum(W);

% changes = true;
oldCentroids = zeros(K,d);
equals = 0;
% oldIdx = idx;
iter = 1;
while (equals < 3)    % iterate until the cluster assignments stop changing    
    % computing centroids
    um = U.^m;
    centroids = (um'*X)./repmat(sum(um,1)',1,d);
%     centroids = zeros(K,d);
%     for j = 1:K,
%         Gj = U(:,j);
%         onesIndexes = find(Gj == 1);
%         Xj = X(onesIndexes,:); 
%         centroids(j,:) = mean(Xj);
%     end;
    
    if d==2
        % ploting the new centroids
        xdata = centroids(:,1);
        ydata = centroids(:,2);
        pause(1)
        h = plot(xdata, ydata, 'ko', 'LineWidth', 2, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 10);
        set(h,'YDataSource','ydata')
        set(h,'XDataSource','xdata')
        refreshdata
    end;
    
%     % assign each pattern to the cluster whose centroid is closest 
%     U = zeros(n,K);
%     for i = 1:n,
%         pattern = X(i,:);
%         smallDistance = inf;
%         for j = 1:K,
%             gc = centroids(j,:);
%             distance = sum((pattern-gc).^2);  % squared Euclidian distance from pattern to each centroid  
%             if (distance < smallDistance),
%                 smallDistance = distance;
%                 smallIndex = j;
%             end
%         end
%         U(i,smallIndex) = 1;
%         idx(i) = smallIndex;
%     end

    % update membership matrix
    for i=1:n,
       temp = (repmat(X(i,:),K,1)-centroids).^2;
       sum_groups = sum(sum(temp));
       U(i,:) = (sum(temp,2)/sum_groups)';
    end
    % U(U<10^-5)=10^-5; % evita erros numericos
    U = U.^-(2/(m-1));
    for i=1:n,
        U(i,:)=U(i,:)/sum(U(i,:)); % normalized
        [~, cluster] = max(U(i,:)); % cluster of actual sample
        idx(i) = cluster;
    end
    
    % calculating the objective function 
    clus = unique(idx);
    c = length(clus);
    W = zeros(c,1);
    for j = 1:c,
       indexes = find(idx==clus(j));
       Clusj = X(indexes,:);
       W(j) = 1/length(indexes) * sum(pdist(Clusj)); % pdist calculates the n(n-1)/2 distances among all patterns in the Cluster K
    end
    iter = iter + 1;
    J(iter) = sum(W);
    
    %--------------------------------------
    % TODO: mudar o critério de parada, porque o cluster da amostra pode
    % não mudar mesmo quando a matriz de pertinência muda
    % verifying the stop criteria 
%     if isequal(idx,oldIdx),
%         changes = false;
%     else
%         oldIdx = idx;
%     end;
    if all(all(abs(centroids-oldCentroids)<e)),
        equals = equals + 1;
    else
        equals = 0;
    end;
    oldCentroids = centroids;
    
end;

if d==2
    % ploting the final clustering resulting from K-Means
    clus = unique(idx);
    colors = {'b.', 'r.', 'c.', 'm.', 'y.', 'k.'};
    for i = 1:length(clus),
        indexes = find(idx==clus(i));
        plot(X(indexes,1), X(indexes,2), colors{i});
    end

    % ploting the objective function as a function of the number of iterations
    figure(2);
    hold on;
    plot(1:iter, J(1:iter), 'b--', 'LineWidth', 2);
    grid on;
end
