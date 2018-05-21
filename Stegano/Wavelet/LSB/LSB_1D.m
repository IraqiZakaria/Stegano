function Signal=LSB_1D(data,R)
% data : données initiales, R force d'insertion donné entre 0 et 1
% Prmière ébauche de code avec une LSB basique
N=length(data);
Nvar=2*floor(N*R/2);
X=randperm(N,Nvar);
Cut=floor(Nvar/2);
for i=X(1:Cut)
    data(i)=data(i)-mod(data(i),2);
end
for i=X(Cut+1:end)
    if mod(data(i),2)==0 & data(i)<256
        data(i)=data(i)+1;
    end
end
Signal=data;
end

    
