

function [box_coords, segments_fixed] = mq_ncuts_adjusted( input, k, show_result )


    % [box_coords, segmentation] = mq_ncuts_adjusted( input, k, show_result )
    %
    %
    % inputs
    %   input: file name of the image on which you'd like to run ncuts (default: 'cameraman.tif')
    %   input: or an image matrix
    %   k: number of segments that should result (default:6)
    %   show_result: controls whether or not an image with boxes are drawn (default: false)
    %
    %
    % outputs
    %   box_coords: each row contains upper left coord and lower right coord of a single box
    %       first row is probably the dummy segment and should be ignored.
    %   segmentation: pixelwise labeling into segments
    %       zeros were used to adjust bad bounds in a few places, so does
    %       not constitute a real segment.
    %
    %
    % to try the function out:
    %   [box_coords, segments_fixed] = mq_ncuts_adjusted( [], 6, true );
    
    
    
    % check inputs and set default values
        if ~exist('input','var') || isempty(input)
            input = 'cameraman.tif';
            image_in = double( imread(fname) )/255;
            display(['no file name (input) give, using ''' input '''']);
        elseif ~ischar(input)
            image_in = mat2gray(input);
        else
            image_in = double( imread(fname) )/255;
        end

        if ~exist('k','var') || isempty(k);
            k = 6;
            display('number of cuts (k) not given, using 6');
        end

        if ~exist('show_result','var') || isempty(show_result);
            show_result = false;
            display('display preference (show_result) not given, using ''false''');
        end

        
        
    % load the image, make grayscale, run NcutImage
        if size(image_in,3) == 3
            image = rgb2gray(image_in);
            image = mat2gray(image);
        else
            image = mat2gray(image_in);
        end
        [p,q,r]=size(image);
        % nbPixels=p*q;
        [segments,~,~,~,~,~] = NcutImage(image, k);

    % contract the segments a bit, making the boxes more conservative
        segments_fixed = mq_fix_segments( segments );
    



    % our modified boxes, which reach out a little from the more
    % conservative segmentation

        r = size(segments,1);
        c = size(segments,2);
        boxes_2 = mq_boxes_adjust( box_segments( segments_fixed ), r,c );

        box_coords(:,1) = boxes_2(:,1);
        box_coords(:,2) = boxes_2(:,2);
        box_coords(:,3) = boxes_2(:,3) + boxes_2(:,1);
        box_coords(:,4) = boxes_2(:,4) + boxes_2(:,2);

        if show_result

            figure
                subplot(1,2,1); imshow( image_in,[] );
                subplot(1,2,2);
                    imshow( segments_fixed/12 + .5 );
                    for i = 1:size(boxes_2,1)
                        rectangle('Position',boxes_2(i,:));
                    end

        end


        
end






function boxes_fixed = mq_boxes_adjust( b, r,c )

    m = 3;

    boxes_fixed = zeros(size(b));
    for i = 1:size(b,1)

        c0 = b(i,1);
        cf = c0 + b(i,3) - 1;
        r0 = b(i,2);
        rf = r0 + b(i,4) - 1;

        c0 = max(1,c0-m);
        r0 = max(1,r0-m);
        cf = min(c, cf+m);
        rf = min(r, rf+m);

        boxes_fixed(i,:) = [c0,r0,cf-c0,rf-r0];
    end
    
end




function segments_fixed = mq_fix_segments( segments )

    m = 3; 

    [fx fy] = gradient(segments);
    mask = filter2(ones(2*m,2*m),abs(fx)+abs(fy),'same');
    mask = 1-ne(mask,0);
    segments_fixed = mask .* segments;

end


    