%------------------------------------------------------------------------%
%                   Universidade Federal de Minas Gerais
%                       ELE075 - Sistemas Nebulosos
%                        Trabalho Computacional III
%                          Prof. Cristiano Leite
% 
% 
% Aluno: Rafael Carneiro de Castro
% Matr�cula: 2013030210
% Data: 07/12/2018
%------------------------------------------------------------------------%
% Obt�m um fold espec�fico no conjunto de dados, num particionamento de 10 folds.
function [training, validation] = get_10_fold(data, fold)
    fold_size = floor(size(data, 1)/10);
    
    end_postition = fold_size * fold;
    if (fold == 10); end_postition = size(data, 1); end;
    start_position = end_postition - fold_size + 1;
    
    validation = data(start_position:end_postition, :);
    training = data(~ismember(data, validation, 'rows'), :);
end