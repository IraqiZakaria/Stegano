function thinnedEdges = CSHRMthinToLines(detectedEdgesOrRidges,thinningThreshold)
% CSHRMthinToLines Threshold and thin the results CSHRMgetEdges and CSHRMgetRidges.
% 
% Usage:
% 
%  thinnedEdges = CSHRMthinToLines(detectedEdgesOrRidges,thinningThreshold)
% 
% Example:
% 
%  img = double(imread('lena.jpg'));
%  shearletSystem = CSHRMgetContEdgeSystem(size(img,1),size(img,2));
%  edges = CSHRMgetEdges(img,shearletSystem);
%  thinnedEdges = CSHRMthinToLines(edges,0.1);
%  imshow(CSHRMgetOverlay(img,thinnedEdges));
% 
% 
% See also: CSHRMgetEdges, CSHRMgetRidges 
    thinnedEdges = bwmorph(detectedEdgesOrRidges > thinningThreshold,'thin',Inf);
end

%  Copyright (c) 2016. Rafael Reisenhofer
%
%  Part of CoShREM Toolbox v1.1
%  Built Mon, 11/01/2016
%  This is Copyrighted Material