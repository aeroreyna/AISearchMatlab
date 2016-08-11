function [z,x]=Crosstray(x)

% rango [-10 10]
% min []
x=x*20-10;
z=-0.0001*((abs(sin(x(1))*sin(x(2))*exp(abs((100-(x(1).^2+x(2).^2).^0.5/pi)))))+1).^0.1;




end