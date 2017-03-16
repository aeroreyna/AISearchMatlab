function [y,x]=guichi_f2(x)

    n=2;
    
    s1=0;
    s2=0;
    x = x*100-50;
    for ii=1:n-1
        s1=s1+( ((y_guichi(x(ii))-1)^2) * ( 1+ (10*sin(y_guichi(x(ii+1)))) + ((y_guichi(x(ii)-1))^2) ));
        s2=s2+( u_guichi(x(ii),10,100,4) );
    end
    
    y=((pi/n)*( 10*sin(pi*y_guichi(x(1))) + s1 ))+s2;

    

end

function valo1=y_guichi(x)
    valo1=1+(x+1)/4;
end


function valo=u_guichi(x,a,k,m)
    valo=0;
    if (x>a)
        valo=k*((x-a)^m);
    end
    if (x<a)&&(x>-a)
        valo=0;
    end
    if (x>-a)
        valo=k*((-x-a)^m);
    end
end