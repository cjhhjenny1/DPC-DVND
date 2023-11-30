function [knnD,neighborIds]=neighborhood(data,k)
    constructed_search_tree = createns(data,'NSMethod','kdtree','Distance','euclidean');
    [neighborIds, knnD] = knnsearch(constructed_search_tree,data,'k',k);
    neighborIds = neighborIds(:,1:k);  
    knnD = knnD(:,1:k);
end