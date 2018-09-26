%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                UNIVERSIDADE FEDERAL DE MINAS GERAIS
%                        SISTEMAS NEBULOSOS
%                            TRABALHO #1
%                   PROF. CRISTIANO LEITE DE CASTRO
%
% NOME: Eduardo Santiago Ramos
% MATRÃ?CULA: 2014015435
% DATA: 19/04/2017
%
% ARQUIVO: 'fuzzycmeans.m' 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% EXEMPLOS
%    fuzzycmeans()
%    seed=10; fuzzycmeans(seed);

%#ok<*AGROW>
load SyntheticDataset.mat;

eps = 10^-2; % tolerancia
m = 2; % parametro

n = size(x,1); % numero de observacoes
d = size(x,2); % numero de dimensoes

costPerC = [];
figure; 
nc = 0;
nGrupos = 4;
for C=nGrupos % para diferentes numeros de grupos
 nc = nc + 1;

 % 1) Randomly assign membership degrees to each observation
 w = zeros(n,C);
 v = rand(n,C);
 for j=1:n, v(j,:)=v(j,:)/sum(v(j,:)); end % normaliza

 % 2) Iterate until cluster assignments stop changing
 cost = [];
 while(~all(all(abs(v-w)<eps)))
    w = v;

    u = w.^m;
    c = (u'*x)./repmat(sum(u,1)',1,d);

    % Cost function
    J = 0;
    for j=1:C
       J = J + w(:,j)'*(sum(((x-repmat(c(j,:),n,1)).^2),2));
    end
    cost = [cost J];

    % Plota
    [~,maxVec] = max(u,[],2);
    if d==2
       subfig1 = subplot(length(nGrupos),2,2*(nc-1)+1); 
       hold on
       for j=1:C
          plot(x(maxVec==j,1),x(maxVec==j,2),'*');
          plot(c(j,1),c(j,2),'ok','MarkerFaceColor','k',...
                                                 'MarkerSize',14);
       end
       pause(0.5);
       delete(subfig1);
    end

    % b) Update membership matrix
    for j=1:n
       um = (repmat(x(j,:),C,1)-c).^2;
       todos = sum(sum(um));
       v(j,:) = (sum(um,2)/todos)';
    end
    v(v<10^-5)=10^-5; % evita erros numericos
    v = v.^-(2/(m-1));
    for j=1:n, v(j,:)=v(j,:)/sum(v(j,:)); end % normaliza
 end
 costPerC = [costPerC cost(end)/C];

 [~,maxVec] = max(u,[],2);
 if d==2
    subplot(length(nGrupos),2,2*(nc-1)+1); 
    hold on
    for j=1:C
       plot(x(maxVec==j,1),x(maxVec==j,2),'*');
       plot(c(j,1),c(j,2),'ok','MarkerFaceColor','k',...
                                              'MarkerSize',14);
    end
 elseif d==3
    subplot(length(nGrupos),2,2*(nc-1)+1);
    for j=1:C
       plot3(x(maxVec==j,1),x(maxVec==j,2),x(maxVec==j,3),'*');
       hold on
       plot3(c(j,1),c(j,2),c(j,3),'ok','MarkerFaceColor','k',...
                                              'MarkerSize',14);
    end
 end
 pause(0.5);

 subplot(length(nGrupos),2,2*(nc-1)+2);
 plot(1:length(cost),cost,'-*','Color','k');
 xlabel('Iteracao');
 ylabel('Custo');
 pause(1);

end