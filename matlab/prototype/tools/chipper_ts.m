


clear all; close all; clc;



x = imread('lincoln.jpg');
x = double(x)/255;
x = rgb2gray(x);
x = retinal(x,15);

w = 20; % chip width
s = 5;  % sampling step 
chips = chipper(x,w,s);



figure('Name','example chips');
r = randperm(size(chips,1));
for i = 1:20

    cur_chip = reshape(chips(r(i),:),[w,w,size(x,3)]);
    
    subplot(4,5,i);
    imshow(cur_chip);
    
end



k = 8;

% methods = {'sqEuclidean','cosine','correlation'};
 methods = {'correlation'};

for j = 1:length(methods)

    [~,c{j}] = kmeans(chips,k,'EmptyAction','drop','Distance',methods{j});

    figure('Name',methods{j});
    for i = 1:size(c{j},1)

        cur_centroid = reshape(c{j}(i,:),[w,w,size(x,3)]);

        subplot(2,k/2,i)
        imshow(mat2gray( cur_centroid ) );

    end
    
end



    
    








