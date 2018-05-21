%% Essai sur un échantillon de musique de type .mp3
% data: c'est le fichier mp3 inséré en matlab (d'habitude N*2)

R=0.1;

data1=data(:,1);
[Signal,scale]=LSB_audio(data1,R);


[Lo,Hi] = wfilters(char("db"+string(scale)));

figure(1)
hold on
[dh1,h1,cp1,tauq1] = dwtleader(data1);
plot(h1,dh1,'Color',[0.7,0,0.5]);% EN violet, l'image hôte

[Signal,scale]=LSB_audio(data1,R);
[dh2,h2,cp2,tauq2] = dwtleader(Signal);
 plot(h2,dh2,'Color',[0,0.7,0.9]);% En bleu, l'image stéganographiée
xlabel('h'); ylabel('D(h)');
title('Multifractal Spectrum with force d_insertion R='+string(R)) ;

%%
data2=data(:,2);
[Signal,scale]=LSB_audio(data2,R);
[Lo,Hi] = wfilters(char("db"+string(scale)));

figure(2)
hold on
[dh1,h1,cp1,tauq1] = dwtleader(data1);
plot(h1,dh1,'Color',[0.7,0,0.5]);% EN violet, l'image hôte
[dh2,h2,cp2,tauq2] = dwtleader(Signal);
plot(h2,dh2,'Color',[0,0.7,0.9]);% En bleu, l'image stéganographiée
xlabel('h'); ylabel('D(h)');
title('Multifractal Spectrum  2 with force d_insertion R='+string(R)) ;






