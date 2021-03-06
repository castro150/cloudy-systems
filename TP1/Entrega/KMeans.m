%------------------------------------------------------------------------%
%                   Universidade Federal de Minas Gerais
%                       ELE075 - Sistemas Nebulosos
%                         Trabalho Computacional I
%                          Prof. Cristiano Leite
% 
% 
% Aluno: Rafael Carneiro de Castro
% Matrícula: 2013030210
% Data: 03/10/2018
%------------------------------------------------------------------------%
% Algoritmo KMeans disponibilizado pelo professor
function [U, idx, y, iter] = KMeans(X, K, plotObj)
    % step 1: randomly assign a cluster to each one of the patterns
    n = size(X,1);
    U = zeros(n,K);    % partition matrix
    idx = zeros(n,1);
    for i = 1:n,
        rnd = randi(K);
        U(i,rnd) = 1;  
        idx(i) = rnd;
    end

    % calculating the objective function 
    W = zeros(K,1);
    for j = 1:K,
       indexes = find(idx==j);
       Clusj = X(indexes,:);
       W(j) = (1/length(indexes)) * sum(pdist(Clusj)); % pdist calculates the n(n-1)/2 distances among all patterns in the Cluster K
    end
    J(1) = sum(W);

    changes = true;
    oldIdx = idx;
    iter = 1;
    while (changes)    % iterate until the cluster assignments stop changing

        % computing the initial centroids
        centroids = zeros(K,2);
        for j = 1:K,
            Gj = U(:,j);
            onesIndexes = find(Gj == 1);
            Xj = X(onesIndexes,:); 
            centroids(j,:) = mean(Xj);
        end;

        % assign each pattern to the cluster whose centroid is closest 
        U = zeros(n,K);
        for i = 1:n,
            pattern = X(i,:);
            smallDistance = inf;
            for j = 1:K,
                gc = centroids(j,:);
                distance = sum((pattern-gc).^2);  % squared Euclidian distance from pattern to each centroid  
                if (distance < smallDistance),
                    smallDistance = distance;
                    smallIndex = j;
                end
            end
            U(i,smallIndex) = 1;
            idx(i) = smallIndex;
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

        % verifying the stop criteria 
        if isequal(idx,oldIdx),
            changes = false;
        else
            oldIdx = idx;
        end;

    end;
    y = J(end);

    if plotObj,
        % ploting the objective function as a function of the number of iterations
        figure(2);
        hold on;
        plot(1:iter, J(1:iter), 'b--', 'LineWidth', 2);
        grid on;
    end
end
