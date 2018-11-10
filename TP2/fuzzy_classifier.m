function accuracy = fuzzy_classifier(x, y, K)
    if K > 8, K = 8; end

    d = size(x, 2);
    % Separando dados em treino e teste, equilibrando as duas classes.
    P = 0.70; % 70% para treino e 30% para teste.
    data = [x y];
    class1 = data(data(:, 3) == 0, :);
    class2 = data(data(:, 3) == 1, :);

    % Separando primeira classe.
    m = size(class1, 1);
    idx = randperm(m);
    training1 = class1(idx(1:round(P*m)), :);
    testing1 = class1(idx(round(P*m)+1:end), :);

    % Separando segunda classe.
    m = size(class2, 1);
    idx = randperm(m);
    training2 = class2(idx(1:round(P*m)), :);
    testing2 = class2(idx(round(P*m)+1:end), :);

    % Agrupando treino e teste.
    training = [training1; training2];
    yt = training(:,3);
    xt = training(:,1:2);
    testing = [testing1; testing2];
    yv = testing(:,3);
    xv = testing(:,1:2);

    colors = [0 0 1; 1 0 0; 1 1 0; 0 1 0; 1 0 1; 0 1 1; 0 0 0; 1 0.5 0.5];

    % Separando em grupos com o FCM.
    [centers, U] = fcm(xt, K);

    % Classificando cada entrada.
    n = size(U, 2);
    idx = zeros(n, 1);
    for i=1:n,
        [~, cluster] = max(U(:,i));
        idx(i) = cluster;
    end

    % Plotando agrupamentos.
    figure('name', 'Agrupamento', 'number', 'off');
    points = xt(idx == 1, :);
    plot(points(:, 1), points(:, 2), 'o', 'Color', colors(1, :));
    hold on
    plot(centers(1,1), centers(1,2), 'x', 'Color', colors(1, :), 'MarkerSize', 15, 'LineWidth', 3);
    for i=2:K,
        points = xt(idx == i, :);
        plot(points(:, 1), points(:, 2), 'o', 'Color', colors(i, :));
        plot(centers(i,1), centers(i,2), 'x', 'Color', colors(i, :), 'MarkerSize', 15, 'LineWidth', 3);
    end
    hold off

    % Definindo regras para infer�ncia.
    sig = zeros(K, d);
    yj = zeros(1, K);

    for j=1:K,
        % Definindo a dispers�o para as fun��es de pertin�ncia.
        points = xt(idx == j, :);
        nPoints = size(points, 1);
        yPoints = yt(idx == j);
        for i=1:d,
            sig(j, i) = sqrt(sum((points(:, i) - centers(j, i)).^2)/nPoints);               
        end
        
        % Definindo o consequente das regras como sendo a classe preponderante
        % pelas pertin�ncias dos pontos naquele grupo j.
        sumPert = zeros(1, d);
        for k=1:size(points, 1),
            s = 0;
            for i=1:d,
                % Gaussiana com centro na proje��o do centr�ide do grupo
                % j na vari�vel de entrada i.
                s = s + gaussmf(points(k, i), [sig(j, i), centers(j, i)]);
            end
            sumPert(yPoints(k) + 1) = sumPert(yPoints(k) + 1) + s;
        end

        [~, maxPart] = max(sumPert);
        yj(j) = maxPart - 1;
    end

    % Executando valida��o.
	errors = 0;
    yr = yv;
    for k=1:size(xv, 1),
        pert = zeros(K, d);
        for j=1:K,
            for i=1:d,
                % Pertinencia da amostra para a regra j.
                pert(j, i) = gaussmf(xv(k, i), [sig(j, i), centers(j, i)]);
            end
        end

        % Graus de ativa��o da amostra para a regra j.
        wj = prod(pert, 2);

        % Agregando graus de ativa��o para regras com
        % mesmo consequente com a soma probabil�stica.
        ag1 = 0;
        ag2 = 0;
        if any(yj == 0), ag1 = probor(wj(yj == 0)); end
        if any(yj == 1), ag2 = probor(wj(yj == 1)); end

        % Classificando resultado final da vari�vel pela
        % classe de maior soma probabil�stica.
        saida = ag1 < ag2;

        % Medindo a precis�o.
        if saida ~= yv(k)
            yr(k) = saida;
            errors = errors + 1;
        end
    end

    % Retorno.
    accuracy = 1 - errors/size(xv, 1);
end
