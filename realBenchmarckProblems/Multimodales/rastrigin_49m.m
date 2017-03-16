function [y,x]=rastrigin_49m(x)
%[-1 1]
n=2;
x = x*2-1;
y=(x(1)^2)+(x(2)^2)-(cos(18*x(1)))-(cos(18*x(2)));




end