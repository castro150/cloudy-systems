%-----------------------------------------------------------------
% This script Ilustrates the use of genfis1 and genfis3

clear all;
close all;
clc;

% defining training data

% regression problem
% generate N random numbers in the interval [a,b] 
% with the formula r = a + (b-a).*rand(N,1);.
XX = 0:0.1:2*pi;
Y = sin(XX);     % real system

% training data 
X = 0 + (2*pi - 0).* rand(20,1);
Yd = sin(X) + 0.2*randn(length(X),1);
figure;
hold on;
plot(XX,Y,'b-','LineWidth',2);
plot(X,Yd,'ro','LineWidth',2);



%-----------------------------------------------------------------------
% fis = genfis1(data,numMFs,inmftype,outmftype)  
% genfis1 generates a single-output Sugeno-type fuzzy inference system 
% using a grid partition on the data.

% Specify the following input membership functions for the generated FIS:
% 3 Gaussian membership functions for the first input variable (x1)
% 5 triangular membership functions for the second input variable (x2)
numMFs = 3;
mfType = char('gaussmf');

% Generate the FIS
data = [X Yd];   % data = [X1 X2 ... Yd]
fis1 = genfis1(data, numMFs, mfType);

% Plot the input membership functions. Each input variable has the 
% specified number and type of input membership functions, evenly 
% distributed over their input range.
figure;
[x1,mf1] = plotmf(fis1,'input',1);
%subplot(2,1,1)
plot(x1,mf1)
xlabel('input 1 (gaussmf)')
% [x2,mf2] = plotmf(fis1,'input',2);
% subplot(2,1,2)
% plot(x2,mf2)
% xlabel('input 2 (trimf)')


%-----------------------------------------------------------------------
% fis = genfis3(Xin,Xout,type,cluster_n) 
% genfis3 generates an FIS using fuzzy c-means (FCM) 
% clustering by extracting a set of rules that models the data behavior. 

type = 'sugeno';
numClusters = 3; % equal to number of rules

%Generate a Sugeno-type FIS with 3 rules.
% The input membership function type is 'gaussmf'. By default, 
% the output membership function type is 'linear'. 
fis2 = genfis3(X, Yd, type, numClusters);

% Plot the input membership functions.
figure;
[x1,mf1] = plotmf(fis2,'input',1);
%subplot(2,1,1)
plot(x1,mf1)
xlabel('input 1 (gaussmf)')
% [x2,mf2] = plotmf(fis2,'input',2);
% subplot(2,1,2)
% plot(x2,mf2)
% xlabel('Membership Functions for Input 2')
