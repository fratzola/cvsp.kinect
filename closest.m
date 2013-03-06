function [percent, KMea] = closest(TrainData, TrainAnnotation, TestData, TestAnnotation)

% TrainData =  pinakas features ton Train Data
% TrainAnnotation = pinakas Annotation ton Train Data - 
% TestData =  pinakas features ton Test Data
% TestAnnotation = pinakas Annotation ton Test Data

% percent = pososto epitixias tou algorithmou
% Kmea = Katataksi ton Test Data me vasi ti dosmeni methodo

TestNoF = size(TestData,1);

% Ipologismos apostaseon apo Train Data
Distance = dist(TrainData,TestData');

% Antistoixisi se cluster
KMea = zeros(TestNoF,1);
for i=1:TestNoF
    [~, I] = min(Distance(:,i));
    KMea(i,1) = TrainAnnotation(I);
end

% Arithmos epitiximenon anagnoriseon
success = 0;
for i=1:TestNoF
    if (KMea(i) == TestAnnotation(i))
        success = success+1;
    end
end

percent = success/TestNoF;