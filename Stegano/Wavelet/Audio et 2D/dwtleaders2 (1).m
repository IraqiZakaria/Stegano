function [leaders,scales,ncount] = dwtleaders2(x,Lo,Hi)
% Nous allons raisonner sur comment judicieusement enlever les bords.
% Commenï¿½ons d'abord par chercher les coefficients approximï¿½s avec un
% filtre donnï¿½, si le filtre n'est pas spï¿½cifiï¿½, nous utiliserons un filtre
% gï¿½nï¿½rique.
% Quand x reprï¿½sente une image de dimensions mxn, alors mï¿½me la matrice des
% coefficients et les matrices de dï¿½tail sont des matrices de size% =int(size(x)/2), mais nous, on ne veut pas ï¿½a




% -------------------------------------------------------------%
% Fonctions utilisï¿½es C.F matlab wavelet toolbox
%--------------------------------------------------------------%
% dwt2 : dï¿½termine les coefficients d'ondelette une seule fois,c.ad
% effectue une seule itï¿½ration, qui donne l'approximation, et les
% coefficients de dï¿½tail. Comment je vais enlever les bords.

% Reraisonnons comme avant sur dwtleaders

% Notre passe-bas: Lo,Notre passe-haut:Hi
nwav = numel(Lo);
nvalid = nwav-1;



% Shifts for wavelet and scaling coefficients
x0=2;
x0Appro=2*(nwav/2);
% Initialize to empty
wleaders(1).values = [];


% Nlevels A DETERMINER Je Supposerais que je travaille avec des images
% carrï¿½es. En fait, pas besoin
N=size(x);
n1=double(N(1));

n2=double(N(2));
% n1
% n2
% fix(log2(n1/(nwav+1)))
% fix(log2(n1))
% fix(log2(n2/(nwav+1)))
% fix(log2(n2))
Nlevels=min([fix(log2(n1/(nwav+1))),fix(log2(n1)),fix(log2(n2/(nwav+1))),fix(log2(n2))]);
% This makes sure we have at least three levels but due to boundary effects
% we still may not have enough leaders at the end, so we will check again
% before returning
if Nlevels < 3
   error(message('Wavelet:mfa:InsufficientLeaders'));
end



