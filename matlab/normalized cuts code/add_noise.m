function [ noisy_image ] = add_noise(image,p)
% adds <p> percent amount of uniform noise to the <image>
% p/2 uniformly selected pixels are colored black then another
% p/2 uniformly selected pixels are colored white
% add_noise(image, 0.2); adds 20% of B/W noise to image
%input:
%<image> must be a 2-D array with values between <0,1>
%<p> percent amount of uniform noise value from 0.00 to 1.0 

[m, n, r] = size(image);
pixels = m*n;
half_pixels = floor((pixels*p)/2); 
indexes = unidrnd (pixels, 1, half_pixels);
noisy_image = image;
noisy_image(indexes') = 0;
indexes = unidrnd (pixels, 1, half_pixels);
noisy_image(indexes') = 1;
end
