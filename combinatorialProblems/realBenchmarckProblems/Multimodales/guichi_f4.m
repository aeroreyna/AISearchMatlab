function [y,x]=guichi_f4( x )
%[-2 2]
n=2;
x = x*4-2;
par1=x(1)*sin( 4*pi*x(1) );
par2=x(2)*sin( (4*pi*x(2))+pi );

y=(par1-par2+1)*-1;



end