% This function computes x[-n]
function [y,n]=sigfold(x,n)
    y=fliplr(x);
    n=-fliplr(n);
end