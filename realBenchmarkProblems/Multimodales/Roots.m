function [z,ent]=Roots(ent)
%Limites [-2 2]
ent = ent*4-2;
[aux1,aux2]=size(ent);
if(aux1>=aux2)
    n = aux1;
else
    n = aux2;
end
x=0;
for ii=1:n
    x=x+(ent(ii)*1i);
end    
x=ent(1)+ent(2)*1i;    
    y=(1+abs((x^6)-1))^-1;
    z=-y;

end