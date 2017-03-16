function [y,x]=Hilly(x)
%[-100 100]

n=2;
x = x*200-100;
b=((5/6)*(100^(3/4)))^(4/3);

m1=exp(((abs(x(1)))/50)*-1);
m2=1-cos((6/(100^(0.75)))*(pi*(abs(x(1)))^0.75));
s1=m1*m2;

m3=exp(((abs(x(2)))/250)*-1);
m4=1-cos((6/(100^(0.75)))*(pi*(abs(x(2)))^0.75));
s2=m3*m4;

s3=2* ( exp( ((((b-x(1))^2)+((b-x(2))^2))/50)*-1 ) );

y=(s1+s2+s3)*1;