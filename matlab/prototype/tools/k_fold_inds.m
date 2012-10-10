function inds = kfold_inds(n,k)
% returns an n by k logical matrix
% each of the k columns represents testing inds for the n instances

    cut_inds = fix( n * (1/k) * (0:k) );
    
    inds = false(n,k);
    for i = 1:k
        inds( cut_inds(i)+1 : cut_inds(i+1) , i ) = true;
    end
    
end