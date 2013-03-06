function I_final = BS(I,crop,ssr_on)
    I_org = I;
    %        I1_b_imr = imerode(I,se);
    %     I1_b_imd = imdilate(I,se);
    %     I_bin_erdil = I1_b_imd-I1_b_imr;
    %
%     I_open = imopen(I,strel('disk',3));
%     level = graythresh(I_open);
%     I1_b = im2bw(I_open,level);
%     [seg,locations] = imfill(I1_b,'holes');
    
    sigma_edge=1;
    [G_X,G_Y]=gen_dgauss(sigma_edge);
    I = I-mean(I(:));
    I_X = filter2(G_X, I, 'same'); % vertical edges
    I_Y = filter2(G_Y, I, 'same'); % horizontal edges
    
    I_mag = sqrt(I_X.^2 + I_Y.^2); % gradient magnitude
    I_mag = histeq(I_mag);
    level = graythresh(I_mag);
    seg = im2bw(I_mag,level);
    [seg,locations] = imfill(seg,'holes');
    %I1_b_imr = imerode(seg,se);
    %seg = imdilate(I1_b_imr,se);

    %     m = zeros(size(I,1),size(I,2));          %-- create initial mask
    %     m(10:size(I,1)-10,10:size(I,2)-10)=1;
    %     seg = region_seg(I, m, 500); %-- Run segmentation
    
    if (ssr_on == 1)
        I_org = ssr(double(I_org),4,1);
        I_org(I_org<0) = 0;
    end
    
    I_org(~seg)=0;
    
    I_final = I_org;
    
    if (crop == 1)
        STATS = regionprops(seg, 'BoundingBox','Area');
        [max_v,max_ind] = max([STATS(:).Area]);
        BB = STATS(max_ind).BoundingBox;
   
        I_crop = imcrop(I_org,BB);
        %I_final = I_crop;
        I_final = imresize(I_crop,[80 80]); % resize 
    end
    
function [GX,GY]=gen_dgauss(sigma)

% laplacian of size sigma
%f_wid = 4 * floor(sigma);
%G = normpdf(-f_wid:f_wid,0,sigma);
%G = G' * G;
G = gen_gauss(sigma);
[GX,GY] = gradient(G);

GX = GX * 2 ./ sum(sum(abs(GX)));
GY = GY * 2 ./ sum(sum(abs(GY)));

function G=gen_gauss(sigma)

if all(size(sigma)==[1, 1])
    % isotropic gaussian
    f_wid = 4 * ceil(sigma) + 1;
    G = fspecial('gaussian', f_wid, sigma);
    %	G = normpdf(-f_wid:f_wid,0,sigma);
    %	G = G' * G;
else
    % anisotropic gaussian
    f_wid_x = 2 * ceil(sigma(1)) + 1;
    f_wid_y = 2 * ceil(sigma(2)) + 1;
    G_x = normpdf(-f_wid_x:f_wid_x,0,sigma(1));
    G_y = normpdf(-f_wid_y:f_wid_y,0,sigma(2));
    G = G_y' * G_x;
end