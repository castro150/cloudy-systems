%-----------------------------------------------------------------
% This script Ilustrates the use of genfis1 and genfis3

clear all;
close all;
clc;

% defining training data

% classification problem
load dataset_2d.mat;
X = x;
Yd = y;
% figure;
% hold on;
% grid on;
% plot(X(:,1),X(:,2),'b.');


% %-----------------------------------------------------------------------
% % fis = genfis1(data,numMFs,inmftype,outmftype)  
% % genfis1 generates a single-output Sugeno-type fuzzy inference system 
% % using a grid partition on the data.
% 
% % Specify the following input membership functions for the generated FIS:
% % 3 Gaussian membership functions for the first input variable (x1)
% % 5 triangular membership functions for the second input variable (x2)
% numMFs = [3 5];
% mfType = char('gaussmf','trimf');
% 
% % Generate the FIS
% data = [X Yd];   % data = [X1 X2 Yd]
% fis1 = genfis1(data, numMFs, mfType);
% 
% % Plot the input membership functions. Each input variable has the 
% % specified number and type of input membership functions, evenly 
% % distributed over their input range.
% figure;
% [x1,mf1] = plotmf(fis1,'input',1);
% subplot(2,1,1)
% plot(x1,mf1)
% xlabel('input 1 (gaussmf)')
% [x2,mf2] = plotmf(fis1,'input',2);
% subplot(2,1,2)
% plot(x2,mf2)
% xlabel('input 2 (trimf)')


%-----------------------------------------------------------------------
% fis = genfis3(Xin,Xout,type,cluster_n) 
% genfis3 generates an FIS using fuzzy c-means (FCM) 
% clustering by extracting a set of rules that models the data behavior. 

type = 'sugeno';
numClusters = 4; % equal to number of rules

% TESTE
X = X(1:70, :);
Yd = Yd(1:70);

%Generate a Sugeno-type FIS with 3 rules.
% The input membership function type is 'gaussmf'. By default, 
% the output membership function type is 'linear'. 
fis2 = genfis3(X, Yd, type, numClusters);

% TESTE
yv = evalfis(x(71:100, :), fis2);

% Plot the input membership functions.
% figure;
% [x1,mf1] = plotmf(fis2,'input',1);
% subplot(2,1,1)
% plot(x1,mf1)
% xlabel('Membership Functions for Input 1')
% [x2,mf2] = plotmf(fis2,'input',2);
% subplot(2,1,2)
% plot(x2,mf2)
% xlabel('Membership Functions for Input 2')
