function contShearletSystem = CSHRMgetContEdgeSystem(rows,cols,waveletEffSupp,gaussianEffSupp,scalesPerOctave,shearLevel,alpha,scales)
% CSHRMgetContEdgeSystem Construct a system of complex-valued shearlets to detect edges in a 2D grayscale image.
% 
% Usage (optional parameters are enclosed in angle brackets):
% 
%  contShearletSystem = CSHRMgetContEdgeSystem(rows,cols,<waveletEffSupp>,<gaussianEffSupp>,<scalesPerOctave>,<shearLevel>,<alpha>,<scales>)
% 
% Example:
% 
%  img = double(imread('barbara.jpg'));
%  shearletSystem = CSHRMgetContEdgeSystem(size(img,1),size(img,2));
%  edges = CSHRMgetEdges(img,shearletSystem);
%  imshow(CSHRMgetOverlay(img,edges));
% 
% See also: CSHRMgetEdges
    if (nargin < 3), waveletEffSupp = min([rows,cols])/7; end
    if (nargin < 4), gaussianEffSupp = min([rows,cols])/20; end
    if (nargin < 5), scalesPerOctave = 2; end
    if (nargin < 6), shearLevel = 3; end
    if (nargin < 7), alpha = 0.8; end
    if (nargin < 8), scales = 1:(scalesPerOctave*3.5); end
    
    nOris = 2^shearLevel+2;
    nShearlets = length(scales)*nOris;
    shearlets = zeros(rows,cols,nShearlets);
    [~,coneh,~] = CSHRMgetConeOris(shearLevel);



    for j = 1:length(scales)
        scale = scales(j);
        for ori = 1:nOris        


            shearlet = CSHRMgetContShearlet(rows,cols,waveletEffSupp,gaussianEffSupp,scalesPerOctave,shearLevel,alpha,1,scale,ori);

            shearlet = real(fftshift(ifft2(ifftshift(shearlet))));

            if ismember(ori,coneh)
                shearlet =  hilbert(-shearlet);
                shearlet = circshift(shearlet,[-1,0]);

            else
                if ori > max(coneh)
                    shearlet = hilbert(-shearlet')';
                    shearlet = circshift(shearlet,[0,1]);
                else
                    shearlet = hilbert(shearlet')';
                end
            end
            if ori == 1
                normalizationFactor = abs(sum(sum(imag(shearlet(:,1:(floor(end/2)))))));
            end   
            shearlet = shearlet/normalizationFactor;
            
            shearlets(:,:,nOris*(j-1)+ori) = fftshift(fft2(ifftshift(shearlet)));
        end
    end
    contShearletSystem = struct('shearlets',shearlets,'size',[rows,cols],'waveletEffSupp',waveletEffSupp,'gaussianEffSupp',gaussianEffSupp,'scalesPerOctave',scalesPerOctave,'shearLevel',shearLevel,'scales',scales,'nShearlets',nShearlets,'alpha',alpha,'detectRidges',0);
end

%  Copyright (c) 2016. Rafael Reisenhofer
%
%  Part of CoShREM Toolbox v1.1
%  Built Mon, 11/01/2016
%  This is Copyrighted Material