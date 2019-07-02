function [y,x]=Twopeaktrap1D(x)

%[0 20]
x = x*20;
if (x<=15)
    y=-(160/15)*(15-x);
else
    y=-(200/5)*(x-15);    
end