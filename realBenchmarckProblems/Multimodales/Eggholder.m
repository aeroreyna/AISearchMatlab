function [z, red] = Eggholder(red)
    %Crossfunc Function
    % [-512 512 -512 512]
    %x* =  (512, 404.2319), f(x*) = 959.64.
    red = red*1024-512;
    y=sum(-(red(2)+47).*sin(sqrt(abs(red(2)+red(1)/2+47)))-red(1).*sin(sqrt(abs(red(1)-(red(2)+47)))),size(red,2));
    z=y;
end