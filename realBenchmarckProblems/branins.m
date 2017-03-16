function [ r ] = branins( vector )
%The Branin function is a global optimization test function having only two variables.
%The function has three equal-sized global optima.
x= vector;
a=1;
b=5.1/(4*pi^2);
c=5/pi;
d=6;
e=10;
f=1/(8*pi);

r=a*(x(2)-b*x(1)^2+c*x(1)-d)+e*(1-f)*cos(x(1))+e;

% global optima equal f(x1; x2) = 0.397887
% are located as follows: (x1; x2) = (-pi; 12.275); (pi; 2.275); (9.42478; 2.475).
 
end

