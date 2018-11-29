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
%% Aproximação da função seno por ANFIS.
clear all;
close all;
clc;

% Dados para treinamento.
xt = (0:0.01:2*pi)';
yt = sin(xt);
training = [xt yt];

% Dados para teste.
xv = sort(2*pi*rand(size(xt)));
yd = sin(xv);

% Criação do sistema, com as regras iniciais:
%   - trimf(x, [-pi 0 pi])
%   - trimf(x, [0 pi 2*pi])
%   - trimf(x, [pi 2*pi 3*pi])
init_sugeno = readfis('sugeno_inicial');
sin_fis = anfis(training, init_sugeno, 20);
yv = evalfis(xv, sin_fis);
plot(xv, yd, xv, yv);

% Exibindo função real e a aproximada pelo ANFIS.
figure(1);
title('Aproximação da Função Seno');
legend('Função Seno', 'ANFIS Projetado');

% Cálculo do Erro Quadrático Médio.
EQM = sum((yd - yv).^2)/size(yd, 1);
fprintf('EQM: %f\n', EQM);