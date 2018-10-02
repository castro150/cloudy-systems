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
% Algoritmo FCM
function [U, idx, y, iter, centroids] = FCM(X, K, e, plotObj)
    m = 2;
    n = size(X,1);
    d = size(X,2);

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

        % update membership matrix
        for i=1:n,
           temp = (repmat(X(i,:),K,1)-centroids).^2;
           sum_groups = sum(sum(temp));
           U(i,:) = (sum(temp,2)/sum_groups)';
        end
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

        if all(all(abs(centroids-oldCentroids)<e)),
            equals = equals + 1;
        else
            equals = 0;
        end;
        oldCentroids = centroids;
    end;
    y = J(end);
    
    if plotObj,
        % ploting the final centroids
        figure(1);
        hold on;
        plot(X(:,1), X(:,2),'b.');
        grid on;
        xdata = centroids(:,1);
        ydata = centroids(:,2);
        pause(1);
        h = plot(xdata, ydata, 'ko', 'LineWidth', 2, 'MarkerEdgeColor','k', 'MarkerFaceColor','g', 'MarkerSize', 10);
        set(h,'YDataSource','ydata');
        set(h,'XDataSource','xdata');
        refreshdata(h, 'caller');
        
        % ploting the objective function as a function of the number of iterations
        figure(2);
        hold on;
        plot(1:iter, J(1:iter), 'b--', 'LineWidth', 2);
        grid on;
    end
end
