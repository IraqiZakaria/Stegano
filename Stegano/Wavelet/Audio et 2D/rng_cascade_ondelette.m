function coef = rng_cascade_ondelette(jmax, m, var)
% Chaque coeff d'ondelette est indexe par son echelle j 
% et sa localisation k
% Pour acceder au coeff cjk faire coef(jmax-j).cjk(k) 
% On ne genere que  les derniers coeffs, les autres en sont induits par produit et par signe aleatoire 
coef=struct;
coef(jmax).cjk = zeros(1, 2^jmax);
for k = 1:2^jmax %obtention de la première ligne
    coef(jmax).cjk(k) = 2^-(var*randn()+m); 
end
for j = 1:(jmax-1) % pour chaque ligne
    exposant=2^(jmax-j);
    coef(jmax - j).cjk = zeros(1, exposant);
    for k = 1:exposant %pour chaque ligne, le terme suivant est W*les deux termes directement en dessous.
        w = 2^-(var*randn()+m); 
        coef(jmax-j).cjk(k) = sign(randn()) * w * (coef(jmax-j+1).cjk(2*k)) * (coef(jmax-j+1).cjk((2*k)-1));
    end 
end