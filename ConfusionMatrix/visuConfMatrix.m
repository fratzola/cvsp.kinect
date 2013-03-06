name = [1 2 3 4 5 6 7 8 9 0];
confusionMatrix = makeConfMatrix(TestAnnotation,KMea_centroids,10);
draw_cm(confusionMatrix,name,10)