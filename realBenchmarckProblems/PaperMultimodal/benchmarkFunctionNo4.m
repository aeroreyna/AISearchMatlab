function [ r, x ] = benchmarkFunctionNo4( x )
x = 200 * x - 100;
[m, n] = size(x);
n = max(m,n);
y = x+0.1;
r = n;
for i=1:n
    if y(i)<0 || y(i)>1
        ti = y(i)^2;
    else
        ti = -exp( -2*log(2) * ( (y(i)-0.1)/0.8 )^2 ) * sin(5*pi*y(i))^6; 
    end
    r = r + ti;
end
end

