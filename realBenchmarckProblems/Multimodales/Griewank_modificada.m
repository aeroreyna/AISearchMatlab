function [z,x]=Griewank_modificada(x)
%[0 120]
%[98 minima]
    x= x*120;
    par1=cos( 0.35*x(1) ) + cos ( 0.35*x(2) );
    a=4000;
    par2=(cos( 0.35*x(1) ) * cos( 0.35*x(2) ));


    z=(par1/a)+par2;



end