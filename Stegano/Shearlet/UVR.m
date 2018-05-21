function [zetaq,Dq, Hq,Cp]=UVR(List,j)
% Inspired by mfstructfunctions in wavelet toolbox of Stephane Roux
%List=pseudo_leaders_shearlet_quick(coeffs,shearletSystem);
Liste_j=List(:,:,j);

q=-5:5;
q = q(:);
Liste_j=Liste_j(:);


numcoefs = numel(Liste_j);
nq=length(q);
% Create matrices for computation
S = repmat(Liste_j',nq,1);
Q = repmat(q', numcoefs,1)';
% Forming partition function
% Equation 2 p. 3516 (Muzy et al., 1991) 
zkq = S.^Q;
zetaq = log2(mean(zkq,2))';
sumzkq = sum(zkq,2);
% Dq computation is equation 3b, p. 3516 (Muzy et al.) 
% Wendt, p. 34, eq. 2.76
Dq = (sum(zkq .* log2(zkq ./ repmat(sumzkq,1,numcoefs)),2)./ sumzkq + log2(numcoefs))';
% Hq computation is equation 3a, p. 3516
% zkq./sumzkq is R^q(j,k) in Wendt, p. 34 eq. 2.78
Hq = (sum(zkq .* log2(S),2) ./ sumzkq)';
param.cumulant=3;
if ~isempty(param.cumulant)
    % Compute cumulants
    logcoefs = log(Liste_j);
    Cp(1) = mean(logcoefs);
    Cp(2) = mean(logcoefs.^2)-Cp(1)^2;
    Cp(3) = mean(logcoefs.^3) - 3*Cp(2)*Cp(1) - Cp(1)^3 ;
end
end






