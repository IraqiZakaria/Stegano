%% Essai sur un échantillon de musique de type .wav
drawnow;
R=0.4;

[Signal,scale]=LSB_audio(data,R);
[Lo,Hi] = wfilters(char("db"+string(scale)));

[dh1,h1,cp1,tauq1] = dwtleader(data);
hold on
plot(h1,dh1,'Color',[0.7,0,0.5]);% EN violet, l'image hôte
% ça marche avec un fichier .wav
% Bon il faut applique la méthode LSB, on trouve d'abord l'encodage du .wav
% en utilisant ce qui suit:

[dh2,h2,cp2,tauq2] = dwtleader(Signal);
plot(h2,dh2,'Color',[0,0.7,0.9]);% En bleu, l'image stéganographiée
xlabel('h'); ylabel('D(h)');
title('Multifractal Spectrum with force d_insertion R='+string(R)) ;
hold off