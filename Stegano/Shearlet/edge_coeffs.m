function [coeffs,ci,cr] = edge_coeffs(img,shearletSystem,minContrast,offset,scalesUsedForPivotSearch)
% CSHRMgetEdges Compute the complex shearlet-based edge measure of a 2D grayscale image.
% 
% Usage (optional parameters are enclosed in angle brackets):
% 
%  [edges,tangentOrientations] = CSHRMgetEdges(img,sys,<minContrast>,<offset>,<scalesUsedForPivotSearch>)
% 
% Input:
%
%                       img: 2D grayscale image.
%                       sys: A complex shearlet system. Can be constructed using CSHRMgetContEdgeSystem.
%               minContrast: (optional) Specifies the minimal contrast between two neighboring regions 
%                            such that an edge will be detected. Default: max(imag(coeffs,[],3))/50;
%                    offset: (optional) Determines the difference in octaves between the scales of even-symmetric shearlets and 
%                            odd-symmetric shearlets used to compute the complex shearlet-based edge measure. Default: 1.
%  scalesUsedForPivotSearch: (optional) Specifies on which scales the pivot shearlet (i.e. the even-symmetric shearlet associated
%                            with the largest coefficient), determining the detected orientation and the normalization constant,
%                            will be searched for. Possible values: 'all','highest','lowest' and every subset of 1:size(coeffs,3).
%                            Default: 'all'.
% 
% Output:
% 
%                edges: The complex shearlet-based edge measure computed each pixel of the analyzed image. The values are ranging
%                       from 0 to 1. 
%  tangentOrientations: Approximations of the local tangent orientations with values ranging from 0? to 180?.
% 
% Example:
% 
%  img = double(imread('lena.jpg'));
%  shearletSystem = CSHRMgetContEdgeSystem(size(img,1),size(img,2));
%  [edges,tangentOrientations] = CSHRMgetEdges(img,shearletSystem);
%  imshow(CSHRMgetOverlay(img,edges));
% 
% 
% See also: CSHRMgetRidges, CSHRMgetContEdgeSystem

% Offset est responsable un peu des bords
    
    if (nargin < 3), minContrast = (max(img(:)) - min(img(:)))/50; end
    if (nargin < 4), offset = 1; end
    if (nargin < 5), scalesUsedForPivotSearch = 'all'; end
    
    coeffs = CSHRMsheardec(img,shearletSystem);
    

    
    nOrientations = (2^shearletSystem.shearLevel+2);
    offset = floor(offset*shearletSystem.scalesPerOctave);
    coeffs = reshape(coeffs,size(coeffs,1),size(coeffs,2),nOrientations,size(coeffs,3)/(nOrientations));
    coeffs = cat(3,coeffs,zeros(size(coeffs)));
    
    %% compute coefficients of second semi-circle, this ensures that the edge is always detected within the darker region
    [~,coneh,~] = CSHRMgetConeOris(shearletSystem.shearLevel);
        
    for ori = 1:(size(coeffs,3)/2)
        if ismember(ori,coneh)
            coeffs(:,:,ori+size(coeffs,3)/2,:) = circshift(-coeffs(:,:,ori,:),[-1,0,0,0]);
        else
            if ori > max(coneh)
                coeffs(:,:,ori+size(coeffs,3)/2,:) = circshift(-coeffs(:,:,ori,:),[0,1,0,0]);
            else
                coeffs(:,:,ori+size(coeffs,3)/2,:) = circshift(-coeffs(:,:,ori,:),[0,-1,0,0]);
            end       
        end            
    end
    nOrientations = 2*nOrientations;
    
    
    ci = imag(coeffs(:,:,:,(offset+1):end));
    cr = abs(real(coeffs(:,:,:,1:(end-offset))));
% 
%     if ischar(scalesUsedForPivotSearch)
%         switch scalesUsedForPivotSearch
%             case 'all'
%                 scalesUsedForPivotSearch = 1:size(ci,4);
%             case 'highest'
%                 scalesUsedForPivotSearch = size(ci,4);
%             case 'lowest'
%                 scalesUsedForPivotSearch = 1;
%             otherwise
%                 warning('scalesUsedForPivotSearch string not recognized, default value "all" is applied');
%                 scalesUsedForPivotSearch = 1:size(ci,4);                    
%         end
%     else
%         scalesUsedForPivotSearch = scalesUsedForPivotSearch - offset;
%         if sum(scalesUsedForPivotSearch < 1) || sum(scalesUsedForPivotSearch > size(ci,4))
%             error('at least one entry in scalesUsedForPivotSearch is smaller than offset or larger than length(shearletSystem.scales)');
%         end
%     end
% 
%     ciPivot = ci(:,:,:,scalesUsedForPivotSearch);
%     [~,maxPivot] = max(reshape(ciPivot,size(ciPivot,1),size(ciPivot,2),size(ciPivot,3)*size(ciPivot,4)),[],3);
%     pivotOris = mod(maxPivot-1,nOrientations)+1;
%     pivotScales = scalesUsedForPivotSearch(fix((maxPivot-1)/nOrientations)+1);    
% 

%     [edges,tangentOrientations] = CSHRMgetEdgesAndTangentOrientationsMex(cr,ci,uint16(pivotOris),uint16(pivotScales),shearletSystem.shearLevel,minContrast);
% 
%     tangentOrientations(tangentOrientations >= 1) = CSHRMmapOrientationsToAngles(tangentOrientations(tangentOrientations >= 1),shearletSystem.shearLevel);
end


%  Copyright (c) 2016. Rafael Reisenhofer
%
%  Part of CoShREM Toolbox v1.1
%  Built Mon, 11/01/2016
%  This is Copyrighted Material