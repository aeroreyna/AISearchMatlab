function [y,x]=Ripple(x)
%[-5 0; 10 15]
x(1) = x(1)*15-5;
x(2) = x(2)*15;

p1=exp( -2*log(2)*( (x(1)-0.1)/0.8 )^2 );
p2=(sin(5*pi*(x(1)))^6)+( 0.1*(cos(500*pi*x(1)))^2 );

p3=exp( -2*log(2)*( (x(2)-0.1)/0.8 )^2 );
p4=(sin(5*pi*(x(2)))^6)+( 0.1*(cos(500*pi*x(2)))^2 );


y=(p1*p2)+(p3*p4);

y=y*(-1);





end