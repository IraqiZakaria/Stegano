%% Testons le spectre en fonction de R le taux d'insertion, cette fois pour une seule mandelbrot, on verra apres
Rmax=0.4;
data=cascade_mandelbrot_aux(12,0.01);
K=max(data);
data=data/K*(256.99);% Vous verrez pourquoi
data=floor(data);
hold on
[dh1,h1,cp1,tauq1] = dwtleader(data);
plot(h1,dh1,'Color',[0.7,0,0.5]);
X=linspace(0,Rmax,200);
for i=X
    Signal=LSB_1D(data,R);
    [dh2,h2,cp2,tauq2] = dwtleader(Signal);
    plot(h2,dh2,'Color',[1-i/Rmax,0,1-i/Rmax]);
end

    

