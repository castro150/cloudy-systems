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
function [accuracy, accTrain, accVal] = classifier(x, y, K, plotGraphs)
    warning('off','all');
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

    % Agrupando treino e teste, embaralhando dados.
    testing = [testing1; testing2];
    training = [training1; training2];
    training = training(randperm(size(training, 1)), :);
    
    % Inicialização de variáveis.
    accTrains = zeros(10, 1);
    accVals = zeros(10, 1);    
    
    % Validação cruzada com 10 folds.
    for i=1:10,
        % Separando fold de validação do treino.
        [train, val] = get_10_fold(training, i);
    
        yTrain = train(:, d + 1);
        xTrain = train(:, 1:d);
        yVal = val(:, d + 1);
        xVal = val(:, 1:d);
        
        % Preparando o modelo.
        init_fis = genfis3(xTrain, yTrain, 'sugeno', K, [NaN NaN NaN false]);
        % Treino, com um máximo de 100 épocas.
        fis = anfis([xTrain yTrain], init_fis, 20, zeros(4, 1));
        ysTrain = evalfis(xTrain, fis);
        % Conversão dos parâmetros para classificação.
        ysTrain(ysTrain >= 0.5) = 1;
        ysTrain(ysTrain < 0.5) = 0;
        
        % Precisão do treinamento.
        accTrains(i) = sum(yTrain == ysTrain) / size(ysTrain, 1);
        
        % Validação cruzada e precisão.
        ysVal = evalfis(xVal, fis);
        ysVal(ysVal >= 0.5) = 1;
        ysVal(ysVal < 0.5) = 0;
        accVals(i) = sum(yVal == ysVal) / size(ysVal, 1);
        
        if max(accVals) == accVals(i),
            best_fis = fis;
        end
        
        fprintf('FOLD %d DONE\n', i);
    end
    
    % Teste.    
    yTest = testing(:, d + 1);
    xTest = testing(:, 1:d);
    ysTest = evalfis(xTest, best_fis);
    % Conversão dos parâmetros para classificação.
    ysTest(ysTest >= 0.5) = 1;
    ysTest(ysTest < 0.5) = 0;
    
    accuracy = sum(ysTest == yTest) / size(ysTest, 1);
    accTrain = mean(accTrains);
    accVal = mean(accVals);
    
    if plotGraphs,
        % Plotando separação final.
        figure('name', 'Separação Final', 'number', 'off');
        hold on
        for v=1:size(xTest, 1),
            color = 'k';
            symbol = 'o';
            if (ysTest(v) == 1); color = 'r'; end;
            if (ysTest(v) ~= yTest(v)); symbol = 'x'; end;
            point = xTest(v, :);
            plot(point(1), point(2), symbol, 'Color', color);
        end
        hold off
    end
end
