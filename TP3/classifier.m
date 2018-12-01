%------------------------------------------------------------------------%
%                   Universidade Federal de Minas Gerais
%                       ELE075 - Sistemas Nebulosos
%                        Trabalho Computacional III
%                          Prof. Cristiano Leite
% 
% 
% Aluno: Rafael Carneiro de Castro
% Matrícula: 2013030210
% Data: 07/12/2018
%------------------------------------------------------------------------%
% Classificador ANFIS.
function accuracy = classifier(x, y, K, plotGraphs)
    d = size(x, 2);

    % Separando dados em treino e teste, equilibrando as duas classes.
    P = 0.70; % 70% para treino e 30% para teste.
    data = [x y];
    class1 = data(data(:, d + 1) == 0, :);
    class2 = data(data(:, d + 1) == 1, :);

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
    yt = training(:, d + 1);
    xt = training(:, 1:d);
    testing = [testing1; testing2];
    yd = testing(:, d + 1);
    xv = testing(:, 1:d);
    
    % Preparando o modelo.
    fis = genfis3(xt, yt, 'sugeno', K);
    % Treino, com um máximo de 100 épocas.
    fis = anfis([xt yt], fis, 100);    
    ys = evalfis(xt, fis);
    % Conversão dos parâmetros para classificação.
    ys(ys >= 0.5) = 1;
    ys(ys < 0.5) = 0;
    % Precisão do treinamento.
    accTrain = sum(yt == ys) / size(ys, 1);
    
    % Validação.
    yv = evalfis(xv, fis);
    % Conversão dos parâmetros para classificação.
    yv(yv >= 0.5) = 1;
    yv(yv < 0.5) = 0;
    
    accuracy = sum(yv == yd) / size(yv, 1);
end
