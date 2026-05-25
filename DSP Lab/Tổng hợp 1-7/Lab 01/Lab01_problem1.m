clc; clear; close all;

% Parameters
x = [1 -2 4 6 -5 8 10];
n = -1:5;   % vì n=0 tại x=-5

%% Part a
% shift
[y1,m1] = sigshift(x,n,-2);
[y2,m2] = sigshift(x,n,4);
[y3,m3] = sigshift(x,n,0);

% add
[D,nD] = sigadd(3*y1,m1,y2,m2);
[x1,nx1] = sigadd(D,nD,-2*y3,m3);

% plot
subplot(2,2,1)
stem(nx1,x1)
grid on
title('x_1[n]')
xlabel('n')
ylabel('Amplitude')


%% Part b
% shift
[t1,r1] = sigshift(x,n,-5);
[t2,r2] = sigshift(x,n,-4);
[t3,r3] = sigshift(x,n,0);

% scale
[t4,r4] = sigadd(5*t1,r1,4*t2,r2);
[t5,r5] = sigadd(t4,r4,3*t3,r3);

% plot
subplot(2,2,2)
stem(r5,t5)
grid on
title('x_2[n]')
xlabel('n')
ylabel('Amplitude')


%% Part c
% x(n+4)
[g1,h1] = sigshift(x,n,-4);

% x(n-1)
[g2,h2] = sigshift(x,n,1);

% x(n)
[g3,h3] = sigshift(x,n,0);

% x(2-n)
[f1,k1] = sigfold(x,n);
[f2,k2] = sigshift(f1,k1,2);

% multiplication
[p1,n1] = sigmult(g1,h1,g2,h2);
[p2,n2] = sigmult(f2,k2,g3,h3);

% addition
[x3,nx3] = sigadd(p1,n1,p2,n2);

% plot
subplot(2,2,3)
stem(nx3,x3)
grid on
title('x_3[n]')
xlabel('n')
ylabel('Amplitude')


%% Part d
% range required
n4 = -10:10;

% create x(n) over new range
x_ext = zeros(1,length(n4));
x_ext(find((n4>=min(n))&(n4<=max(n)))) = x;

% x(n+2)
[y4,m4] = sigshift(x_ext,n4,2);

y4 = cos(0.1*pi*m4).*y4;

% 2x(n)
x_double = 2*x_ext;

% addition
[x4,nx4] = sigadd(x_double,n4,y4,m4);

% plot
subplot(2,2,4)
stem(nx4,x4)
grid on
title('x_4[n]')
xlabel('n')
ylabel('Amplitude')