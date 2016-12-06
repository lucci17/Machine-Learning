% Change the filenames if you've saved the files under different names
% On some platforms, the files might be saved as 
% train-images.idx3-ubyte / train-labels.idx1-ubyte
% fp12 = fopen('train-resize', 'rb');
images = loadMNISTImages('train-resize');
labels = loadMNISTLabels('train-labels-idx1-ubyte');
test_images = loadMNISTImages('t10k-resize');
test_labels = loadMNISTLabels('t10k-labels-idx1-ubyte');
% We are using display_network from the autoencoder code
display_network(images(:,1:100)); % Show the first 100 images
% disp(labels(1:10));

n = 60000;
% test_n = ceil(n*15/85);
test_n = 10000;
scale = 2;
ori_size = 28;
size = ori_size/scale;
% p = zeros(size*size, n);
% for i = 1:n
%     for j = 0:size-1
%         for k = 1:size
%             p(j*size+k,i) = images(j*ori_size*2+k*2,i);
%         end
%     end
% end
p = images(:,1:n);
t = zeros(10,n);

% test_p = zeros(size*size, test_n);
% for i = 1:test_n
%     for j = 0:size-1
%         for k = 1:size
%             test_p(j*size+k,i) = test_images(j*ori_size*2+k*2,i);
%         end
%     end
% end
test_p = test_images(:,1:test_n);
test_t = zeros(10,test_n);

for i = 1:n
    t(labels(i)+1, i) = 1;
end

for i = 1:test_n
    test_t(test_labels(i)+1, i) = 1;
end

net = newff(p, t, [100], {'tansig' 'logsig'}, 'trainrp', ...
            '', 'mse', {}, {}, 'divideblock');
net = init(net);
% net.trainParam.lr = 2;
net.trainParam.delta0 = 0.07;
net.trainParam.deltamax = 100;
net.trainParam.epochs = 400;
% net.trainParam.max_fail = 1000;
% net.trainParam.min_grad = 0;
% net.trainParam.epochs = 100;
% net.divideParam.Q = n+test_n;
net.divideParam.trainRatio = 0.75;
net.divideParam.valRatio = 0.15;
net.divideParam.testRatio = 0;


[trained_net, stats] = train(net, p, t);

plotconfusion(test_t, sim(trained_net, test_p))
