%% On essaiezra de créer un fenêtrage
files = dir('*.wav');
filename=files(1).name;
[s,fe]=audioread(filename);

%% Determinons le nombre de bits, fixons la taille à 5 secondes aussi

Nsec=fe;
data=s(1:5*Nsec,:);
A=abs(data)>0;
% scale=floor(log2(max(abs(data(A)))/ min(abs(data(A))))-eps)+1;

R=0.4;
[Signal,scale]=LSB_audio(data(:,1),R);
[dh1,h1,cp1,tauq1] = dwtleader(data(:,1));
plot(h1,dh1,'Color',[0.7,0,0.5]);% 















