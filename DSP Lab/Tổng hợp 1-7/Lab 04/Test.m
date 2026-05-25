clc; clear; close all;
syms n z
x = 0.9^n ;
X = symsum (x.*(z.^-n), n,0,inf );
simplify(X)