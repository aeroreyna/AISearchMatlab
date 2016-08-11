function [y,x]=Trefethen4(x)
%limites [-6.5 -4.5 6.5 4.5]
x(1) = x(1)*13-12.5;
x(2) = x(2)*9-4.5;
y=exp(sin(50.0*x(1)))+sin(60.0*exp(x(2)))+sin(70.0*sin(x(1)))+sin(sin(80*x(2)))-sin(10.0*(x(1)+x(2)))+1.0/4.0*(x(1)*x(1)+x(2)*x(2));