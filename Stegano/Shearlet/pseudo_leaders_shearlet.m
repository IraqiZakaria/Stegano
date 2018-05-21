function List=pseudo_leaders_shearlet(coeffs,shearletSystem)

taille=shearletSystem.size();
A=size(coeffs);
scales=A(4);
List=zeros(taille(1),taille(2),scales);
for x=1:taille(1)
    for y=1:taille(2)
        %List(x,y,:)=wavelet_leader_shearlet_version_1(x,y, coeffs,shearletSystem);
    end
end
end
        
        