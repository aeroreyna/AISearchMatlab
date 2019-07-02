function [ r, x ] = rysunek( vector )
%RYSUNEK The sum of different powers is a commonly used unimodal test function.
x = vector;
x = x*2-1;
[m,n]=size(vector);
r=0;
for i=1:max(m,n)
    r = r + abs(x(i))^(i+1);
end

%Test area is usually restricted to hyphercube -1<=xi<=1, i = 1;...; n. 
%Its global minimum equal f(x) = 0 is obtainable for xi = 0, i = 1;...; n.
end

