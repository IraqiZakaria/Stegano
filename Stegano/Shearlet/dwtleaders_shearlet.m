function [leaders,scales,ncount] = dwtleaders_shearlet(img,shearletSystem)

%shearletSystem = CSHRMgetContEdgeSystem(size(img,1),size(img,2));
coeffs = CSHRMsheardec(img,shearletSystem);
scales=shearletSystem.scales();% les J
nShearlets=shearletSystem.nShearlets;% Les L
Pos=shearletSystem.size; % m varie dans pos
wleaders(1).values=[];
pas=floor(nShearlets/numel(scales));

for jj=1:numel(scales)
    if jj==1
        matrice_leaders=zeros(Pos(1,1),Pos(1,2));
        coeffsrelatifs=coeffs(: ,:, (jj-1)*pas+1:jj*pas);
        wleaders(jj).nnallvalues=abs(coeffsrelatifs);
        for x=1:Pos(1,1)
            for y=1:Pos(1,2)
                matrice_leaders(x,y)= max(abs(coeffsrelatifs(x,y,:)));
            end
        end
        
        neighbors=max([matrice_leaders(1:end-2,1:end-2) ;matrice_leaders(2:end-1,1:end-2);matrice_leaders(3:end,1:end-2);matrice_leaders(1:end-2,2:end-2);matrice_leaders(2:end-1,2:end-1);matrice_leaders(3:end,2:end-1);matrice_leaders(1:end-2,3:end);matrice_leaders(2:end-1,3:end);matrice_leaders(3:end,3:end)]);
        idxfinite=isfinte(neighbors);
        leaders(jj)=neighbors(idxfinite);
        ncount(jj)=numel(leaders(jj));
    else
        matrice_leaders=zeros(Pos(1,1),Pos(1,2));
        coeffsrelatifs=coeffs(: ,:, (jj-1)*pas+1:jj*pas);
        wleaders(jj).nnallvalues=abs(coeffsrelatifs);
        for x=1:Pos(1,1)
            for y=1:Pos(1,2)
                matrice_leaders(x,y)= max(abs(coeffsrelatifs(x,y,:)));
            end
        end
        neighbors0=max([neighbors;matrice_leaders(1:end-2,1:end-2) ;matrice_leaders(2:end-1,1:end-2);matrice_leaders(3:end,1:end-2);matrice_leaders(1:end-2,2:end-2);matrice_leaders(2:end-1,2:end-1);matrice_leaders(3:end,2:end-1);matrice_leaders(1:end-2,3:end);matrice_leaders(2:end-1,3:end);matrice_leaders(3:end,3:end)]);
        neighbors=neighbors0;
        idxfinite=isfinte(neighbors);
        leaders(jj)=neighbors(idxfinite);
        ncount(jj)=numel(leaders(jj));
    end
end
end

        
        
        
        
        
        
        
    
    
  
    




























