function [ y,x ] = FoxholesShekel(x)

[m n] = size(x);
n = max(n,m);

x = x*131.0720 - 65.5360;

sum = 0;
for i=0:24
    a = 16 * (mod(i,5)-2);
    b = 16 * (floor(i/5)-2);
    sum = sum + 1/( 1+i+ (x(1)-a)^6 + (x(2)-b)^6 );
end

y = 500 - 1/( 0.002 + sum);
y=-y;
end