function [z,x]=Vincent(x)

%[0.25 10]
x = x*9.75+0.25;

[aux1,aux2]=size(x);
if(aux1>=aux2)
    n = aux1;
else
    n= aux2;
end

s=0;
for ii=1:n
    s=s+sin(10*log(x(ii)));    
end

z=(s/n);

end