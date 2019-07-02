function y=guichi_f1(x)

    n=2;
    s1=0;
    s2=0;
    
    for ii=1:n
        s1=s1+( ((x(ii)-1)^2)*(1+(sin(3*pi*x(ii)+1))^2) );
        s2=s2+u_guichi(x(ii),5,100,4);
    end
    y=0.1*((sin(3*pi*x(1)))^2+s1+s2+( ((x(n)-1)^2)*(1+(sin(2*pi*x(n)))^2) ));


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