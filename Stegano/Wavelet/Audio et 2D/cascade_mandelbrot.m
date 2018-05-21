function cascade_mandelbrot(r, m)
%Permet d'obtenir la courbe en 1D d'une cascade de mandelbrot 
[X, Y]=cascade_mandelbrot_aux(r, m);
plot(Y, X);
end