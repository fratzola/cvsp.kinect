function [confMatrix] = makeConfMatrix(TrueLabel,TestLabel,Size)

% First argument: True data label (TestAnnotation)
% Second argument: Test data label (KMea)
% Third argument: Size of square confusion matrix (so far 10)

confMatrix = zeros(Size);
for i=1:length(TrueLabel)
    confMatrix(TrueLabel(i),TestLabel(i)) = confMatrix(TrueLabel(i),TestLabel(i)) + 1;
end

for i = 1:Size
    s = sum(confMatrix(i,:));
    for j = 1:Size
        confMatrix(i,j) = confMatrix(i,j)*100/s;
    end
end
    