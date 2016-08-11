function y=geccos(x)
[aux1,aux2]=size(x);
if(aux1>=aux2)
    n = aux1;
    x=x';
else
    n = aux2;
end
    y=benchmarks_gecco(x,'f7');
end