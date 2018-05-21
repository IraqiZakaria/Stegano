%% Créer une Mandebrot 1D et l'uniformiser (la rendre en entiers de 0 à 256)
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
[Lo,Hi] = wfilters('db6');
[dh1,h1,cp1,tauq1] = dwtleader(data);
[dh2,h2,cp2,tauq2] = dwtleader(Signal);
hold on
plot(h1,dh1,'Color',[0.7,0,0.5]);
plot(h2,dh2,'Color',[0,0.7,0.9]);
xlabel('h'); ylabel('D(h)');
title('Multifractal Spectrum with the value m='+string(m)+'with force d_insertion R='+string(R)) ;
hold off



