function coef_rws = rng_serie_ondelette(jmax, m, var)
% Ici, on obtient les coefs de la décomposition en ondelette de la série
% d'ondelette aléatoire. Il faut reconstruire le signal ensuite
% coef_rws est une structure avec pour attribut coef
% Pour acceder aux coefs de la decomposition en ondelettes coef_rws(j).coef
% et on obtient tout un vecteur
assert(m>(var*sqrt(2*log2(exp(0)))), 'Il faut m>var*(2*ln(2)^(1/2)) pour avoir la convergence')
coef_rws=struct();
for j = 1:jmax
    coef_rws(j).coef=sign(randn(1, 2^j)) .* 2.^-(randn(1, 2^j)*(var/sqrt(j)));
end
end