function [ r, x ] = f1d( vector )
%ACKLEY Summary of this function goes here
%   Detailed explanation goes here
x= vector;
x = 9 * x+0.15;
r = 10*cos(x*6)/x;
%It is recommended to set a = 20, b = 0:2, c = 2PI. Test area is usually restricted to
%hyphercube -32.768<=xi<=32.768, i = 1;...; n. Its global minimum f(x) = 0
%is obtainable for xi = 0, i = 1;...; n.
end

