function oriRgb = CSHRMrgbFromOrientations(orientations,forPrint)
% CSHRMrgbFromOrientations Create a color-coded RGB image visualizing detected tangent orientations.
% 
% Usage (optional parameters are enclosed in angle brackets):
% 
%  oriRgb = CSHRMrgbFromOrientations(orientations,<forPrint>)
% 
% Example:
% 
%  img = double(imread('lena.jpg'));
%  shearletSystem = CSHRMgetContEdgeSystem(size(img,1),size(img,2));
%  [edges,orientations] = CSHRMgetEdges(img,shearletSystem);
%  thinnedEdges = CSHRMthinToLines(edges,0.1);
%  orientations(~thinnedEdges) = -1.0;
%  imshow(CSHRMrgbFromOrientations(orientations));
% 
% 
% See also: CSHRMgetEdges, CSHRMgetRidges, CSHRMthinToLines
    
    if nargin < 2
        forPrint = 0;
    end
    if forPrint    
        oriRgbHelp = 1-(0.1+0.8*abs(orientations-90)./90);
        oriRgbHelp(orientations< 0) = 1;
        oriRgb = cat(3,abs(orientations./180),ones(size(orientations)),oriRgbHelp);
        oriRgb = hsl2rgb(oriRgb);
    else
        ncmap = 181;
        cmap = squeeze(hsv2rgb(cat(3,0:1/(ncmap-1):1,ones(1,ncmap),ones(1,ncmap))));
        cmap = [[0,0,0];cmap];
        oriRgb = ind2rgb(int16(orientations)+1,cmap);
    end
end

%  Copyright (c) 2016. Rafael Reisenhofer
%
%  Part of CoShREM Toolbox v1.1
%  Built Mon, 11/01/2016
%  This is Copyrighted Material