function [coefficient, espace] = cascade_mandelbrot_aux(r, m)
%CASCADE_MANDELBROT création de la liste des 2^r coefficients de la cascade
%canonique de Mandelbrot pour une loi W ln-normale (ln = log2).
%W est d'espérance 1, comme W=2^(-U), où Y suit une loi normale de
%paramètre (m, var), E(W)=2^(-m+(var²/2)log(2)) entraine var²=log(2)*m
var=sqrt(2*m/log(2));
coefficient = zeros(1, 2^r);
espace = linspace(0, (1-2^(-r)), (2^r));%g�n�re 2^r^points entre 0 et (1-2^(-r))
coefficient(1)=1;
for i = 1:r
    k_suite = linspace((2^i)-1, 1, 2^(i-1));
    k_init = linspace(2^(i-1), 1, 2^(i-1));
    for j=1:2^(i-1)
        W=coefficient(k_init(j));
        W_temp1=2^-(var*randn()+m);%La loi log-normale 
        W_temp2=2^-(var*randn()+m);
        coefficient(k_suite(j))=W*W_temp1;
        coefficient(k_suite(j)+1)=W*W_temp2;
    end
end
end