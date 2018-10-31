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
% Testes comparativos entre o KMeans e o FCM
clear all;
close all;
clc;

x = (-pi/2:0.01:3*pi/2)';
y = cos(x);

z1 = 2/pi.*x+1;
z2 = -2/pi.*x+1;
z3 = 2/pi.*x-3;

figure('name', 'Fun��o Cosseno', 'number', 'off');
plot(x, y);
figure('name', 'Fun��es Aproximadas', 'number', 'off');
plot(x, y, '-', x(x<=0), 2/pi.*x(x<=0)+1, '--', x(x>0 & x<=pi), -2/pi.*x(x>0 & x<=pi)+1, '--', x(x>pi), 2/pi.*x(x>pi)-3, '--');
title('Aproximando o cosseno por tr�s retas');
legend('cosseno', 'f1', 'f2', 'f3');

w1 = trimf(x, [-pi/2, -pi/2, pi/2]);
w2 = trimf(x, [-pi/2, pi/2, 3*pi/2]);
w3 = trimf(x, [pi/2, 3*pi/2, 3*pi/2]);
figure('name', 'Fuzzyfica��es', 'number', 'off');
plot(x, w1, x, w2, x, w3);
legend('A1', 'A2', 'A3');

z = (w1 .* z1 + w2 .* z2 + w3 .* z3)./(w1 + w2 + w3);
figure('name', 'Aproxima��o Final', 'number', 'off');
plot(x, y, x, z);
legend('cosseno', 'z');

EQM = sum((y - z).^2)/size(y, 1);
fprintf('EQM: %f\n', EQM);
