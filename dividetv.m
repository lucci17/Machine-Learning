function [trainInd,valInd,testInd] = dividetv(Q,trainRatio,valRatio,testRatio)
    nontest_n = ceil(Q*0.85);
    [trainInd,valInd,testInd] = dividerand(nontest_n,trainRatio,valRatio,0);
    testInd = ((nontest_n+1):Q);
end
