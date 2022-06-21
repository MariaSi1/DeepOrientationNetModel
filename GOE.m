function [err] = GOE(x,x_ref,g)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
if exist('g')~=1
    g=0;
end
roznica = sin(x - x_ref);
d=size(x,1);
d2=size(x,2);
if g==1
%roznica=roznica(10:size(x,1)-10,10:size(x,2)-10);
roznica=roznica(20:d-20,20:d2-20);
end
%roznica=roznica(291-250:291+250, 378-250:378+250);
err = sqrt(var(roznica(:)));
end