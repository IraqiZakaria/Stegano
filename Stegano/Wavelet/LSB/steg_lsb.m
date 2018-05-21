function [Stego,pp] = steg_lsb(cover, p, n,type)
%steg_lsb prend trois paramètres:
%	- data correspond à la donnée d'un signal sous la forme d'une matrice
%	- proba correspond à la probabilité de modifier un point
%	- n est la force de modification. On considère qu'il n'y a que 256 valeurs disponibles (0~255). Pour chaque point (pixel par ex) modifiée, on change la valeur des f derniers bits codant la valeur du point.


%Cela simule une insertion d'un message en modifiant aléatoirement des pixels d'une image en changeant les f derniers bits. 
[lx, ly]=size(cover);
ind=randperm(lx*ly);
Hidden=zeros(1,lx*ly);
ind=ind(1:round(p*lx*ly));
Hidden=randi([0 (2^n)-1],1,length(ind));

if type==intmax('uint32')
    cover=uint32(cover(:))';
    Stego=cover;
    cover(ind)=bitand(cover(ind), bitcmp(2^n - 1,'uint32')); %met les n bit de poids faible à 0
    Stego(ind) = uint32(bitor(cover(ind) , uint32(Hidden))); %insertion du bit par opération de OU
end;
if type==intmax('uint8')
    cover=uint8(cover(:))';
    Stego=cover;
    cover(ind)=bitand(cover(ind), bitcmp(2^n - 1,'uint8'));
    Stego(ind) = uint8(bitor(cover(ind) , uint8(Hidden))); %insertion du bit par opération de OU
end;
if type==intmax('uint16')
    cover=uint16(cover(:))';
    Stego=cover;
    cover(ind)=bitand(cover(ind), bitcmp(2^n - 1,'uint16'));
    Stego(ind) = uint16(bitor(cover(ind) , uint16(Hidden))); %insertion du bit par opération de OU

end;


Stego=(reshape(Stego,lx,ly));

pp=sum(abs(double(cover)~=double(Stego)))/length(Stego);
%max(abs(double(cover)-double(Stego)))
%cover(ind)=bitand(cover(ind), bitcmp(2^n - 1,'uint8')); %met les n bit de poids faible à 0
%Hidden= bitshift(Hidden, n - 8))); % transforme valeur < 'utint8'/2 ->0 et valeur >utin8 ->1
%Stego = uint8(bitor(cover(ind) , Hidden)); %insertion du bit par opération de OU

%Stego = uint8(bitor(bitand(cover, bitcmp(2^n - 1,'uint8')) , bitshift(Hidden, n - 8)));

% for x = 1:lx
%     for y=1:ly
%         rn=rand();
%         if rn<p
%             data(x, y)=change(data(x, y), f);
%         end
%     end
% end