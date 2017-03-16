function [ r, x ] = benchmarkFunctionNo1( x )
x = 200 * x - 100;
[m, n] = size(x);
n = max(m,n);
y = x+20;
r = 200*n;
for i=1:n
    if y(i)<0
        ti = -160 + y(i).^2;
    else
        if y(i) <= 15
            ti = 160/15 * (y(i)-15);
        else
            if y(i) <= 20
                ti = 200/5 * (15-y(i));
            else
                ti = -200 + (y(i)-20).^2;
            end
        end
    end
    r = r + ti;
end
end

