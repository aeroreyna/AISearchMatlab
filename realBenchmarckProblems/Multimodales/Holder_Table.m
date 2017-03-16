function [ y, x ] = Holder_Table( x)
%Rango[-10 10]
%f(0,0)=0
x = x*20-10;
a=sqrt(x(1).^2+x(2).^2);
w=abs(1-(a/pi));
y= (-1)*(abs(sin(x(1))*cos(x(2))*exp(w)));

end