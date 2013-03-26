function P = findskinregions(I)

load('skin');

I_YCBCR = rgb2ycbcr(I); % Conversion of image into YCbCr color space

I_CB = I_YCBCR(:,:,2);  % Keep Cb channel to a separate matrix

I_CR = I_YCBCR(:,:,3);  % Keep Cr channel to a separate matrix

skinSamples_YCBCR = rgb2ycbcr(skin);  % Conversion of the image with skin samples into YCbCr color space

skinSamples_CB = skinSamples_YCBCR(:,:,2);  % Keep Cb and Cr channels to two separate matrices

skinSamples_CR = skinSamples_YCBCR(:,:,3);

mu_cb = mean(skinSamples_CB(:));    % Mean of Cb channel

mu_cr = mean(skinSamples_CR(:));    % Mean of Cr channel

mu = [mu_cb mu_cr];

covariance = cov(double(skinSamples_CB),double(skinSamples_CR));  % Covariance of the two matrices


[M,N] = size(I_CB);

det_cov = det(covariance);

for i=1:M
    for j=1:N
        c = [I_CB(i,j) I_CR(i,j)];
        c = double(c);
        P(i,j) = (1 ./ sqrt(det_cov*((2*pi)^2)))*exp((-0.5)*((c-mu)*(covariance'))*((c-mu)'));
    end
end

% An thelw na apeikonisw tin gaoussiani xrisimopoiw ti surf

% P = P > graythresh(P);

% figure, imshow(P);

% % Prin apo opening kai closing ena hole filling --> An den xreiastei na
% % kanw imfill na to grapsw stin anafora!
% P = imfill(P,'holes');
% 
% B1 = strel('disk',1);
% B2 = strel('disk',10);
% 
% P = imclose(imopen(P,B1),B2);

%  P = imdilate(P,B1);

% figure, imshow(P);
% 
% % Pws tha kanw tin apeikonisi tou tetragwnou stin eikona???
%   
% [L,NUM] = bwlabel(P);
% 
% 
% R = regionprops(L,'Area');
% 
% [max_area,indices] = max([R.Area]);
% 
% B = regionprops(L,'BoundingBox');
% 
% boundingBox = B(indices).BoundingBox;
% 
% figure, imshow(I);
% hold on;
% rectangle('EdgeColor',[0 1 0],'Position',boundingBox);
% hold off;
%          
end
