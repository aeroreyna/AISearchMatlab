function [ y,x ]=four_peak( x )
%función multimodal de 4 picos
%Rango [-5 5]
%2 Minimos globales en (0,-4) y (0,0), f(x)=-2
%2 minimos locales en (4,4) y (-4,4), f(x)=-1
x = x*10-5;
y =(-1)*( exp(-(x(1)-4)^2-(x(2)-4)^2)+exp(-(x(1)+4)^2-(x(2)-4)^2)+2*(exp(-x(1)^2-x(2)^2)+exp(-x(1)^2-(x(2)+4)^2)));

end