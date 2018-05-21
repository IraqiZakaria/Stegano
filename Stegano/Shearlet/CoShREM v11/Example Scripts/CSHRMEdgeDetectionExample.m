%Example of edge detection using the complex shearlet-based edge measure.

img = imread('churchandcapitol.bmp');
img = double(rgb2gray(img));


%% system parameters
rows = size(img,1);
cols = size(img,2);
waveletEffSupp = 70;
gaussianEffSupp = 25;
scalesPerOctave = 2;
shearLevel = 3; %i.e. 2^shearLevel different orientations on each scale
alpha = 0.5;
octaves = 3.5;

computeSys = 1;

%% edge detection parameters
minimalContrast = 4; 
offset = 1; %in octaves

%% thinning parameters
thinningThreshold = 0.1;

%% edge detection
if computeSys
    complexShearletSystem = CSHRMgetContEdgeSystem(rows,cols,waveletEffSupp,gaussianEffSupp,scalesPerOctave,shearLevel,alpha,1:floor(octaves*scalesPerOctave));
end;

[edges,orientations] = CSHRMgetEdges(img,complexShearletSystem,minimalContrast,offset);

edgesThinned = CSHRMthinToLines(edges,thinningThreshold);
orientationsThinned = orientations;
orientationsThinned(~edgesThinned) = -1;
oriRgb = CSHRMrgbFromOrientations(orientationsThinned);
overlayRgb = CSHRMgetOverlay(img,edges);


figure;
image(oriRgb);
axis equal;
axis tight;
axis off;
title('Thinned tangent orientations');

figure;
image(overlayRgb);
axis equal;
axis tight;
axis off;
title('Overlay');

figure;
subplot(1,2,1);
imagesc(img);
axis equal;
axis tight;
title('Original image');

axis off;
colormap gray;
subplot(1,2,2);
imagesc(edges);
axis equal;
axis tight;
axis off;
title('Edge measure');


%  Copyright (c) 2016. Rafael Reisenhofer
%
%  Part of CoShREM Toolbox v1.1
%  Built Mon, 11/01/2016
%  This is Copyrighted Material
