clear all; close all;

%% TrainData

train1 = 'vag1+2.mat';

k=0;

% fortosi protou arxeiou
load(train1);
%---------------- Optional: extract bounding box ('regionprops')---------
%total = extractBoundingBox(total);
%----------------

for i = 1:size(total,1)
    k = k+1;
    preTrainData(k,1) = total(i,1);
    TrainAnnotation(k,1) = correct(i,1);
end

%% TestData

test1 = 'geo1+2+3+4.mat';
test2 = 'greg1+2.mat';
test3 = 'mag1+2.mat';

k = 0;

% fortosi protou arxeiou
load(test1);
%---------------- Optional: extract bounding box ('regionprops')---------
%total = extractBoundingBox(total);
%----------------

for i = 1:size(total,1)
    k = k+1;
    preTestData(k,1) = total(i,1);
    TestAnnotation(k,1) = correct(i,1);
end

% fortosi defterou arxeiou
load(test2);
%---------------- Optional: extract bounding box ('regionprops')---------
%total = extractBoundingBox(total);
%----------------

for i = 1:size(total,1)
    k = k+1;
    preTestData(k,1) = total(i,1);
    TestAnnotation(k,1) = correct(i,1);
end

% fortosi tritou arxeiou
load(test3);
%---------------- Optional: extract bounding box ('regionprops')---------
%total = extractBoundingBox(total);
%----------------

for i = 1:size(total,1)
    k = k+1;
    preTestData(k,1) = total(i,1);
    TestAnnotation(k,1) = correct(i,1);
end

% Ipologismos HOGs

for i = 1:size(preTrainData,1)
    H(:,i) = hog(preTrainData{i,1});
end
TrainData = H';

clear H;
for i = 1:size(preTestData,1)
    H(:,i) = hog(preTestData{i,1});
end
TestData = H';

[percent, KMea] = closest(TrainData, TrainAnnotation, TestData, TestAnnotation);
[percent, KMea] = centroid(TrainData, TrainAnnotation, TestData, TestAnnotation);
[percent, KMea] = weights(TrainData, TrainAnnotation, TestData, TestAnnotation);