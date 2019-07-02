function [y, x]=Bohachevsky(x)
%[-50 50]

x=x*100-50;
y=(x(1)^2)+(2*x(2)^2)-(0.3*cos(3*pi*x(1)))-(0.4*cos(4*pi*x(2)))+0.7;


end