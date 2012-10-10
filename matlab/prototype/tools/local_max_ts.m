

clear all; close all; clc;



x = double( imread( 'cameraman.tif' ) ) / 255;



d = 30;
s = d / sqrt(2);

[y,rcs,ccs] = local_max(x,d,s);
z = imresize(y,size(x),'nearest');


figure; 

    subplot(1,3,1);

        imshow(x,[]); 
        hold on; 
        [r,c] = meshgrid(rcs,ccs);
        for i = 1:size(r,1)
        for j = 1:size(r,2)

            xc = c(i,j);
            yc = r(i,j);
            plot_circle([xc yc],d/2);
            plot(xc,yc,'.r');

        end
        end
        hold off;
        title('input, regions, centers');
        
    subplot(1,3,2);
    
        imshow(y,[]);
        title('output');
        
    subplot(1,3,3);
    
        imshow(z,[]);
        hold on; 
        [r,c] = meshgrid(rcs,ccs);
        for i = 1:size(r,1)
        for j = 1:size(r,2)

            xc = c(i,j);
            yc = r(i,j);
            plot_circle([xc yc],d/2);
            plot(xc,yc,'.r');

        end
        end
        hold off;
        title('output resized, regions, centers');










