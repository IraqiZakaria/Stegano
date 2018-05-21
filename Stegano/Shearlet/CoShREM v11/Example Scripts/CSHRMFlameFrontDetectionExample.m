%Example of detecting flame fronts in PLIF recordings of OH and CH radicals.


disp('Detecting edges in a PLIF recording of OH radicals ...');

img = dlmread('K05_OH_full.txt');

%% system parameters
rows = size(img,1);
cols = size(img,2);
waveletEffSupp = 100;
gaussianEffSupp = 25;
scalesPerOctave = 2;
shearLevel = 3; %i.e. 2^shearLevel different orientations on each scale
alpha = 0.8;
octaves = 4;
pivotScales = 'lowest';


%% edge detection parameters
minimalContrast = 70; 
offset = 1; %in octaves

%% thinning parameters
thinningThreshold = 0.1;

%% edge detection
complexShearletSystem = CSHRMgetContEdgeSystem(rows,cols,waveletEffSupp,gaussianEffSupp,scalesPerOctave,shearLevel,alpha,1:floor(octaves*scalesPerOctave));
[edges,orientations] = CSHRMgetEdges(img,complexShearletSystem,minimalContrast,offset,pivotScales);

edgesThinned = CSHRMthinToLines(edges,thinningThreshold);
orientationsThinned = orientations;
orientationsThinned(~edgesThinned) = -1;
curvature = CSHRMgetCurvatureMex(orientationsThinned);

imgOverlayRgb = CSHRMgetOverlay(img,edges);
imgOverlayThinnedRgb = CSHRMgetOverlay(img,edgesThinned);
imgOris = CSHRMrgbFromOrientations(orientationsThinned);
imgCurv = CSHRMrgbFromCurvature(curvature,15);


figure;
image(imgCurv);
axis equal;
axis tight;
axis off;
title('Local curvatures');

figure;
image(imgOris);
axis equal;
axis tight;
axis off;
title('Local tangent orientations');

figure;
image(imgOverlayThinnedRgb);
axis equal;
axis tight;
axis off;
title('Overlay with thinned edges');

figure;
image(imgOverlayRgb);
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

disp('Detecting ridges in a PLIF recording of CH radicals ...');

img = fliplr(dlmread('K05_CH_full.txt'));

%% system parameters
rows = size(img,1);
cols = size(img,2);
waveletEffSupp = 60;
gaussianEffSupp = 20;
scalesPerOctave = 4;
shearLevel = 3; %i.e. 2^shearLevel different orientations on each scale
alpha = 0.2;
octaves = 4;
onlyPositive = 1;


%% edge detection parameters
minimalContrast = 150; 
offset = 1; %in octaves

%% thinning parameters
thinningThreshold = 0.1;


%% edge detection

complexShearletSystem = CSHRMgetContRidgeSystem(rows,cols,waveletEffSupp,gaussianEffSupp,scalesPerOctave,shearLevel,alpha,1:floor(octaves*scalesPerOctave));

[ridges,orientations] = CSHRMgetRidges(img,complexShearletSystem,minimalContrast,offset,onlyPositive);

ridgesThinned = CSHRMthinToLines(ridges,thinningThreshold);
orientationsThinned = orientations;
orientationsThinned(~ridgesThinned) = -1;
curvature = CSHRMgetCurvatureMex(orientationsThinned);

imgOverlayRgb = CSHRMgetOverlay(img,ridges);
imgOverlayThinnedRgb = CSHRMgetOverlay(img,ridgesThinned);
imgOris = CSHRMrgbFromOrientations(orientationsThinned);
imgCurv = CSHRMrgbFromCurvature(curvature,15);

figure;
image(imgCurv);
axis equal;
axis tight;
axis off;
title('Local curvatures');

figure;
image(imgOris);
axis equal;
axis tight;
axis off;
title('Local tangent orientations');

figure;
image(imgOverlayThinnedRgb);
axis equal;
axis tight;
axis off;
title('Overlay with thinned edges');

figure;
image(imgOverlayRgb);
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
imagesc(ridges);
axis equal;
axis tight;
axis off;
title('Ridge measure');

%  Copyright (c) 2016. Rafael Reisenhofer
%
%  Part of CoShREM Toolbox v1.1
%  Built Mon, 11/01/2016
%  This is Copyrighted Material