% Begin transform
for jj = 1:Nlevels
    nJ=size(x);
    nj1=nJ(1);
    nj2=nJ(2);
    nj=max(nj1,nj2);% ????? Sï¿½r, bon ï¿½a peut le faire je pense
    
    [CA,CH,CV,CD] = dwt2(x,Lo,Hi);
    approxcoefs=CA;
    detailsH=CH;
    detailsV=CV;
    detailsD=CD;
    % Set any NaNs equal to Infs
    approxcoefs(isnan(approxcoefs)) = Inf;
    detailsH(isnan(detailsH)) = Inf;
    detailsV(isnan(detailsV)) = Inf;
    detailsD(isnan(detailsD)) = Inf;
    % Remove boundary coefficients from scaling and wavelet coefficients
    % La c(est pas si facile de l'imaginer, essayons d'abord pour
    % voir.
    
    % PROBLEME SUR LE NJ
        % URGENT Modifier cette partie car j'enlï¿½ve pas le bord mais tout le reste
    % Ce dont on a parlÃ© j'espere que Ã§a marche
    approxcoefs(:,[1:nvalid-1 end-nvalid+1:end])=Inf;
    approxcoefs([1:nvalid-1 end-nvalid+1:end],:)=Inf;
    detailsH([1:nvalid-1 end-nvalid+1:end],:)=Inf;
    detailsH(:,[1:nvalid-1 end-nvalid+1:end])=Inf;
    detailsD([1:nvalid-1 end-nvalid+1:end],:)=Inf;
    detailsD(:,[1:nvalid-1 end-nvalid+1:end])=Inf;
    detailsV([1:nvalid-1 end-nvalid+1:end],:)=Inf;
    detailsV(:,[1:nvalid-1 end-nvalid+1:end])=Inf;
    
    
    
     

    
    % Je pense que ï¿½a reste valide quand meme, vu comment les coeffs sont
    % faits, mais bon, le nj me fait hï¿½siter
    x = approxcoefs;
    % Use L1 normalization of coefficients
    AbscoefsH = abs(detailsH)*2^(-jj/2);
    AbscoefsV = abs(detailsV)*2^(-jj/2);
    AbscoefsD = abs(detailsD)*2^(-jj/2);
%      AbscoefsD
    % Bon j'essaie le truc quand meme
    
    
    
    
    % Determine wavelet leaders
    if jj == 1
        %compute and store leaders
        wleaders(jj).nnallvaluesD = AbscoefsD; %#ok<*AGROW> % Des matrices n/2xn/2
        wleaders(jj).nnallvaluesV = AbscoefsV;
        wleaders(jj).nnallvaluesH = AbscoefsH;
%         AbscoefsD
%         find(AbscoefsV<Inf)
        
        % Form neighbors as a matrix. The leaders are obtained
        % by taking the maximum over the columns
%          neighborsD = max([AbscoefsD(1:end-2) ; AbscoefsD(2:end-1); AbscoefsD(3:end)]);
% RedÃ©finissons les neighbors:
     % Il est là le problème
        C=AbscoefsD;           
        % Debut de l operation delicate
        
        neighbors=max(C([1:end-2],[1:end-2]),C([1:end-2],[2:end-1]));
        neighbors=max(neighbors,C([1:end-2],[3:end]));
        neighbors=max(neighbors,C([2:end-1],[1:end-2]));
        neighbors=max(neighbors,C([2:end-1],[2:end-1]));
        neighbors=max(neighbors,C([2:end-1],[3:end]));
        neighbors=max(neighbors,C([3:end],[1:end-2]));
        neighbors=max(neighbors,C([3:end],[2:end-1]));
        neighbors=max(neighbors,C([3:end],[3:end]));
        
        neighborsD=neighbors;
        % On reitere le meme procede pour V et H
        
        C=AbscoefsH;           
      
        
        neighbors=max(C([1:end-2],[1:end-2]),C([1:end-2],[2:end-1]));
        neighbors=max(neighbors,C([1:end-2],[3:end]));
        neighbors=max(neighbors,C([2:end-1],[1:end-2]));
        neighbors=max(neighbors,C([2:end-1],[2:end-1]));
        neighbors=max(neighbors,C([2:end-1],[3:end]));
        neighbors=max(neighbors,C([3:end],[1:end-2]));
        neighbors=max(neighbors,C([3:end],[2:end-1]));
        neighbors=max(neighbors,C([3:end],[3:end]));
        
        neighborsH=neighbors;
        
        C=AbscoefsV;           
       
        
        neighbors=max(C([1:end-2],[1:end-2]),C([1:end-2],[2:end-1]));
        neighbors=max(neighbors,C([1:end-2],[3:end]));
        neighbors=max(neighbors,C([2:end-1],[1:end-2]));
        neighbors=max(neighbors,C([2:end-1],[2:end-1]));
        neighbors=max(neighbors,C([2:end-1],[3:end]));
        neighbors=max(neighbors,C([3:end],[1:end-2]));
        neighbors=max(neighbors,C([3:end],[2:end-1]));
        neighbors=max(neighbors,C([3:end],[3:end]));
        
        neighborsV=neighbors;
        
        
        
        neighbors=max(neighborsD,neighborsH);
        neighbors=max(neighbors,neighborsV);
        
      
        % Bon, faut reflechir en 2D Lï¿½... en vrai les lignes de haut
        % paraissent logiques mais la maniï¿½re de coder initiale me paraï¿½t bizarre...
        idxfinite = isfinite(neighbors);
        % Determine leaders
        leaders{jj} = neighbors(idxfinite);
        % How many wavelet leaders do we have at a given level
        ncount(jj) = numel(leaders{jj});
        % Je pense que jusqu'ici, c'est okay.
        
    else
        ncD = floor(size(wleaders(jj-1).nnallvaluesD)/2);
        ncDx=ncD(1);ncDy=ncD(2);
        
        ncV = floor(size(wleaders(jj-1).nnallvaluesV)/2);
        ncH = floor(size(wleaders(jj-1).nnallvaluesH)/2);
        ncVx=ncV(1);ncVy=ncV(2);ncHx=ncH(1);ncHy=ncH(2);
%         ncD
%         ncV
%         ncH
 
% La on a aussi un probleme,comment le résoudre... ?

        % Ce qu'il retourne, c'est une liste de taille ncD de taille x/2
        % plus petite que la taille de la liste précédente
        
        
        wleaders(jj).nnallvaluesD = max(AbscoefsD([1:ncDx],[1:ncDy]), wleaders(jj-1).nnallvaluesD([1:2:2*ncDx],[1:2:2*ncDy]));
        wleaders(jj).nnallvaluesD=max(wleaders(jj).nnallvaluesD,wleaders(jj-1).nnallvaluesD([1:2:2*ncDx],[2:2:2*ncDy]));
        wleaders(jj).nnallvaluesD=max(wleaders(jj).nnallvaluesD,wleaders(jj-1).nnallvaluesD([2:2:2*ncDx],[1:2:2*ncDy]));
        wleaders(jj).nnallvaluesD=max(wleaders(jj).nnallvaluesD,wleaders(jj-1).nnallvaluesD([2:2:2*ncDx],[2:2:2*ncDy]));
        
        neighborsD=max(wleaders(jj).nnallvaluesD([1:end-2],[1:end-2]) , wleaders(jj).nnallvaluesD([1:end-2],[2:end-1]));
        neighborsD=max(neighborsD,wleaders(jj).nnallvaluesD([1:end-2],[3:end]));
        neighborsD=max(neighborsD,wleaders(jj).nnallvaluesD([2:end-1],[1:end-2]));
        neighborsD=max(neighborsD,wleaders(jj).nnallvaluesD([2:end-1],[2:end-1]));
        neighborsD=max(neighborsD,wleaders(jj).nnallvaluesD([2:end-1],[3:end]));
        neighborsD=max(neighborsD,wleaders(jj).nnallvaluesD([3:end],[1:end-2]));
        neighborsD=max(neighborsD,wleaders(jj).nnallvaluesD([3:end],[2:end-1]));
        neighborsD=max(neighborsD,wleaders(jj).nnallvaluesD([3:end],[3:end]));
        
        
        
        wleaders(jj).nnallvaluesH = max(AbscoefsH([1:ncHx],[1:ncHy]), wleaders(jj-1).nnallvaluesH([1:2:2*ncHx],[1:2:2*ncHy]));
        wleaders(jj).nnallvaluesH=max(wleaders(jj).nnallvaluesH,wleaders(jj-1).nnallvaluesH([1:2:2*ncHx],[2:2:2*ncHy]));
        wleaders(jj).nnallvaluesH=max(wleaders(jj).nnallvaluesH,wleaders(jj-1).nnallvaluesH([2:2:2*ncHx],[1:2:2*ncHy]));
        wleaders(jj).nnallvaluesH=max(wleaders(jj).nnallvaluesH,wleaders(jj-1).nnallvaluesH([2:2:2*ncHx],[2:2:2*ncHy]));
        
        neighborsH=max(wleaders(jj).nnallvaluesH([1:end-2],[1:end-2]) , wleaders(jj).nnallvaluesH([1:end-2],[2:end-1]));
        neighborsH=max(neighborsH,wleaders(jj).nnallvaluesH([1:end-2],[3:end]));
        neighborsH=max(neighborsH,wleaders(jj).nnallvaluesH([2:end-1],[1:end-2]));
        neighborsH=max(neighborsH,wleaders(jj).nnallvaluesH([2:end-1],[2:end-1]));
        neighborsH=max(neighborsH,wleaders(jj).nnallvaluesH([2:end-1],[3:end]));
        neighborsH=max(neighborsH,wleaders(jj).nnallvaluesH([3:end],[1:end-2]));
        neighborsH=max(neighborsH,wleaders(jj).nnallvaluesH([3:end],[2:end-1]));
        neighborsH=max(neighborsH,wleaders(jj).nnallvaluesH([3:end],[3:end]));
        
        
        
        
        
        wleaders(jj).nnallvaluesV = max(AbscoefsV([1:ncVx],[1:ncVy]), wleaders(jj-1).nnallvaluesV([1:2:2*ncVx],[1:2:2*ncVy]));
        wleaders(jj).nnallvaluesV=max(wleaders(jj).nnallvaluesV,wleaders(jj-1).nnallvaluesV([1:2:2*ncVx],[2:2:2*ncVy]));
        wleaders(jj).nnallvaluesV=max(wleaders(jj).nnallvaluesV,wleaders(jj-1).nnallvaluesV([2:2:2*ncVx],[1:2:2*ncVy]));
        wleaders(jj).nnallvaluesV=max(wleaders(jj).nnallvaluesV,wleaders(jj-1).nnallvaluesV([2:2:2*ncVx],[2:2:2*ncVy]));
        
        neighborsV=max(wleaders(jj).nnallvaluesV([1:end-2],[1:end-2]) , wleaders(jj).nnallvaluesV([1:end-2],[2:end-1]));
        neighborsV=max(neighborsV,wleaders(jj).nnallvaluesV([1:end-2],[3:end]));
        neighborsV=max(neighborsV,wleaders(jj).nnallvaluesV([2:end-1],[1:end-2]));
        neighborsV=max(neighborsV,wleaders(jj).nnallvaluesV([2:end-1],[2:end-1]));
        neighborsV=max(neighborsV,wleaders(jj).nnallvaluesV([2:end-1],[3:end]));
        neighborsV=max(neighborsV,wleaders(jj).nnallvaluesV([3:end],[1:end-2]));
        neighborsV=max(neighborsV,wleaders(jj).nnallvaluesV([3:end],[2:end-1]));
        neighborsV=max(neighborsV,wleaders(jj).nnallvaluesV([3:end],[3:end]));
        
        neighbors=max(neighborsD  , neighborsH );
        neighbors=max(neighbors,neighborsV);
        
        
        
        
        
        
%         wleaders(jj).nnallvaluesD = max([AbscoefsD([1:ncDx],[1:ncDy]); wleaders(jj-1).nnallvaluesD([1:2:2*ncDx],[1:2:2*ncDy]);wleaders(jj-1).nnallvaluesD([1:2:2*ncDx],[2:2:2*ncDy]);wleaders(jj-1).nnallvaluesD([2:2:2*ncDx],[1:2:2*ncDy]) ;wleaders(jj-1).nnallvaluesD([2:2:2*ncDx],[2:2:2*ncDy])]);
        
        
%         neighborsD =  max([wleaders(jj).nnallvaluesD([1:end-2],[1:end-2]) ; wleaders(jj).nnallvaluesD([1:end-2],[2:end-1]) ;wleaders(jj).nnallvaluesD([1:end-2],[3:end]) ;wleaders(jj).nnallvaluesD([2:end-1],[1:end-2]) ;wleaders(jj).nnallvaluesD([2:end-1],[2:end-1]) ;wleaders(jj).nnallvaluesD([2:end-1],[3:end]) ;wleaders(jj).nnallvaluesD([3:end],[1:end-2]) ;wleaders(jj).nnallvaluesD([3:end],[2:end-1]);wleaders(jj).nnallvaluesD([3:end],[3:end])]);  
        
        
        
%         wleaders(jj).nnallvaluesH = max([AbscoefsH([1:ncHx],[1:ncHy]); wleaders(jj-1).nnallvaluesH([1:2:2*ncHx],[1:2:2*ncHy]);wleaders(jj-1).nnallvaluesH([1:2:2*ncHx],[2:2:2*ncHy]);wleaders(jj-1).nnallvaluesH([2:2:2*ncHx],[1:2:2*ncHy]) ;wleaders(jj-1).nnallvaluesD([2:2:2*ncHx],[2:2:2*ncHy])]);
%         
%         
%         neighborsH =  max([wleaders(jj).nnallvaluesH([1:end-2],[1:end-2]) ; wleaders(jj).nnallvaluesH([1:end-2],[2:end-1]) ;wleaders(jj).nnallvaluesH([1:end-2],[3:end]) ;wleaders(jj).nnallvaluesH([2:end-1],[1:end-2]) ;wleaders(jj).nnallvaluesH([2:end-1],[2:end-1]) ;wleaders(jj).nnallvaluesH([2:end-1],[3:end]) ;wleaders(jj).nnallvaluesH([3:end],[1:end-2]) ;wleaders(jj).nnallvaluesH([3:end],[2:end-1]);wleaders(jj).nnallvaluesH([3:end],[3:end])]);  
        
        
        
%         wleaders(jj).nnallvaluesV = max([AbscoefsV([1:ncVx],[1:ncVy]); wleaders(jj-1).nnallvaluesV([1:2:2*ncVx],[1:2:2*ncVy]);wleaders(jj-1).nnallvaluesV([1:2:2*ncVx],[2:2:2*ncVy]);wleaders(jj-1).nnallvaluesV([2:2:2*ncVx],[1:2:2*ncVy]) ;wleaders(jj-1).nnallvaluesV([2:2:2*ncVx],[2:2:2*ncVy])]);
%         
%         
%         neighborsV =  max([wleaders(jj).nnallvaluesV([1:end-2],[1:end-2]) ; wleaders(jj).nnallvaluesV([1:end-2],[2:end-1]) ;wleaders(jj).nnallvaluesV([1:end-2],[3:end]) ;wleaders(jj).nnallvaluesV([2:end-1],[1:end-2]) ;wleaders(jj).nnallvaluesV([2:end-1],[2:end-1]) ;wleaders(jj).nnallvaluesD([2:end-1],[3:end]) ;wleaders(jj).nnallvaluesV([3:end],[1:end-2]) ;wleaders(jj).nnallvaluesV([3:end],[2:end-1]);wleaders(jj).nnallvaluesV([3:end],[3:end])]);  
        
%         
%         
%         wleaders(jj).nnallvaluesH = max([AbscoefsH(1:ncH); wleaders(jj-1).nnallvaluesH(1:2:2*ncH); wleaders(jj-1).nnallvaluesH(2:2:2*ncH)]);
%         neighborsH =  max([wleaders(jj).nnallvaluesH(1:end-2) ; wleaders(jj).nnallvaluesH(2:end-1); wleaders(jj).nnallvaluesH(3:end)]);
%         
%         wleaders(jj).nnallvaluesV =  max([Abscoefs(1:ncV); wleadersV(jj-1).nnallvaluesV(1:2:2*ncV); wleaders(jj-1).nnallvaluesV(2:2:2*ncV)]);
%         neighborsV =max([wleaders(jj).nnallvaluesV(1:end-2) ; wleaders(jj).nnallvaluesV(2:end-1); wleaders(jj).nnallvaluesV(3:end)]);
        
        
%         neighbors=max([neighborsD ; neighborsH ;neighborsV]);
        idxfinite = isfinite(neighbors);
        leaders{jj} = neighbors(idxfinite);
        ncount(jj) = numel(leaders{jj});
        
        
    end
end    
        
scales = 2.^(1:Nlevels);

