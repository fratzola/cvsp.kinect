function [percent, KMea] = weights(TrainData, TrainAnnotation, TestData, TestAnnotation)

% TrainData =  pinakas features ton Train Data
% TrainAnnotation = pinakas Annotation ton Train Data
% TestData =  pinakas features ton Test Data
% TestAnnotation = pinakas Annotation ton Test Data

% percent = pososto epitixias tou algorithmou
% Kmea = Katataksi ton Test Data me vasi ti dosmeni methodo

TestNoF = size(TestData,1);

% Ipologismos centroids kai tipikis apoklisis
C = cell(10,1);
S = zeros(10,1);
for i=1:10
    indexes = TrainAnnotation==i;
    H = TrainData(indexes,:);
    [~, C{i}] = kmeans(H,1);
    TrainDistance = dist(C{i},TrainData(indexes,:)');   
    S(i) = std(TrainDistance);
end

% Ipologismos 6is rizas tipikis apoklisis :P
S = sqrt(sqrt(sqrt(sqrt(sqrt(sqrt(S))))));

% Ipologismos apostaseon apo centroids
Distance = zeros(10,TestNoF);
for j=1:10
    Distance(j,:) = dist(C{j},TestData');
end

% Ipologismos apostaseon me xrisi varous
Distance2 = zeros(10,TestNoF);
for i=1:TestNoF
    Distance2(:,i) = Distance(:,i)./S(:,1);
end

% Antistoixisi se cluster
KMea = zeros(TestNoF,1);
for i=1:TestNoF
    [~, I] = min(Distance2(:,i));
    KMea(i,1) = I;
end

% Arithmos epitiximenon anagnoriseon
success = 0;
for i=1:TestNoF
    if KMea(i) == TestAnnotation(i)
        success = success+1;
    end
end

percent = success/TestNoF;