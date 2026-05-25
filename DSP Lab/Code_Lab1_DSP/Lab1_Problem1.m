clc; clear; close all;

% Given signal: n = 0 at the value -5
x = [1 -2 4 6 -5 8 10];
n = -4:2;

% Plot the given signal first
figure
stem(n, x, 'filled')
grid on
title('Given signal x[n]')
xlabel('n'); ylabel('x[n]')

figure

%% Part a:  x1[n] = 3x(n+2) + x(n-4) - 2x(n)
[y1,m1] = sigshift(x,n,-2);   % x(n+2)
[y2,m2] = sigshift(x,n, 4);   % x(n-4)
[y3,m3] = sigshift(x,n, 0);   % x(n)

[D ,nD ] = sigadd(3*y1,m1, y2,m2);
[x1,nx1] = sigadd(D ,nD , -2*y3,m3);

subplot(2,2,1)
stem(nx1,x1,'filled'); grid on
title('x_1[n] = 3x(n+2) + x(n-4) - 2x(n)')
xlabel('n'); ylabel('Amplitude')

%% Part b:  x2[n] = 5x(n+5) + 4x(n+4) + 3x(n)
[t1,r1] = sigshift(x,n,-5);   % x(n+5)
[t2,r2] = sigshift(x,n,-4);   % x(n+4)
[t3,r3] = sigshift(x,n, 0);   % x(n)

[t4,r4]   = sigadd(5*t1,r1, 4*t2,r2);
[x2,nx2]  = sigadd(t4,r4, 3*t3,r3);

subplot(2,2,2)
stem(nx2,x2,'filled'); grid on
title('x_2[n] = 5x(n+5) + 4x(n+4) + 3x(n)')
xlabel('n'); ylabel('Amplitude')

%% Part c:  x3[n] = x(n+4)*x(n-1) + x(2-n)*x(n)
% First product: x(n+4) * x(n-1)
[a1,na1] = sigshift(x,n,-4);          % x(n+4)
[a2,na2] = sigshift(x,n, 1);          % x(n-1)
[p1,np1] = sigmult(a1,na1, a2,na2);

% Second product: x(2-n) * x(n)
[xf,nf]  = sigfold(x,n);              % x(-n)
[a3,na3] = sigshift(xf,nf,2);         % x(-(n-2)) = x(2-n)
[a4,na4] = sigshift(x,n,0);           % x(n)
[p2,np2] = sigmult(a3,na3, a4,na4);

[x3,nx3] = sigadd(p1,np1, p2,np2);

subplot(2,2,3)
stem(nx3,x3,'filled'); grid on
title('x_3[n] = x(n+4)x(n-1) + x(2-n)x(n)')
xlabel('n'); ylabel('Amplitude')

%% Part d:  x4[n] = 2x(n) + cos(0.1*pi*n)*x(n+2),  -10 <= n <= 10
% Term 1: 2x(n)
[b1,nb1] = sigshift(x,n,0);
b1 = 2*b1;

% Term 2: cos(0.1*pi*n) * x(n+2)
nc = -10:10;
c  = cos(0.1*pi*nc);
[b2,nb2] = sigshift(x,n,-2);          % x(n+2)
[mm,nmm] = sigmult(c,nc, b2,nb2);

[x4,nx4] = sigadd(b1,nb1, mm,nmm);

% Restrict to -10 <= n <= 10
idx = (nx4 >= -10) & (nx4 <= 10);
nx4 = nx4(idx);
x4  = x4(idx);

subplot(2,2,4)
stem(nx4,x4,'filled'); grid on
title('x_4[n] = 2x(n) + cos(0.1\pin)x(n+2)')
xlabel('n'); ylabel('Amplitude')