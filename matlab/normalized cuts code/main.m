m = [1 1 1 1 1 1 1 1 1 1; 
    1 1 1 1 1 1 1 1 1 1; 
    2 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 2 2; 
    2 2 2 2 2 2 2 2 2 2;
    3 3 3 3 3 3 3 3 3 3;
    3 3 3 3 3 3 3 3 3 3;
    3 3 3 3 3 3 3 3 3 3];

n=[ 5 5 4 8 8 8 8 6 6 6;
    5 5 4 8 8 8 8 6 6 6;
    5 5 4 8 8 8 8 6 6 6;
    5 5 4 8 8 8 8 6 6 6;
    5 5 4 8 8 8 8 6 6 6;
    5 5 4 8 8 8 8 6 6 6;
    5 5 4 8 8 8 8 6 6 6;
    5 5 4 8 8 8 8 6 6 6;
    5 5 4 8 8 8 8 6 6 6;
    5 5 4 8 8 8 8 6 6 6];
%n=m;
%n(:, 1:2)=5;
%n(:, 3:4)=4;
%n(:, 4:7)=8;
%n(:, 8:10)=6;


fn = '/Users/Max/Desktop/normalized cuts code/dogwalking3.jpg';
%fn = '/Users/mm/Desktop/dog4.jpg';
%image=imread_ncut(fn, 160, 160);
image=imread2(fn);
image=rgb2gray(image);
[p,q,r]=size(image);
nbPixels=p*q;

%Run stable segmentation algorithm
%[image, k] = stable_segmentation (image, 1, 0.005, 0.01, 0.005, 2, 3);
%disp(['stable segmentation was produced for k= ', num2str(k)]);

%Run multiscale n-cut segmentation creating 10 segments
%[image,~,~,~,~,~,~] = ncut_multiscale(image, 3);
%Run n-cut segmentation creating 18 segments
[image,~,~,~,~,~] = NcutImage(image, 6);

%Make bounding boxes around segments in a segmented <image>: image of
%indexed segments
[boxes]=box_segments(image);
%Visualize boxes drawn around images segments
draw_boxes(boxes, image);

%Run image segmentation on source <image> for <k_max> - <k_min> number of 
%times
%[bounding_boxes]=bounding_box_soup(image, 1, 2, 3);
%Save bounding boxes to file
%save_bounding_boxes('output_bounding_boxes.mat', bounding_boxes);
