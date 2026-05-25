% This function to illustrate x[n-k]
% Input k: shifted number
function [y,m]=sigshift(x,n,k)
    y = x;      % Value of x does not change
    m = n + k;  % Index is shifted
end