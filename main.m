%% loading data
clear all; close all; clc;
load datasets\synthetic\D1.mat 
data=dataset(:,1:end-1); 
T=dataset(:,end);  % T:true lable 
[N,dim]=size(data); % N:size Dim:dimension
%% data preprocessing
data=normalize(data);       
data(isnan(data))=0;
%% Parameter
k=5;
nc=3;
%% DPC-DVND algorithm will be available after the paper is published
[cluster,Label,rs,TotalTime]=DPC_DVND(data,N,k,nc);
%% evaluation metrics
BestMea=evaluation(T,Label,N)
drawcluster(data,cluster,nc,Label);
