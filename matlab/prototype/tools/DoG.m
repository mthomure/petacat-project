function h = DoG( w1, w2 )

    ifndef('w1',15);
    ifndef('w2',fix(w1/2));
    
    w = [w1 w2];
    
    h1 = blackman(max(w)) * blackman(max(w))';
    
    h2 = blackman(min(w)) * blackman(min(w))';
    h2 = padarray_to( h2, size(h1) );
    
    h = h2/sum(h2(:)) - h1/sum(h1(:));
    
end
