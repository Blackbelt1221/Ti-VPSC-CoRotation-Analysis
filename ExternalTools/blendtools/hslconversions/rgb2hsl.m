function outpict=rgb2hsl(inpict)
%   RGB2HSL(INPICT)
%       performs an HSL conversion on an RGB image
%
%   INPICT is an RGB image of class uint8 or double
%   
%   Return type is double, scaled as such:
%       H \in [0 360)
%       S \in [0 1]
%       L \in [0 1]

% This is basically the same as Colorspace by Pascal Getreuer
% I only created these two files (rgb2hsl.m and hsl2rgb.m)
% to avoid the remaining dependency being a hassle for users

inpict=imcast(inpict,'double');

mn=min(inpict,[],3);
mx=max(inpict,[],3);
L=(mn+mx)/2;

D=mx-mn;
K=min(L,1-L);
m=(K==0);
S=D./(2*(K+m));

md=(D==0);
D=D+md;

H=zeros(size(S));

[~,idx]=sort(inpict,3);
idx=idx(:,:,3); % index of max([r g b])

R=inpict(:,:,1);
G=inpict(:,:,2);
B=inpict(:,:,3);

% unlike HSI, hue angles in HSV, HSL are based 
% on even subdivision of a polygonal perimeter
m=(idx==1);
H(m)=(G(m)-B(m))./D(m);
m=(idx==2);
H(m)=2+(B(m)-R(m))./D(m);
m=(idx==3);
H(m)=4+(R(m)-G(m))./D(m);
H=mod(H*60,360);

% should neutrals have NaN hue? 
% this may break other things that don't expect NaNs
H(md)=NaN;

outpict=cat(3,H,S,L);

end