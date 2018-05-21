%%Nouveau test Interm�diaire
m=5;
data=cascade_mandelbrot_aux(12,m);
K=max(data);
data=data/K*(256.99);% Vous verrez pourquoi
data=floor(data);
max(data);% On re�oit bien une image

%% Testons notre LSB_1D
R=0.01;
Signal=LSB_1D(data,R);
%plot(data,Signal);
%Nous remarquons d�j� que la droite est trouble � c�t� de zero

%% Le bleu est l'original, l'autre est celui auquel on a appliqu� LSB

[dh1,h1,cp1,tauq1] = dwtleader(data);
[dh2,h2,cp2,tauq2] = dwtleader(Signal);