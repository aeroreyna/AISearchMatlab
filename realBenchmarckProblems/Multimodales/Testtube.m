function [z,x]=Testtube(x)
% Rango [-10 10]
% min [1, 2]
    x = x*20-10;
    z=-4*abs(sin(x(1))*cos(x(2)))*exp(abs(cos(x(1).^2+x(2).^2)/200));

end