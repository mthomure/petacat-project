 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
%   Multiscale Normalized Cuts Segmentation Code   %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% # of segments requested
%nsegs=20;

% input image
%image=imread2('v48752.jpg');nsegs=20;
image=imread2('../images/3-dog-walk_b.jpg'); nsegs=18; %nsegs=6;
%image=imread2('../images/300px-Jogging_with_dog_at_Carcavelos_Beach_b.jpg'); nsegs=9;% segments
%image=imread2('../images/497_b.jpg');nsegs=15;
image=rgb2gray(image);
[p,q,r]=size(image);

disp(['image size : ',mat2str([p,q,r]) ]);
nbPixels=p*q;
disp(['number of pixels : ',num2str(nbPixels) ]);

disp('starting multiscale segmentation...');

[classes,X,lambda,Xr,W,C,timing] = ncut_multiscale(image,nsegs);
figure;
imagesc(classes);
axis image

disp('The demo is finished.');

