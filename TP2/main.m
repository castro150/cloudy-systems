%------------------------------------------------------------------------%
%                   Universidade Federal de Minas Gerais
%                       ELE075 - Sistemas Nebulosos
%                        Trabalho Computacional II
%                          Prof. Cristiano Leite
% 
% 
% Aluno: Rafael Carneiro de Castro
% Matr�cula: 2013030210
% Data: 11/11/2018
%------------------------------------------------------------------------%
%% Aproxima��o da fun��o cosseno pelo mecanismo de infer�ncia de Sugeno.
clear all;
close all;
clc;

x = (-pi/2:0.01:3*pi/2)';
y = cos(x);

% Fun��es de aproxima��o.
z1 = 2/pi.*x+1;
z2 = -2/pi.*x+1;
z3 = 2/pi.*x-3;

figure('name', 'Fun��o Cosseno', 'number', 'off');
plot(x, y);
figure('name', 'Fun��es Aproximadas', 'number', 'off');
plot(x, y, '-', x(x<=0), 2/pi.*x(x<=0)+1, '--', x(x>0 & x<=pi), -2/pi.*x(x>0 & x<=pi)+1, '--', x(x>pi), 2/pi.*x(x>pi)-3, '--');
title('Aproximando o cosseno por tr�s retas');
legend('cosseno', 'f1', 'f2', 'f3');

% Fun��es de pertin�ncia com os pesos calculados.
w1 = trimf(x, [-pi/2, -pi/2, pi/2]);
w2 = trimf(x, [-pi/2, pi/2, 3*pi/2]);
w3 = trimf(x, [pi/2, 3*pi/2, 3*pi/2]);
figure('name', 'Fuzzyfica��es', 'number', 'off');
plot(x, w1, x, w2, x, w3);
legend('A1', 'A2', 'A3');

% Aproxima��o final.
z = (w1 .* z1 + w2 .* z2 + w3 .* z3)./(w1 + w2 + w3);
figure('name', 'Aproxima��o Final', 'number', 'off');
plot(x, y, x, z);
legend('cosseno', 'z');

% C�lculo do Erro Quadr�tico M�dio.
EQM = sum((y - z).^2)/size(y, 1);
fprintf('EQM: %f\n', EQM);

%% Classificador bin�rio baseado em regras nebulosas.
clear all;

load('dataset_2d.mat');
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

K = 8;
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