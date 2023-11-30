%% loading data
clear all; close all; clc;
load dataset\synthetic\D1.mat 
data=dataset(:,1:end-1); 
T=dataset(:,end); 
[N,dim]=size(data);
%% data preprocessing
data=normalize(data);       
data(isnan(data))=0;
%% Parameter
k=5;
nc=3;
%% 
[cluster,Label,rs,TotalTime]=DPC_DVND(data,N,k,nc);

BestMea=BestMeasure(T,Label,N)
drawcluster(data,cluster,nc,Label);
