function [ r, x ] = michalewicz( vector )
%The Michalewicz function is a multimodal test function (owns n! local optima).
%The parameter m defines the “steepness” of the valleys or edges. Larger m leads
%to more difficult search.
x = vector;
x = x * pi;
n = max(size(x));
m = 10;
r = 0;
for i = 1:n;
    r = r+sin(x(i))*(sin(i*x(i)^2/pi))^(2*m);
end
r=-r;
%Test area is usually restricted to hyphercube 0<=xi<=pi,
%i = 1;...; n. The global minimum value has been approximated by f(x) =
%-4.687 for n = 5 and by f(x) = -9.66 for n = 10, 
%at n=2, f(x*) = -1.8013. xi=[2.20319,1.57049]
end

