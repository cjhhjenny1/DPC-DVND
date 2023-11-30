function drawcluster(data,cluster,nc,Label)
figure();
map=[
120 169 235;
250 173 90;
63 186 169 
255 213 71; 
184 150 228;
3 221 239;
122 213 134;
252 124 116;
]/255;
colormap(map);
scatter(data(:,1),data(:,2),20,Label,'filled');
hold on
X=data(cluster,:);
Y=Label(cluster,:);
for i=1:nc
    scatter(X(:,1),X(:,2),40,Y, 'markerFaceColor',[0.2 0.2 0.2],'marker','^')
end
hold on
box on
title ('DPC-DVND')