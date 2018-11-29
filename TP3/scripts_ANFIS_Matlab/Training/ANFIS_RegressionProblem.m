clear all;
close all;
clc;
 
% regression problem
XX = 0:0.1:2*pi;
Y = sin(XX);     % real system
 
% data set 
% generate N random numbers in the interval [a,b] 
% with the formula r = a + (b-a).*rand(N,1);.
N = 40;
X = 0 + (2*pi - 0).* rand(N,1);
Yd = sin(X) + 0.2*randn(length(X),1);
 
% separate data into training and test sets
numTrain = round(0.7*N);
XTrain = X(1:numTrain);
YdTrain = Yd(1:numTrain);
XTest = X(numTrain+1:end);
YdTest = Yd(numTrain+1:end);
 
figure(1);
hold on;
plot(XX,Y,'b-','LineWidth',2);
plot(XTrain,YdTrain,'ro','LineWidth',2);
plot(XTest,YdTest,'go','LineWidth',2);
legend('Real Function', 'Training Data', 'Test Data')
 
%-----------------------------------------------------------------------
% defining the FIS structure
 
% using genfis1 (grid partition) to generate FIS structure
numMFs = 2;
mfType = char('gaussmf');
fis = genfis1([XTrain YdTrain], numMFs, mfType);

% using FCMeans partition to generate FIS structure
% type = 'sugeno';
% numClusters = 10; % equal to number of rules
% fis = genfis3(XTrain, YdTrain, type, numClusters);
% fis3 = genfis3([XTrain YdTrain], YdTrain, type, numClusters);
%  
% Plot the input membership functions before training
figure(2);
[x1,mf1] = plotmf(fis,'input',1);
plot(x1,mf1)
xlabel('input 1 (gaussmf)')

% Plot anfis output before training
Ys = evalfis(XX,fis);
figure(3);
hold on;
plot(XX,Y,'b-','LineWidth',2);
plot(XX,Ys,'c--','LineWidth',2);
legend('Real Function', 'Training Data', 'Test Data', 'ANFIS Approximation before training');

% figure;
% [x1,mf1] = plotmf(fis3,'input',1);
% plot(x1,mf1)
% xlabel('input 1 (gaussmf)')

%------------------------------------------------------------------------
% Training ANFIS 
% Training routine for Sugeno-type Fuzzy Inference System 
% [fis,error] = anfis(trnData,initFis,trnOpt)
% trnOpt: a vector of training options. When a training 
% option is entered as NaN, the default options is in force. 
% These options are as follows:
% trnOpt(1): training epoch number (default: 10)
% trnOpt(2): training error goal (default: 0)
% trnOpt(3): initial step size (default: 0.01)
% trnOpt(4): step size decrease rate (default: 0.9)
% trnOpt(5): step size increase rate (default: 1.1)

maxIter = 100;
fis = anfis([XTrain YdTrain], fis, maxIter);

%------------------------------------------------------------------------
% Evaluate FIS on Training data 
YsTrain = evalfis(XTrain, fis);
trainErr = immse(YdTrain,YsTrain); % mean squared error
 
%------------------------------------------------------------------------
% Evaluate FIS on Test data 
YsTest = evalfis(XTest, fis);
testErr = immse(YdTest,YsTest); % mean squared error

% Plot anfis output after training
Ys = evalfis(XX,fis);
figure(4);
hold on;
plot(XX,Y,'b-','LineWidth',2);
plot(XX,Ys,'c--','LineWidth',2);
plot(XTrain,YdTrain,'ro','LineWidth',2);
plot(XTest,YdTest,'go','LineWidth',2);
legend('Real Function', 'Training Data', 'Test Data', 'ANFIS Approximation');

% Plot the input membership functions after training
figure(5);
[x1,mf1] = plotmf(fis,'input',1);
plot(x1,mf1)
xlabel('input 1 (gaussmf)')
