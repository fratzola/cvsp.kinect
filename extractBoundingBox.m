function [total_bb] = extractBoundingBox(total)
% Input: 'total' (cropped grayscale images)

total_bb = cell(length(total),1);
for i=1:length(total)
    a = 1-im2bw(total{i},0.9);
    b = regionprops(a,'BoundingBox');
    b = struct2cell(b);
    b = cell2mat(b);
    total_bb{i} = total{i}(ceil(b(2)):floor(b(2))+b(4),ceil(b(1)):floor(b(1))+b(3));
end
    