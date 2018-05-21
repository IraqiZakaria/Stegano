function valeur=wavelet_leader_shearlet_version_1(x,y, coeffs,shearletSystem)
% img = double(imread('lena.jpg'));
% shearletSystem = CSHRMgetContEdgeSystem(size(img,1),size(img,2));
% coeffs = coeffs_shearlet(img,shearletSystem);
%Base=coeffs(x,y,:,:);
A=size(coeffs);
scales=A(4);
valeur=zeros(1,scales);
Base=max(abs(coeffs(x,y,:,:)));
depart=eps;
for i =1:scales    
    k=scales+1-i;
    depart=max(Base(:,:,:,k),depart);
    valeur(k)=depart;
end
end
    
    
    


