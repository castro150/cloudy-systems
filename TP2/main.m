clear;
clc;

x = (-pi/2:0.01:3*pi/2)';
y = cos(x);

z1 = 2/pi.*x+1;
z2 = -2/pi.*x+1;
z3 = 2/pi.*x-3;

plot(x, y, '-', x(x<=0), 2/pi.*x(x<=0)+1, '--', x(x>0 & x<=pi), -2/pi.*x(x>0 & x<=pi)+1, '--', x(x>pi), 2/pi.*x(x>pi)-3, '--');
title('Aproximando o cosseno por três retas');
legend('cosseno', 'f1', 'f2', 'f3');

w1 = trimf(x, [-pi/2, -pi/2, pi/2]);
w2 = trimf(x, [-pi/2, pi/2, 3*pi/2]);
w3 = trimf(x, [pi/2, 3*pi/2, 3*pi/2]);
plot(x, w1, x, w2, x, w3);

z = (w1 .* z1 + w2 .* z2 + w3 .* z3)./(w1 + w2 + w3);
plot(x, y, x, z);
