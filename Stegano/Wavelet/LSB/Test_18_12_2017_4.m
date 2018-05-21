%% Donne toutes es figures en même temps, nécessite Test 18_12_207_3

%Valeur maximale et minimale et nombre de points d'essai de linsertion
Rmax=0.1;
Rmin=0.01;
NR=5;
%Valeur maximale et minimale et nombre de points d'essai de M
Mmax=0.5;
Mmin=0.1;
NM=15;
RR=linspace(Rmin,Rmax,NR);
MM=linspace(Mmin,Mmax,NM);
for i=1:NR
    for j=1:NM
        figure(i*NR+j)
        R=RR(i);
        m=MM(j);
        for k=1:10
            Test_18_12_2017_3
        end
    end
end
        