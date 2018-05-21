classdef CSHRMGUIstate
    %SHEARLETEDGEDETECTIONGUICONFIG Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        image
        imageName
        detectedEdges
        thinnedEdges
        detectedOrientations
        detectedWidths
        detectedHeights
        detectedCurvature
        thinnedOrientations
        thinnedWidths
        thinnedHeights
        shearletSystem
        shearletSystemIsUpToDate
        detectRidges
        waveletEffSupp
        gaussianEffSupp
        scalesPerOctave
        shearLevel
        alpha
        octaves
        currScale
        currOrientation
        minContrast
        offset
        scalesUsedForPivotSearch
        overlay
        lastDir
        showOrientationsWidhtsOrHeightsOrCurvature
        showThinned
        thinningThreshold
        onlyPositiveOrNegativeRidges
    end
    
    methods
    end
    
end

