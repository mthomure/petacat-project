
clear all; close all; clc;

load optdigits;





a = input_data(2,:);
b = input_data(4,:);

figure('Name','original signals');
subplot(1,2,1); imshow(reshape(a,8,8),[])
subplot(1,2,2); imshow(reshape(b,8,8),[])





n = 20;
for i = 1:n
    r = .8*rand()+.1;
    x(i,:) = r*a + (1-r)*b;
end
x = x + .1*randn(size(x));

m = min(n,20);
figure('Name','original signals');
for i = 1:m
    subplot(2,ceil(m/2),i);
    imshow( reshape( x(i,:), 8,8 ), [] );
end





% x has features in columns, instances in rows
% that's like temporal readings in columns, and mics in rows
[icasig_raw, A_raw, W_raw] = fastica(x);

figure('Name','fastica with default settings')
for i = 1:size(icasig_raw,1)
    subplot(2,ceil(size(icasig_raw,1)/2),i)
    imshow(reshape(icasig_raw(i,:),8,8),[]);
end



[icasig_2ic, A_2ic, W_2ic] = fastica(x,'numofic', 2);

figure('Name','fastica with default settings')
for i = 1:size(icasig_2ic,1)
    subplot(2,ceil(size(icasig_2ic,1)/2),i)
    imshow(reshape(icasig_2ic(i,:),8,8),[]);
end



[icasig,A,W] = fastica(x, 'interactivepca','on');

figure('Name','fastica with interactive pca component selection');
for i = 1:size(icasig,1)
    subplot(1,size(icasig,1),i)
    imshow(reshape(icasig(i,:),8,8),[]);
end
    
