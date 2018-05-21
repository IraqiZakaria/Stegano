function [coefficient, espace] = cascade_mandelbrot_2d(r, m)
%CASCADE_MANDELBROT_2d création de la liste des 2^r coefficients de la cascade
%canonique de Mandelbrot pour une loi W ln-normale (ln = log2).
%W est d'espérance 1, comme W=2^(-U), où Y suit une loi normale de
%paramètre (m, var), E(W)=2^(-m+(var²/2)log(2)) entraine var²=log(2)*m
var=sqrt(2*m/log(2));
coefficient = zeros(2^r, 2^r);
espace_temp = linspace(0, (1-2^(-r)), (2^r));
espace=cartprod(espace_temp, espace_temp);%on construit l'espace 2-D par produit cart�sien des deux 
coefficient(1, 1)=1;
for i = 1:r
    k_suite = linspace((2^i)-1, 1, 2^(i-1));
    k_init = linspace(2^(i-1), 1, 2^(i-1));
    for j1=1:2^(i-1)
        for j2=1:2^(i-1)
            W=coefficient(k_init(j1), k_init(j2));
            W1=2^-(var*randn()+m);%On construit 4 lois log-normales
            W2=2^-(var*randn()+m);
            W3=2^-(var*randn()+m);
            W4=2^-(var*randn()+m);
            coefficient(k_suite(j1), k_suite(j2))=W*W1;
            coefficient(k_suite(j1)+1, k_suite(j2))=W*W2;
            coefficient(k_suite(j1), k_suite(j2)+1)=W*W3;
            coefficient(k_suite(j1)+1, k_suite(j2)+1)=W*W4;
        end
    end
end

end