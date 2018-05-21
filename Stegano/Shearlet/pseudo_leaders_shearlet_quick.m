function List=pseudo_leaders_shearlet_quick(coeffs,shearletSystem)

taille=shearletSystem.size();
A=size(coeffs);
scales=A(4);
List=zeros(taille(1),taille(2),scales);
Base=abs(coeffs(:,:,:,:));


for x=1:taille(1)
    for y=1:taille(2)
        depart=eps;
        
        for j=1:scales
            k=scales+1-j;
            depart=max(depart,max(Base(x,y,:,k)));
            List(x,y,k)=max(depart,max(Base(x,y,:,k)));
        end
            
        %List(x,y,:)=wavelet_leader_shearlet_version_1(x,y, coeffs,shearletSystem);
    end
end
end