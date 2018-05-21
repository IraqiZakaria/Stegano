With the CoShREM Toolbox 1.1, you can detect edges and ridges in 2D images via the complex shearlet-based edge measure defined in chapter 4 of Rafael Reisenhofer's MSc thesis (see attached PDF document) and the attached conference paper.

This toolbox (with the exception of some files mentioned below) was written by Rafael Reisenhofer (reisenhofer@math.uni-bremen.de). 

To get started, include all files and subfolders to your MATLAB path, make sure that all necessary MEX-files are compiled and call CSHRMGUI from the MATLAB command line.

Folders:

- Continuous Shearlet Transform: This folder contains methods for computing a 'continuous' shearlet system in the digital realm and a respective forward transform.
-                           GUI: This folder contains a graphical user interface. It is strongly encouraged to start exploring this toolbox here.
-               Example Scripts: This folder contains two scripts performing a shearlet-based edge detection.
-                          Data: This folder contains various images and the respective edge detection-settings, both of which can be opened and processed via the graphical user interface.
-                           Mex: Contains .cpp files necessary for CSHRMgetEdges and CSHRMgetRidges
-                          Util: Contains auxiliary functions

Files:

-                           CSHRMgetEdges.m: Implementation of the complex shearlet-based edge measure.
-                          CSHRMgetRidges.m: Implementation of the complex shearlet-based ridges measure.
-                    CSHRMcompileMexFiles.m: Auxiliary script to compile necessary MEX files.
- Complex Shearlet-based Edge Detection.pdf: Fourth chapter of the MSc thesis of Rafael Reisenhofer, describing the complex shearlet-based edge measure implemented in CSHRMgetEdges.m.
-      SPIE2015EdgeDetectionPaperSubmit.pdf: E. J. King, R. Reisenhofer, J. Kiefer, W.-Q Lim, Z. Li and G. Heygster; Shearlet-Based Edge Detection: Flame Fronts and Tidal Flats; Applications of Digital Image Processing XXXVIII (Andrew G. Tescher, ed.), SPIE Conference Series, vol. 9599, 2015.


The method

- yapuls (in Util)

is taken from Yet Another Wavelet Toolbox (YAWTb), which can be downloaded from http://sites.uclouvain.be/ispgroup/yawtb/.

The method

- hsl2rgb (in Util)

was written by Vladimir Bychkovsky and downloaded from http://de.mathworks.com/matlabcentral/fileexchange/20292-hsl2rgb-and-rgb2hsl-conversion.

The methods

- SLdshear (in Continuous Shearlet Transform)
- SLpadArray (in Continuous Shearlet Transform)

are taken from ShearLab 3D [1], which can be downloaded from http://www.shearlab.org/.

The files

- K05_CH_full.txt
- K05_OH_full.txt
- B0.png

were kindly provided by Johannes Kiefer.

[1] G. Kutyniok, W.-Q Lim, and R. Reisenhofer; ShearLab 3D: Faithful Digital Shearlet Transforms Based on Compactly Supported Shearlets"; ACM Transactions of Mathematical Software 42, no. 1.



changes in v1.1

- Improved color and black and white prints from CSHRMgetOverlay, CSHRMrgbFromCurvature and CSHRMrgbFromOrientations.
- Got rid of stupid redundancy in shearlet system used for edge detection. Now, the coefficients for the second semi-circle are computed by shifting flipping the coefficients from the first semi-circle.
- Fixed small bug when setting the nScales variable in the .cpp files.

!!!!!!!!!! Important !!!!!!!!!!!

Before using this toolbox, you have to compile the mex files stored in the Mex folder.
You can do this by calling the CSHRMcompileMexFiles.m script from this folder.

!!!!!!!!!! Important !!!!!!!!!!!
