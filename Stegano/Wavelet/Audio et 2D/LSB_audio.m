function [Signal,scale]=LSB_audio(data,R)
% data is the audio file that we will load, I used a .wav file.
% R is the insertion factor, as defined in "Hiding Text in Audio Using LSB Based Steganography
% K.P.Adhiya Swati A. Patil
% CSE Dept. SSBT’s COET Bambhori,Jalgaon,Bambhori,India" 
% Bon il faut appliquer la méthode LSB, on trouve d'abord l'encodage du .wav
% en utilisant ce qui suit:

C=abs(data);
B=C>eps;
N=max(C(B))/min(C(B));% On supposera que c'est des audios non uniformémen nuls..
% Là on détermine le type d'encodage
% scale=floor(log2(log2(N))-eps)+1:
scale=floor(log2(N)-eps)+1;
data2=data*2^scale;
% We detected the real scale( the minimum that is not equal to 0 is 1
% We can apply the LSB method now, like done in the LSB_1D
taille=length(data2);
Nvar=2*floor(taille*R/2);
X=randperm(taille,Nvar);
Cut=floor(Nvar/2);
for i=X(1:Cut)
    data2(i)=data2(i)-mod(data2(i),2);
end
for i=X(Cut+1:end)
    if mod(data2(i),2)==0 & data2(i)<2^scale
        data2(i)=data2(i)+1;
    end
end
Signal=data2/(2^scale);

end














    
    






