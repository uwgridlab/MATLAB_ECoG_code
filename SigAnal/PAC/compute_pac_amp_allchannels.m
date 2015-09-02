function map_all=compute_pac_amp_allchannels(data,fwx,fwy,fs,varargin)

if nargin>4
    nseg=varargin{1};
end
if nargin>5
    normal=varargin{2};
end

if nseg>1
    seglength=floor(size(data,1)/nseg);
else
    seglength=size(data,1);
end
nc=size(data,2);
map_all=zeros(numel(fwx),numel(fwy),nc,nc,nseg);

[~,~,px,~]=time_frequency_wavelet(data,fwx,fs,1,1,'CPUtest');
[~,~,ay,~]=time_frequency_wavelet(data,fwy,fs,1,1,'CPUtest','cmor1.5-2');

px=px./abs(px);
ay=abs(ay);

for j=1:nc
    for k=1:nc
            ixs=(1:seglength);

        for i=1:nseg
            pacmap=abs(px(ixs,:,j)'*ay(ixs,:,k));
            if strcmp(normal,'norm')
                pacmap=pacmap./repmat(sum(ay(ixs,:,k)),size(pacmap,1),1);
            end
            map_all(:,:,j,k,i)=pacmap;
            ixs=ixs+seglength;
        end
    end

end


