
function y = mvnpdf2(x1,x2,mu,Sigma)
% 
% for i = 1:k
%   [x1,x2] = meshgrid(1:size(cur_image,1),1:size(cur_image,2)) ;
%   y(:,:,i) = mvnpdf2(x1,x2,mu(i,:),Sigma(:,:,i));
% end
    
    
    x = x1;
    x(:,:,2) = x2;
    x = reshape(shiftdim(x,2),2,[])';

    y = mvnpdf(x,mu,Sigma);

    y = reshape(y,size(x1,1),size(x2,2))';
    
end









