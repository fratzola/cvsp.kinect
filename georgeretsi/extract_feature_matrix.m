function [h,obs_ind] = extract_feature_matrix(bins,cells,blocks,overlap,signed,gauss_filt,distr)

listing1 = dir(fullfile('..\Triesch', '*1*.pgm'));
listing2 = dir(fullfile('..\Triesch', '*2*.pgm'));

letters = {'a','b','c','d','g','h','i','l','v','y'};
%temp_l = struct2cell(listing1);
%l1 = temp_l(1,:); 

%bins = 9;
%cell_size = 6;
%blocks = 3;
%overlap = 1;
%signed = 0;

crop = 1;
ssr_on = 0;

obs_ind = cell(length(letters),1);
for k = 1:length(listing2)
    Name = listing2(k).name;
    for l = 1:length(letters)
        str = strcat(letters{l},'2');
        f = strfind(Name,str);
        if (isempty(f)==0)
            obs_ind{l} = [obs_ind{l} k];
        end
    end
    img = imread(strcat('..\Triesch/',Name));
    new_img = BS(img,crop,ssr_on);
    new_img = double(new_img);
    h(k,:) = HOG(new_img,bins,cells,blocks,overlap,signed,gauss_filt,distr);    
end
    