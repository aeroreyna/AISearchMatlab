function [ r, x ] = benchmarkFunctionNo( x )
x = 200 * x - 100;
[m, n] = size(x);
y = x;
n = max(m,n);
r = 4.126514*n/2.0;
for i=1:2:n
    y(i) = y(i) - 0.089842;
    y(i+1) = y(i+1) + 0.712656; 
    t = -4*((4-2.1*y(i)^2+y(i)^4/3)*y(i)^2 + y(i)*y(i+1) + (-4+4*y(i+1)^2)*y(i+1)^2);
    r = r + t;
end
end

