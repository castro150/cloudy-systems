%------------------------------------------------------------------------%
%                   Universidade Federal de Minas Gerais
%                       ELE075 - Sistemas Nebulosos
%                        Trabalho Computacional II
%                          Prof. Cristiano Leite
% 
% 
% Aluno: Rafael Carneiro de Castro
% Matrícula: 2013030210
% Data: 11/11/2018
%------------------------------------------------------------------------%
%% Aproximação da função cosseno pelo mecanismo de inferência de Sugeno.
clear all;
close all;
clc;

x = (-pi/2:0.01:3*pi/2)';
y = cos(x);

% Funções de aproximação.
z1 = 2/pi.*x+1;
z2 = -2/pi.*x+1;
z3 = 2/pi.*x-3;

figure('name', 'Função Cosseno', 'number', 'off');
plot(x, y);
figure('name', 'Funções Aproximadas', 'number', 'off');
plot(x, y, '-', x(x<=0), 2/pi.*x(x<=0)+1, '--', x(x>0 & x<=pi), -2/pi.*x(x>0 & x<=pi)+1, '--', x(x>pi), 2/pi.*x(x>pi)-3, '--');
title('Aproximando o cosseno por três retas');
legend('cosseno', 'f1', 'f2', 'f3');

% Funções de pertinência com os pesos calculados.
w1 = trimf(x, [-pi/2, -pi/2, pi/2]);
w2 = trimf(x, [-pi/2, pi/2, 3*pi/2]);
w3 = trimf(x, [pi/2, 3*pi/2, 3*pi/2]);
figure('name', 'Fuzzyficações', 'number', 'off');
plot(x, w1, x, w2, x, w3);
legend('A1', 'A2', 'A3');

% Aproximação final.
z = (w1 .* z1 + w2 .* z2 + w3 .* z3)./(w1 + w2 + w3);
figure('name', 'Aproximação Final', 'number', 'off');
plot(x, y, x, z);
legend('cosseno', 'z');

% Cálculo do Erro Quadrático Médio.
EQM = sum((y - z).^2)/size(y, 1);
fprintf('EQM: %f\n', EQM);

%% Classificador binário baseado em regras nebulosas.
clear all;

load('dataset_2d.mat');
accuracies = zeros(7, 1);
for K=2:8,
    % Plota os gráficos para K = 2, K = 3 e K = 8.
    accuracies(K - 1) = fuzzy_classifier(x, y, K, K == 2 | K == 3 | K == 8);
end

figure('name', 'Precisões - dataset_2d', 'number', 'off');
accPlot = plot(2:8, accuracies, 'LineWidth', 3);
ylim([0.2 1.1]);

%% Testando o classificador com a base Pima Diabetes.
D = csvread('diabetes.csv');

xd = D(:, 1:8);
yd = D(:, 9);

accuracies2 = zeros(7, 1);
for K=2:8,
    % Plota os gráficos para K = 2, K = 3 e K = 8.
    accuracies2(K - 1) = fuzzy_classifier(xd, yd, K, 0);
end