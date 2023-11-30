function BestMea=BestMeasure(T,cl,n)
import java.util.LinkedList
import Library.*
NMI = aNMI(T,cl);
RI =aCalculate_Cluster_RandIndex(T,cl);
ARI =aARI(T,cl,n);
ACC1 =aACC1(T,cl);
AMI =aAMI1(T,cl);
FMI=GetFmi(T,cl);
BestMea=[ACC1,NMI,ARI,AMI,RI,FMI];
end