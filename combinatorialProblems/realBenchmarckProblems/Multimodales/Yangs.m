function [y,x]=Yangs(x)
%[-20 20]
x=x*40-20;
a=15;
n=2;
m=5;
s1=0;
s2=0;
p1=1;
for ii=1:n
    s1=s1+((x(ii)/a)^(2*m));
    s2=s2+( x(ii)^2 );
    p1=p1*( (cos(x(ii)))^2 );
end

y=(exp(-s1) - exp(-s2))*p1*1;
y = -y;


end