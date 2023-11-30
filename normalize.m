function X=normalize(data)
    [n,d]=size(data); 
    X=zeros(n,d); 
    for i=1:d
        mi=min(data(:,i)); 
        ma=max(data(:,i)); 
       for j=1:n
           X(j,i) = (data(j,i) - mi) / ( ma - mi); 
       end
    end
end