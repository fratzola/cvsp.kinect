clear all; close all;

%% TrainData

train1 = 'geo1+2+3+4.mat';
train2 = 'vag1+2.mat';
train3 = 'greg1+2.mat';

k=0;

%fortosi protou arxeiou
load(train1);
%---------------- Optional: extract bounding box ('regionprops')---------
%total = extractBoundingBox(total);
%----------------

for i = 1:size(total,1)
    k = k+1;
    preTrainData(k,1) = total(i,1);
    TrainAnnotation(k,1) = correct(i,1);
end

%fortosi defterou arxeiou
load(train2);
%---------------- Optional: extract bounding box ('regionprops')---------
%total = extractBoundingBox(total);
%----------------

for i = 1:size(total,1)
    k = k+1;
    preTrainData(k,1) = total(i,1);
    TrainAnnotation(k,1) = correct(i,1);
end

%fortosi tritou arxeiou
load(train3);
%---------------- Optional: extract bounding box ('regionprops')---------
%total = extractBoundingBox(total);
%----------------

for i = 1:size(total,1)
    k = k+1;
    preTrainData(k,1) = total(i,1);
    TrainAnnotation(k,1) = correct(i,1);
end

%% TestData

test1 = 'mag1+2.mat';

k=0;

%fortosi protou arxeiou
load(test1);
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

[percent_closest, KMea_closest] = closest(TrainData, TrainAnnotation, TestData, TestAnnotation);
[percent_centroids, KMea_centroids] = centroid(TrainData, TrainAnnotation, TestData, TestAnnotation);
[percent_weights, KMea_weights] = weights(TrainData, TrainAnnotation, TestData, TestAnnotation);

conf_closest = makeConfMatrix(TestAnnotation,KMea_closest,10);
conf_centroids = makeConfMatrix(TestAnnotation,KMea_centroids,10);
conf_weights = makeConfMatrix(TestAnnotation,KMea_weights,10);

successPerLetter_centroids=diag(conf_centroids)'./sum(conf_centroids,1);
successPerLetter_closest=diag(conf_closest)'./sum(conf_closest,1);
successPerLetter_weights=diag(conf_weights)'./sum(conf_weights,1);
%save('train3_test1_greg.mat', 'percent_closest', 'percent_centroids', 'percent_weights', 'KMea_closest', 'KMea_centroids', 'KMea_weights', 'conf_closest', 'conf_centroids', 'conf_weights', 'TestAnnotation');