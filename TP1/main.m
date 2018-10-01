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
    [~, ~, yfcm, iterfcm, ~] = FCM(x, 4, 10^-2, false);
    [~, ~, ykm, iterkm] = KMeans(x, 4, false);
    ys(i,1) = yfcm;
    iters(i,1) = iterfcm;
    ys(i,2) = ykm;
    iters(i,2) = iterkm;
    fprintf('>>>>>>>> ITERAÇÃO NÚMERO %d\n',i);
end

centrosCorretos = sum(ys > 65 & ys < 66);
mediaIteracoes = mean(iters);

fprintf('===== FCM\n');
fprintf('\tCENTROS CORRETOS: %d\n', centrosCorretos(1));
fprintf('\tMÉDIA DE ITERAÇÕES: %f\n', mediaIteracoes(1));
fprintf('===== KMeans\n');
fprintf('\tCENTROS CORRETOS: %d\n', centrosCorretos(2));
fprintf('\tMÉDIA DE ITERAÇÕES: %f\n', mediaIteracoes(2));

addpath ImagensTeste/

% string vector com os nomes das imagens
imageNames = [ 'photo001.jpg';
               'photo002.jpg';
               'photo003.jpg';
               'photo004.jpg';
               'photo005.jpg';
               'photo006.jpg';
               'photo007.jpg';
               'photo008.jpg';
               'photo009.jpg';
               'photo010.jpg';
               'photo011.png';
               ];
imageNamesCell = cellstr(imageNames);

% quantidade de cores para cada imagem
colors = [7 17 8 9 11 7 5 12 7 5 5];

for imgIndex = 1:11;
    % obtendo a imagem RGB, altera seu tamanho e mostra a imagem original (rows x cols x bands)
    currentImage = strtrim(imageNamesCell{imgIndex});   
    rgbImage = im2double(imread(currentImage));   % im2double() - converte pixels para double
    rgbImage = imresize(rgbImage,0.25,'box');

    figure(imgIndex);
    hold on;
    subplot(1,2,1);
    title('Original Image')
    imshow(rgbImage);

    % transformando a imagem (rows x cols x bands) em um array de pixels (rows*cols, bands)
    [rows, cols, bands] = size(rgbImage);
    arrayImage = zeros(rows*cols, bands);
    k = 1;
    for i = 1:rows;
        for j = 1: cols, 
            r = rgbImage(i,j,1);
            g = rgbImage(i,j,2);
            b = rgbImage(i,j,3);
            arrayImage(k,:) = [r,g,b];
            k = k+1;
        end
    end

    % calculando uma nova imagem com o FCM
    N = size(arrayImage, 1);
    [U, idx, ~, ~, c] = FCM(arrayImage, colors(imgIndex), 10^-2, false);
    newArrayImage = zeros(rows*cols, bands);
    for i = 1:N;
        newArrayImage(i,:) = c(idx(i),:);
    end
    fprintf('Acabou de calcular a imagem %s\n', currentImage);

    % transformando o retorno do algoritmo em uma nova imagem RGB
    newRgbImage = zeros(rows, cols, bands);
    k = 1;
    for i = 1:rows;
        for j = 1: cols, 
            newRgbImage(i,j,1) = newArrayImage(k, 1);
            newRgbImage(i,j,2) = newArrayImage(k, 2);
            newRgbImage(i,j,3) = newArrayImage(k, 3);
            k = k+1;
        end
    end
    
    % exibindo nova imagem RGB
    subplot(1,2,2);
    title('FCM Image')
    imshow(newRgbImage);
end