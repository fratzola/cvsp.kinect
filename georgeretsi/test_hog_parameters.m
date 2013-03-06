function a = test_hog_parameters(array,distr,hist_dist)

bins = 9;
cells = [12 12];
blocks = [3 3];
overlap = 1;
signed = 0;
gauss_filt = 0;
%distr = 1;

count = 1;
%a1 = zeros(length(b),10);
%a2 = zeros(length(b),10);
for i = array;
    [h,ind] = extract_feature_matrix(i,cells,blocks,overlap,signed,gauss_filt,distr);
    a(count) = compare_metric(h,ind,hist_dist);
    count = count + 1;
end
%plot(b,a);grid on;

