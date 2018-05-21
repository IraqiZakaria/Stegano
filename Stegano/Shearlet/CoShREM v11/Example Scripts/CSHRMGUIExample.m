%Quick tutorial demonstrating the capabilities of the CoShREM GUI.

CSHRMGUI;
uiwait(msgbox('Welcome to the CoShREM GUI! These message boxes will guide you through a quick tutorial. To get to the next step, just click OK!','CoShREM'));
uiwait(msgbox('First, you can open any image you want to process by clicking: File -> Open Image ...','CoShREM'));
uiwait(msgbox('Now, click "detect" to construct a complex-valued shearlet system and to compute the complex-shearlet based edge mesaure.','CoShREM'));
uiwait(msgbox('The right axes now visualizes the complex shearlet-based edge measure. You can also visualize the detected local tangent orientations and curvatures by clicking the buttons in the middle of the window.','CoShREM'));
uiwait(msgbox('The parameters to the lower left specify the complex shearlet system, while the parameter to the lower right specify the edge/ridge detection process.','CoShREM'));
uiwait(msgbox('If you want to detect ridges instead of edges, just change the value "Edges" to "Ridges" in the corresponding dropdown element and click "Detect" again.','CoShREM'));


%  Copyright (c) 2016. Rafael Reisenhofer
%
%  Part of CoShREM Toolbox v1.1
%  Built Mon, 11/01/2016
%  This is Copyrighted Material