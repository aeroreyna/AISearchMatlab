function [ y,x ] = DeJongs5(x)

[aux1,aux2]=size(x);
if(aux1>=aux2)
    n = aux1;
else
    n= aux2;
end
x = x*80-40;
ai0 = [-32, -16, 0, 16, 32];
		a = [
			repmat(ai0, 1, 5);
			reshape(repmat(ai0, 5 , 1), 1, 25);
			];

		tmp = 0;
		for i = 1:25
			tmp2 = 0;
			for j = 1:2
				tmp2 = tmp2 + (x(j) - a(j,i)).^6;
			end
			tmp = tmp + 1 / (i + tmp2);
		end
		y = 1 / (0.002 + tmp);




end