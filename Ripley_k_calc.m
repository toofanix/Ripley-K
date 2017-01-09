%%Created by Jigar Bandaria
%This script calculated the Ripley K value for each point 
%that was localized in a super-resolution image.

clear all;

%Name of the txt file containing the X and Y cooridnates of 
%the localized points
filename='cell1';
filename1=strcat(filename,'.txt');

%Read the contents of the file
a=dlmread(filename1,'\t',1,0);
tic

%The file has many parameters such as amplitude, precision etc
%We are only using the X and Y in the 4th and 5th column for clustering
locs=a(:,(4:5));
b=locs;

%Sorting by X. This makes it easy for visualization later.
sortrows(b);
locs=ans;
clear a
clear b
clear ans

%%
%In this part of the script I use the Ripley K function
%I am performing Ripley with a step-size increase in the radius of
% 0.1 pixel at every iteration. The maximum is set to 2.5 pixel. The 
% reason being that images are diffraction limited. So I dont expect my 
% clusters to be larger than 2 pixels.


r=25; % This sets the maximum radius as 2.5 pixel.
locs2=locs; % This backs up the copy of original data.
[m,n]=size(locs); % getting the dimension of locs (original data)

% this part of the code calculated the euclidean and put it
% in the form of a square matrix.
DX = repmat(locs(:,1),1,m)-repmat(locs(:,1)',m,1);
DY = repmat(locs(:,2),1,m)-repmat(locs(:,2)',m,1);

DIST=sqrt(DX.^2+DY.^2);%Distance matrix 
%Realized that not MATLAB offers pdist and squareform to do the same.


clear DX
clear DY

rip_x=zeros(r,length(DIST));%matrix to store the k values at diff r 

hist_rip=zeros(r,200); %store histograms for different r values


% this part of code caculate the k values for each value of r
% and calculates their histogram at each r value.
for j=1:r
b=find(DIST<j*0.1);
c=ceil(b/length(DIST));
rip_x(j,:)=hist(c,length(DIST));
hist_rip(j,:)=hist(rip_x(j,:),200);
j
end


%Based on my previous experience, I have realized that using the 
%Ripley K values at r = 0.3 pixel removes most of the noise without 
%affecting the points in the clusters. Usually the density of noise is 
%<10 points in 0.3 pixels.

% I am reanalyzing data after filtering out the points with k<10
temp1=rip_x(3,:);%selecting k value at r=0.3.
temp1_1=temp1';
locs(temp1<10,:)=[];
[m,n]=size(locs);
clear DIST
clear b
clear c


%Here I am evaluating the Ripley K for the remaining points.
DX = repmat(locs(:,1),1,m)-repmat(locs(:,1)',m,1);
DY = repmat(locs(:,2),1,m)-repmat(locs(:,2)',m,1);
DIST=sqrt(DX.^2+DY.^2);%a=10*rand(500);
clear DX
clear DY
rip_x=zeros(r,length(DIST));
hist_rip=zeros(r,200);
for j=1:r
b=find(DIST<j*0.1);
c=ceil(b/length(DIST));
rip_x(j,:)=hist(c,length(DIST));
hist_rip(j,:)=hist(rip_x(j,:),200);
j
end

clear DIST
clear b
clear c


%%
%In this part of the code I will select points with cut-off
%of 1.5 pixel. Most of the clusters are smaller than this. 
%Since I had orginally sorted the data, point that belong to a 
%cluster have similar Ripley-K values. Thus Ripley K values can be
%used to select clusters.

temp1=rip_x(15,:);%selecting k values at r=1.5 so that it is plateau.
temp2=temp1';
list1=[locs temp2];

%Saving all the filtered data
filename2=strcat(filename,'_output.txt')
save (filename2, 'list1', '-ascii', '-tabs');

%%

