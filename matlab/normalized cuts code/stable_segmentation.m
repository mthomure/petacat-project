function [ im_segmented, k] = stable_segmentation( image, segmentation, noise_min, noise_max, step, k_min, k_max )
%stable_segmentation: performs stable segmentation based on 
% "Model order selection and cue combination of image segmentation" by Rabinovich et al.
% using multiscale segmentation from "Spectral segmentation with multiscale
% graph decomposition" by T. Cour et al.
%input: 
%<image> original b/w image
%<segmentation> switch if 0 then run multiscale segmentataion, 
%                      if 1 run N-Cut-Segmentation
%<noise_min> perturbe images adding noise_min value
%<noise_max> until perturbations given by noise_max
%<step> incrementally adding step amount of noise
%<k_min> test segmentation for k_min segments to <k_max> segments with increment=1
%output: 
%<im_segmented> segmented image for most stable segmentation from given
%parameters
%<k> number of segments for which segmentation was the most stable


mismatched = Inf('double');

%iterate over all segmentation for given number of segements
for nsegs = k_min: k_max
    %get original segmentation (pivot)
    if segmentation == 0
        [classes_p,~,~,~,~,~,~] = ncut_multiscale(image,nsegs);
    elseif segmentation == 1
        [classes_p,~,~,~,~,~] = NcutImage(image,nsegs);
    else
        disp('Illegal segmentation switch');
    end
    %iterate over all noise permutations of the original image
    for noise = noise_min: step: noise_max
        for nsegs2 = k_min: k_max
            %generate noisy image
            noisy_image = add_noise (image, noise);
            %get segmentation using image with noise
            if segmentation == 0
                [classes_o,~,~,~,~,~,~] = ncut_multiscale(noisy_image,nsegs2);
            elseif segmentation == 1               
                [classes_o,~,~,~,~,~] = NcutImage(noisy_image,nsegs2);
            else
                disp('Illegal segmentation switch');
            end
            %match segmenents between the original segmentation and
            %segmentation that used noisy image
            [~,n_mismatched_pixels] = segment_matching(classes_p,classes_o);

            if n_mismatched_pixels < mismatched
                disp(['new low: p-o mismatched pixels ', num2str(n_mismatched_pixels), ...
                    ' noise ', num2str(noise), ' k-orig ', num2str(nsegs), ...
                    ' k-pert ', num2str(nsegs2)]);
                mismatched=n_mismatched_pixels;
                k=nsegs;
                im_segmented = classes_p;
            end
            %repeat the above segment_matching but use the noisy segmentation 
            %as the pivot segmentation map 
            [~,n_mismatched_pixels] = segment_matching(classes_o,classes_p);
            if n_mismatched_pixels < mismatched
                disp(['new low: o-p mismatched pixels ', num2str(n_mismatched_pixels), ...
                    ' noise ', num2str(noise), ' k-orig ', num2str(nsegs), ... 
                    ' k-pert ', num2str(nsegs2)]);
                mismatched=n_mismatched_pixels;
                k=nsegs;
                im_segmented = classes_p;
            end
        end
    end    
end
end

