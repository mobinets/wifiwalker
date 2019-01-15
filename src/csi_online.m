function ret = csi_online(filename)
error(nargchk(1,1,nargin));
warning('off')

%% Open file
f = fopen(filename,'rb');
if (f < 0)
    error('Couldn''t open file %s',filename);
    return;
end

%% Initialize variables
%ret = cell(ceil(len/95),1);     % Holds the return values - 1x1 CSI is 95 bytes big, so this should be upper bound
%cur = 0;                        % Current offset into file
count = 0;
broken_perm = 0;
triangle = [1 3 6 9];
t = [0];
m = [0];
Samplerate=200;
WindowSize=Samplerate*1.6;
%WindowCSI=cell(Samplerate*0.8 ,1);
WindowBeginPoint=0;
MADT1=9;
MADT2=5;
BeginPoint=0;
EndPoint=0;

MADBeforeAll=[];


%h = plot(t,m,'EraseMode','background','MarkerSize',5);
%% Process all entries in file
while 1
    field_len = fread(f, 1, 'uint16', 0, 'ieee-be');
    code = fread(f,1);

    if (code == 187)
        bytes = fread(f, field_len-1, 'uint8=>uint8');
        if(length(bytes) ~= field_len-1)
            fclose(f);
            return;
        end
    else %skip all other info
        fread(f,field_len-1);
        continue;
    end

    if (code == 187)
        count = count + 1;
        ret{count} = read_bfee(bytes);
        perm = ret{count}.perm;
        Nrx = ret{count}.Nrx;
        if Nrx == 1 % No permuting needed for only 1 antenna
            continue;
        end
        if sum(perm) ~= triangle(Nrx) % matrix does not contain default values
            if broken_perm == 0
                broken_perm = 1;
                fprintf('WARN ONCE: Found CSI (%s) with Nrx=%d and invalid perm=[%s]\n', filename, Nrx, int2str(perm));
            end
        else
            ret{count}.csi(:,perm(1:Nrx),:) = ret{count}.csi(:,1:Nrx,:);
 %%------------------------modify begin point------------------------------
 
 if(count<WindowSize+1)
    continue;
end
 
WindowBeginPoint=WindowBeginPoint+1;
csi_trace=ret(WindowBeginPoint:WindowBeginPoint+WindowSize);

%length=1000;
mylength=WindowSize+1;

%ֻѡ���˷�������2����������3����ݴ洢��csi��
csi=zeros(mylength,2,3,30);

for i=1:1:mylength
    csi_entry=csi_trace{i};
    a=get_scaled_csi(csi_entry);
    csi(i,1,:,:)=a(1,:,:);
    csi(i,2,:,:)=a(2,:,:);
end

%�����˲���
Hd=MyButterworth;

%%�˲�
filterCSI=filter(Hd,abs(csi));

%PCA
[flength,fsender,freceiver,fcarrier]=size(filterCSI);

pcanum=4;
components=zeros(flength,fsender,freceiver,pcanum);
for i=1:fsender
    for j=1:freceiver
        [coef,score,latent,t2] = pca(squeeze(filterCSI(:,i,j,:)));
        components(:,i,j,:)=squeeze(filterCSI(:,i,j,:))*coef(:,2:5);
    end
end
J=WindowBeginPoint+WindowSize/2;
MADBefore=0;
MADAfter=0;
for k=1:pcanum
        MADBefore=MADBefore+MAD(squeeze(components(:,1,1,k)),WindowSize/2,WindowSize/2+1,'before');
        MADAfter=MADAfter+MAD(squeeze(components(:,1,1,k)),WindowSize/2,WindowSize/2+1,'after');
end

MADBeforeAll=[MADBeforeAll,MADBefore];

if(MADBefore<MADT2 && MADAfter>MADT1 && BeginPoint==0)
    BeginPoint=J
end
if(MADBefore>MADT1 && MADAfter<MADT2 && BeginPoint~=0)
    EndPoint=J
    ret=ret(BeginPoint:EndPoint);
    return
end

%%-------------------------modify end point----------------------------
        end
    end
end

ret = ret(1:count);

%% Close file
fclose(f);
end
