%Example of ridge detection using the complex shearlet-based ridge measure.

img = double(imread('B0.png'));

%% system parameters
rows = size(img,1);
cols = size(img,2);
waveletEffSupp = 60;
gaussianEffSupp = 20;
scalesPerOctave = 4;
shearLevel = 3; %i.e. 2^shearLevel different orientations on each scale
alpha = 0.2;
octaves = 3.5;
onlyPositiveOrNegativeRidges = 1;

computeSys = 1;



%% edge detection parameters
minimalContrast = 10;
offset = 1; %in octaves

%% thinning paramters
thinningThreshold = 0.1;

%% edge detection

if computeSys
    complexShearletSystem = CSHRMgetContRidgeSystem(rows,cols,waveletEffSupp,gaussianEffSupp,scalesPerOctave,shearLevel,alpha,1:floor(octaves*scalesPerOctave));
end;

[ridges,orientations,widths,heights] = CSHRMgetRidges(img,complexShearletSystem,minimalContrast,offset,onlyPositiveOrNegativeRidges);

edgesThinned = CSHRMthinToLines(ridges,thinningThreshold);
orientationsThinned = orientations;
orientationsThinned(~edgesThinned) = -1;
oriRgb = CSHRMrgbFromOrientations(orientationsThinned);
overlayRgb = CSHRMgetOverlay(img,ridges);

curvature = CSHRMgetCurvatureMex(orientationsThinned);
curvRgb = CSHRMrgbFromCurvature(curvature,10);

figure;
image(curvRgb);
axis equal;
axis tight;
axis off;
title('Local curvatures');

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