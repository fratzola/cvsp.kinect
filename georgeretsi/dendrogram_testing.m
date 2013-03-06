function dendrogram_testing(bins,cells,blocks,overlap,signed,gauss_filt,distr)

listing1 = dir(fullfile('..\Triesch', '*1*.pgm'));
listing2 = dir(fullfile('..\Triesch', '*2*.pgm'));

letters = {'a','b','c','d','g','h','i','l','v','y'};

%bins = 9;
%cell_size = 6;
%blocks = 3;
%overlap = 1;
%signed = 0;

crop = 1;
ssr_on = 0;

count = 1;
for l = 1:4
    for i = l:10:5*length(letters)
        img = imread(strcat('..\Triesch/',listing2(i).name));
        new_img = BS(img,crop,ssr_on);
        new_img = double(new_img);
        %figure; imshow(new_img,[]);
        h(count,:) = HOG(new_img,bins,cells,blocks,overlap,signed,gauss_filt,distr);
        count = count+1;
        
        if (l==3)
            new_img2 = imresize(new_img,[2*size(new_img,1) 3*size(new_img,2)]);
            h(count,:) = HOG(new_img2,bins,cells,blocks,overlap,signed,gauss_filt,distr);
            count = count+1;
        end
        %if (l==3)
        %    new_img2 = imresize(imrotate(new_img,90),[80 80]);
        %    h(count,:) = HOG(new_img2,bins,cells,blocks,overlap,signed,gauss_filt,distr);
        %    count = count+1;
        %end
    end
end

%nh = removeconstantrows(h')';
%h = nh;

Z = linkage(mypdist(h,@eucl),'average');
figure; dendrogram(Z); grid on;    