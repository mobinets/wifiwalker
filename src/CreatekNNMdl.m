function CreatekNNMdl( WalkerID ,HumanNum)

FeatureSize=432;
TrainDataNum=10;


TrainData=zeros(TrainData,FeatureSize);
csi_trace=csi_onlineSetNums('/home/zzf/linux-80211n-csitool-supplementary/netlink/cs1.dat');
TrainData(i,:)=GetDWTcomponents(csi_trace);


end

