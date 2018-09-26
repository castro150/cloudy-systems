%------------------------------------------------------------------------%
%                   Universidade Federal de Minas Gerais
%                       ELE075 - Sistemas Nebulosos
%                         Trabalho Computacional I
%                          Prof. Cristiano Leite
% 
% 
% Aluno: Rafael Carneiro de Castro
% Matr�cula: 2013030210
% Data: 03/10/2018
%------------------------------------------------------------------------%
% Testes comparativos entre o KMeans e o FCM
clear all;
close all;
clc;

% carregando dados
load fcm_dataset.mat;

N = 30;
ys = zeros(N,2);
iters = zeros(N,2);

for i=1:30
    [~, ~, yfcm, iterfcm] = FCM(x, 4, 10^-2, false);
    [~, ~, ykm, iterkm] = KMeans(x, 4, false);
    ys(i,1) = yfcm;
    iters(i,1) = iterfcm;
    ys(i,2) = ykm;
    iters(i,2) = iterkm;
    fprintf('>>>>>>>> ITERA��O N�MERO %d\n',i);
end

centrosCorretos = sum(ys > 65 & ys < 66);
mediaIteracoes = mean(iters);

fprintf('===== FCM\n');
fprintf('\tCENTROS CORRETOS: %d\n', centrosCorretos(1));
fprintf('\tM�DIA DE ITERA��ES: %f\n', mediaIteracoes(1));
fprintf('===== KMeans\n');
fprintf('\tCENTROS CORRETOS: %d\n', centrosCorretos(2));
fprintf('\tM�DIA DE ITERA��ES: %f\n', mediaIteracoes(2));
