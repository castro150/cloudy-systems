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
%% Aproximação da função seno por ANFIS.
clear all;
close all;
clc;

% Plotando função seno e as aproximações por funções.
x = (0:0.01:2*pi)';
y = sin(x);
figure('name', 'Função Seno', 'number', 'off');
plot(x, y);
title('Função Seno');
figure('name', 'Funções Aproximadas', 'number', 'off');
plot(x, y, '-', x(x>=0 & x<pi/2), 2/pi.*x(x>=0 & x<pi/2)+0, '--', x(x>=pi/2 & x<3*pi/2), -2/pi.*x(x>=pi/2 & x<3*pi/2)+2, '--', x(x>=3*pi/2 & x<=2*pi), 2/pi.*x(x>=3*pi/2 & x<=2*pi)-4, '--');
title('Aproximando o seno por três retas');
legend('cosseno', 'f1', 'f2', 'f3');

% Dados para treinamento.
xt = (0:0.01:2*pi)';
yt = sin(xt) + 0.2*randn(length(xt),1); % Ruído adicionado.
training = [xt yt];

% Dados para teste.
xv = sort(2*pi*rand(size(xt)));
yd = sin(xv);

% Criação do sistema, com as regras iniciais. Os consequentes são:
%   - f1 = 2/pi.*x+0
%   - f2 = -2/pi.*x+2
%   - f3 = 2/pi.*x-4
init_sugeno = readfis('sugeno_inicial');
sin_fis = anfis(training, init_sugeno, 20); % ANFIS com 20 épocas.
yv = evalfis(xv, sin_fis);

% Exibindo função real e a aproximada pelo ANFIS.
figure('name', 'Aproximação Final', 'number', 'off');
plot(xv, yd, xv, yv);
title('Aproximação da Função Seno');
legend('Função Seno', 'ANFIS Projetado');
ylim([-1 1]);

% Cálculo do Erro Quadrático Médio.
EQM = sum((yd - yv).^2)/size(yd, 1);
fprintf('EQM: %f\n', EQM);

%% Classificador ANFIS com dados 2D.
clear all;

load('dataset_2d.mat');
% classifier(x, y, 3, false);