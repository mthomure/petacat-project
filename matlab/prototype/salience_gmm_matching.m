


for i = 1:k
  [x1,x2] = meshgrid(1:size(cur_image,1),1:size(cur_image,2)) ;
  y(:,:,i) = mvnpdf2(x1,x2,mu(i,:),Sigma(:,:,i));
end

salience_map = salience_map / max(salience_map(:));


error = @(a) sum( (reshape(salience_map,1,[]) - a * reshape(sum(y,3),1,[]) ).^2 );

a0 = 1;
af = fminsearch(error,a0);

figure
subplot(1,4,1); imshow( salience_map );
subplot(1,4,2); imshow( salience_map - af * y(:,:,1) );
subplot(1,4,3); imshow( salience_map - af * y(:,:,2) );
subplot(1,4,4); imshow( salience_map - af * y(:,:,3) );








