%This code performes the exemplary analysis with the use 
% of DeepOrientation neural network
% source: 
% M. Cywińska, M. Rogalski, F. Brzeski, K. Patorski, M. Trusiak, 
% "DeepOrientation: convolutional neural network for fringe 
% pattern orientation map estimation", (in review)
%
% for questions contact:
% maria.cywinska.doktr@pw.edu.pl


clear all;
close all;


%exemplary data (may be replaced by other/user's data - 
% - the only requirement is preprocessing)
% recommended preprocessing path for your data:
% uVID prefiltration [1] and HST normalization [2]
% [1] M. Cywińska,et al., Opt. Express 27 (2019).
% [2] K. G. Larkin, et al., J. Opt. Soc. Am. A 18 (2001).

%type='Matlab peaks function';
%type='group of HeLa cells (oblong)';
type='group of HeLa cells (spherical)';

image_nr=26; %may choose between 1-140

img=imread([type '/images/img_',num2str(image_nr),'.tiff']);

img=double(img);
img=(img-min(min(img)))./(max(max(img))-min(min(img)));

%DeepOrientation 

load("DeepOrientationNet.mat")
lgraph=layerGraph(network);
lgraph = removeLayers(lgraph,["regressionoutput"]);
dlnet=dlnetwork(lgraph);

dlX = dlarray(img, 'SSCB');

[Y] = forward(dlnet,dlX,'Outputs','relu1_out');
sin_cos_2FO=extractdata(Y);
cos2FO=sin_cos_2FO(:,:,1)-1;
sin2FO=sin_cos_2FO(:,:,2)-1;

thetaDO=atan2(sin2FO,cos2FO)/2;
unwthetaDO=0.5*double(Miguel_2D_unwrapper(single(2*thetaDO)));

fh = figure();
fh.WindowState = 'maximized';

subplot('Position',[0.02,0.27,0.31,0.44])
imagesc(img)
axis image
xticks([])
yticks([])
colormap(gca,gray)
caxis(gca,[0,1])
colorbar
title('input fringe pattern')
set(gca,'FontSize',12)

subplot('Position',[0.35,0.05,0.31,0.44])
imagesc(thetaDO)
axis image
xticks([])
yticks([])
colormap(gca,twilight_shifted)
caxis(gca,[-pi,pi])
colorbar
title('local fringe orientation map')
set(gca,'FontSize',12)

subplot('Position',[0.68,0.05,0.31,0.44])
imagesc(unwthetaDO)
axis image
xticks([])
yticks([])
colormap(gca,twilight_shifted)
caxis(gca,[-pi,pi])
colorbar
title('local fringe direction map')
set(gca,'FontSize',12)

subplot('Position',[0.35,0.53,0.31,0.44])
imagesc(sin2FO)
axis image
xticks([])
yticks([])
colormap(gca,parula)
caxis(gca,[0,1])
colorbar
title('output sin(2FO)')
set(gca,'FontSize',12)

subplot('Position',[0.68,0.53,0.31,0.44])
imagesc(cos2FO)
axis image
xticks([])
yticks([])
colormap(gca,parula)
caxis(gca,[0,1])
colorbar
title('output cos(2FO)')
set(gca,'FontSize',12)
