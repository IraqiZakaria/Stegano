%% Pray it works
size(Image);
ImageR=Image(: , : ,1);
ImageR=double(ImageR);


%%
[dh1,h1,cp1,tauq1] = dwtleader2(ImageR);
hp=plot(h1,dh1)
