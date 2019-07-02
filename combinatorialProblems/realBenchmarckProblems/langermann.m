function [ r, x ] = langermann( vector )
%The Langermann function is a multimodal test function. The local minima are
%unevenly distributed. Only 2 Dimensions
a = [3, 5, 2, 1, 7];
b = [5, 2, 1, 4, 9];
c = [1, 2, 5, 2, 3];
x=vector;
r=0;
for m=1:5
    r = r + c(m)*exp(-1/pi*((x(1)-a(m))^2+(x(2)-b(m))^2))*...
    cos(pi*((x(1)-a(m))^2+(x(2)-b(m))^2));
end

%Test area is usually restricted to hyphercube 0<=xi<=10, i = 1;...; n. 
%Its global minimum equal f(x) = -1,4.
end

