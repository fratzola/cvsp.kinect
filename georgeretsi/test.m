close all; clear all;
ind = [8:4:28];
a(1,:) = test_hog_parameters(ind,0,@eucl);
a(2,:) = test_hog_parameters(ind,0,@chi_squared);
%a(3,:) = test_hog_parameters(ind,0,@chi_squared);
%a(4,:) = test_hog_parameters(ind,1,@chi_squared);

%plot(ind,a(1,:),'b',ind,a(2,:),'g',ind,a(3,:),'r',ind,a(4,:),'c');
%hleg1 = legend('no fair-share,euclidian','fair-share,euclidian','no fair-share,chi-squared','fair-share,chi-squared');
plot(ind,a(1,:),'b',ind,a(2,:),'g');
hleg1 = legend('euclidian','chi-squared');
title('changing number of cells with fixed bins = 9 & cells = [5 5]');