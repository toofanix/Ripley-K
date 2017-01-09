%%
%Written by Jigar Bandaria
%This takes the output of the Ripley K and find clusters
%I am using the mean of the Ripley K vlaues of all the points
%at a radius of 0.3 pixel to determine the clusters.
% Unlike K-Means I don't have to input the number of clusters in
% advance and data itself is used to do this. 

condition1 = 1;
figure(1) % These are all the points after Ripley K 
scatter (list1(:,1),list1(:,2))

%Here is the algorithm to pick clusters
cluster = 1;
while condition1
[j,idx] = max(list1(:,3));
j1 = list1(idx,:);
x_limit = (list1(:,1)>j1(1)-1.5) & (list1(:,1)<j1(1)+1.5);
y_limit = (list1(:,2)>j1(2)-1.5) & (list1(:,2)<j1(2)+1.5);
cluster_limit = find(x_limit & y_limit);

%Clusters are usually not bigger than 1.5 pixel
clus_tmp = list1(cluster_limit,:);
list1(cluster_limit,:)=[];


%Plotting the picked cluster
figure(2)
scatter(getcolumn(clus_tmp(:,1:2),1),getcolumn(clus_tmp(:,1:2),2))


condition1 = length(clus_tmp)>mean_rip;
if condition1
filename1 = strcat(filename,'_cluster_',num2str(cluster),'.txt')
save (filename1, 'clus_tmp', '-ascii', '-tabs');
cluster = cluster +1
end
end
