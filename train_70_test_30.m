clear all; close all; clc;

%% TrainData --> 70% + TestData --> 30%

data{1} = 'greg1+2.mat';
data{2} = 'geo1+2+3+4.mat';
data{3} = 'mag1+2.mat';
data{4} = 'vag1+2.mat';

k=0;
for d=1:4
    load(data{d});
    %---------------- Optional: extract bounding box ('regionprops')---------
    total = extractBoundingBox(total);  
    %----------------

    for i = 1:size(total,1)
        k = k+1;
        AllData(k,1) = total(i,1);
        AllDataAnnotation(k,1) = correct(i,1);
    end
end

% randomize the coordinates of AllDataAnnotation
random_coord = randperm(size(AllDataAnnotation,1));   

% randomize AllData and AllDataAnnotation with respect to random coordinates
AllData = AllData(random_coord);
AllDataAnnotation = AllDataAnnotation(random_coord);

train_new_letter = 0;
test_new_letter = 0;
for k=1:10
    A = (AllDataAnnotation == k);
    counter = sum(A,1); % counter contains the number of data for each letter
    [A,I] = sort(A,1,'descend');    % sort A in order to 1s go to the top of the vector
    
    % take 70% of data for training
    train_counter = round(0.7*counter);
    preTrainData((train_new_letter+1):(train_new_letter+train_counter),1) = AllData(I(1:train_counter),1);
    TrainAnnotation((train_new_letter+1):(train_new_letter+train_counter),1) = k;
    
    % take the rest 30% of data for testing
    test_counter = counter-train_counter;
    preTestData((test_new_letter+1):(test_new_letter+test_counter),1)=AllData(I(train_counter+1:counter),1);
    TestAnnotation((test_new_letter+1):(test_new_letter+test_counter),1) = k;
    
    train_new_letter = train_new_letter + train_counter;
    test_new_letter = test_new_letter + test_counter;
    
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
[percent_centroid, KMea_centroid] = centroid(TrainData, TrainAnnotation, TestData, TestAnnotation);
[percent_weights, KMea_weights] = weights(TrainData, TrainAnnotation, TestData, TestAnnotation);

conf_closest = makeConfMatrix(TestAnnotation,KMea_closest,10);
conf_centroids = makeConfMatrix(TestAnnotation,KMea_centroid,10);
conf_weights = makeConfMatrix(TestAnnotation,KMea_weights,10);
