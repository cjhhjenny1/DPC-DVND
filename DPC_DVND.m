function [cluster,Label,rs,TotalTime]=DPC_DVND(data,N,k,nc)
TotalTime_start = tic;
%% KD-tree neighbors
[knnD,neighborIds]=neighborhood(data,k);
%% calculate density
rho=1./(sum(knnD,2));
%% identity local vote points
[max_rho,max_rho_ind] = max(rho(neighborIds),[],2); 
rsrho = find(max_rho == rho); 
pr =zeros(N,1); 
for i=1:N
    pr(i) = neighborIds(i,max_rho_ind(i));
end
rs=unique(pr);
b=hist(pr,rs);
cc=zeros(N,1);
cc(rs)=b;
%% calculate delta
[~,ordrho]=sort(rho,'descend');
nneigh=zeros(N,1);
delta=zeros(N,1);
ordrho1 = intersect(ordrho,rsrho,'stable');
ncore=length(rsrho);
coredata=data(ordrho1,:);
for ii=2:ncore
    delta(ordrho1(ii))=norm(coredata(ii,:)-coredata(1,:));
    nneigh(ordrho1(ii))=ordrho1(1);
    for jj=2:ii-1
        distcore1=norm(coredata(ii,:)-coredata(jj,:));
        if(distcore1<=delta(ordrho1(ii)))
            delta(ordrho1(ii))=distcore1;
            nneigh(ordrho1(ii))=ordrho1(jj);
        end
    end
end
ordrho2 = setdiff(ordrho,rsrho,'stable');
nborder=N-ncore;
maxd2=max(max(knnD));
for i=1:nborder
    rpo=ordrho2(i);
    delta(rpo)=maxd2;
    neirpo=neighborIds(rpo,:);
    kk=find(rho(neirpo)>rho(rpo));
    [deltarpo,nneighrpo]=min(knnD(rpo,kk));
    delta(rpo)=deltarpo;
    nneigh(rpo)=neighborIds(rpo,kk(nneighrpo));
end
delta(ordrho1(1))=max(delta); 
cc(ordrho1(1))=max(cc); 
%% calculate decision values gamma
dg=cc.*delta;
gamma=dg(rs);
[~,peak]=sort(gamma,'descend');
peaks=rs(peak);
npeak=length(rs);
%% neighborhood diffusion
stdrho=std(rho);
Label=zeros(N,1);   
cluster=zeros(1,1); 
NCLUST=0;
for j=1:npeak
    if (NCLUST==nc)
        break
    end
    if (Label(peaks(j))==0)            
        NCLUST=NCLUST+1;
        Label(peaks(j))=NCLUST;     
        cluster(NCLUST)=peaks(j);
        q=peaks(j);
        rhopeak=rho(peaks(j));
        npeak=1;
        while(~isempty(q))
            temp=q(1);
            rhotemp=rho(temp);
            for ii=1:k
                minpoint=neighborIds(temp,ii);
                if(Label(minpoint)==0)
                    rhopoint=rho(minpoint);
                    tp1=min(min(rhopoint,rhotemp),rhopeak);
                    tp2=max(max(rhopoint,rhotemp),rhopeak);
                    mm=abs(rhopeak-rhopoint);
                    mm1=abs(rhopeak-rhotemp);
                    mm3=max(mm,mm1);
                    mm4=tp1/tp2;
                    if ((nneigh(minpoint)==temp || nneigh(temp)==minpoint) && mm3<2*stdrho)
                        Label(minpoint)=Label(temp);
                        q=cat(2,q,minpoint);
                        if(ismember(minpoint,rs)==1)
                            rhopeak=(npeak*rhopeak+rho(minpoint))./(npeak+1);
                            npeak=npeak+1;
                        end
                    elseif (knnD(temp,ii)<mm4*(knnD(temp,end)+knnD(minpoint,end))/2 && mm3<2*stdrho)
                        Label(minpoint)=Label(temp);
                        q=cat(2,q,minpoint);
                        if(ismember(minpoint,rs)==1)
                            rhopeak=(npeak*rhopeak+rho(minpoint))./(npeak+1);
                            npeak=npeak+1;
                        end
                    end
                else
                    continue
                end
            end
            q=q(2:end);
        end
    end
end
%% assign remaining points
rp=find(Label==0);
nn=size(rp,1);
ordrho3 = intersect(ordrho,rp,'stable');
for i=1:nn
    rpo=(ordrho3(i));
    Label(rpo)=Label(nneigh(rpo)); 
end
TotalTime=toc(TotalTime_start);
end