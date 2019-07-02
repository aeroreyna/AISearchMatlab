function [z,x]=Penholder(x)
% rango [-11 11]
% min [multiples]
    x=x*22-11;
    z=-exp(-abs(cos(x(1))*cos(x(2))*exp(1-abs(cos(x(1).^2+x(2).^2).^0.5/pi))).^-1);


end