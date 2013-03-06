function [confMatrix] = makeConfMatrix(TrueLabel,TestLabel,Size)

% First argument: True data label (TestAnnotation)
% Second argument: Test data label (KMea)
% Third argument: Size of square confusion matrix (so far 10)

confMatrix = zeros(Size);
for i=1:length(TrueLabel)
    confMatrix(TestLabel(i),TrueLabel(i)) = confMatrix(TestLabel(i),TrueLabel(i)) + 1;
end