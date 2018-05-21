%%Nouveau test Intermédiaire
m=5;
data=cascade_mandelbrot_aux(12,m);
K=max(data);
data=data/K*(256.99);% Vous verrez pourquoi
data=floor(data);
max(data);% On reçoit bien une image

%% Testons notre LSB_1D
R=0.01;
Signal=LSB_1D(data,R);
%plot(data,Signal);
%Nous remarquons déjà que la droite est trouble à côté de zero

%% Le bleu est l'original, l'autre est celui auquel on a appliqué LSB

[dh1,h1,cp1,tauq1] = dwtleader(data);
[dh2,h2,cp2,tauq2] = dwtleader(Signal);