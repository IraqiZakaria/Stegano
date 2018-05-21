clear all;close all;

%Test sur donn�es synth�tique
[data,x] = synthfbmcircul(8192,0.5);

%Donn�es r�elles
[s,fe]=audioread('techno.wav');
data=s(10000:10000+8191*2);clear s;

type='uint8';

if strcmp(type,'uint32')==1
    data=uint32((data-min(data))/(max(data)-min(data))*double(intmax(type)));
end;
if strcmp(type,'uint16')==1
    data=uint16((data-min(data))/(max(data)-min(data))*double(intmax(type)));
end;
if strcmp(type,'uint8')==1
    data=uint8((data-min(data))/(max(data)-min(data))*double(intmax(type)));
end;

p=2; %Paramètre p lors du calcul des p-leaders. p=2 convient en général



ondelette_name='Daubechies'; %Correspond à la famille d'ondelette utilisée. Symmlet est bien adaptée.
vanish_mmt=8; %nombre de moments nuls de l'ondelette utilisée. 
%Ne doit pas être trop petit pour pouvoir analyser l'image 
%ni trop grand pour éviter les effets de bords
h0=makeonfilter(ondelette_name, vanish_mmt);

nb_echelle = 6; %Nombre d'échelle pour la décompo en ondelettes, en prendre moins que n
%nb_echelle= min( fix( log2(length(data))), fix(log2(length(data)/(length(h0)+1))) );

decomp=0; %ACtuellement avant stabilisation utilise DxLx1D

spectre=struct();
spectremax=struct();
[X,Y,Xmax,Ymax]=spectre_multifractal(double(data), p, nb_echelle, ondelette_name, vanish_mmt,decomp,1);
spectre(1).X=X;
spectre(1).Y=Y;
spectremax(1).X=Xmax;
spectremax(1).Y=Ymax;
prob=struct();
for b=1:9,
    %stego = double(steg_lsb(data_2d, b/10, 1)).*(hamming(2048)*hamming(2048)');
    [stego,pp] = (steg_lsb(data, b/10, 1,intmax(type)));
    stego=double(stego);
    [X,Y,Xmax,Ymax]=spectre_multifractal(stego, p, nb_echelle, ondelette_name, vanish_mmt,decomp,1);
    spectre(b+1).X=X;
    spectre(b+1).Y=Y;
    prob(b).p=pp;
    spectremax(b+1).X=Xmax;
spectremax(b+1).Y=Ymax;
end;

figure(1);clf;
for b=1:10,
    plot(spectre(b).X,spectre(b).Y);
    hold on;
end;

legend('ori',num2str(prob(1).p),num2str(prob(2).p),num2str(prob(3).p),num2str(prob(4).p),num2str(prob(5).p),num2str(prob(6).p),num2str(prob(7).p),num2str(prob(8).p),num2str(prob(9).p));
figure(2);clf;
for b=1:10,
    plot(spectremax(b).X,spectremax(b).Y);
    hold on;
end;

%legend('ori','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9')
legend('ori',num2str(prob(1).p),num2str(prob(2).p),num2str(prob(3).p),num2str(prob(4).p),num2str(prob(5).p),num2str(prob(6).p),num2str(prob(7).p),num2str(prob(8).p),num2str(prob(9).p));
