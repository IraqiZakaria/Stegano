function curvRgb = CSHRMrgbFromCurvature(curvature,maxCurv,forPrint)
% CSHRMrgbFromCurvature Create a color-coded RGB image visualizing the detected curvature.
% 
% Usage (optional parameters are enclosed in angle brackets):
% 
%  curvRgb = CSHRMrgbFromCurvature(curvature,maxCurv,<forPrint>)
% 
% Example:
% 
%  img = double(imread('lena.jpg'));
%  shearletSystem = CSHRMgetContEdgeSystem(size(img,1),size(img,2));
%  [edges,orientations] = CSHRMgetEdges(img,shearletSystem);
%  thinnedEdges = CSHRMthinToLines(edges,0.1);
%  orientations(~thinnedEdges) = -1.0;
%  curv = CSHRMgetCurvatureMex(orientations);
%  imshow(CSHRMrgbFromCurvature(curv,15));
% 
% 
% See also: CSHRMgetEdges, CSHRMgetRidges, CSHRMthinToLines

    if nargin < 3
        forPrint = 0;
    end
    
    if forPrint
        load CSHRMcolormapForPrint.mat;
        colmap = CSHRMcolormapForPrint;            
    else
        colmap = parula(256);
        colmap = [[0,0,0];colmap];
    end
    curvRgb = curvature;
    curvRgb(curvature>maxCurv) = maxCurv;
    curvRgb = curvRgb*255/maxCurv;
    curvRgb(curvature<0) = -1;
    curvRgb = ind2rgb(int16(curvRgb)+1,colmap);    
end

%  Copyright (c) 2016. Rafael Reisenhofer
%
%  Part of CoShREM Toolbox v1.1
%  Built Mon, 11/01/2016
%  This is Copyrighted Material