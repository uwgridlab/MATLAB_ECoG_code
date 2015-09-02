function [co,f]=coh(X,Y,nfft,fs)
XX=X-mean(X,2)*ones(1,size(X,2));
YY=Y-mean(Y,2)*ones(1,size(Y,2));
nsamp=size(X,1);
wind=hanning(nsamp);%wind=ones(nsamp,1);
fX=fft(XX.*(wind*ones(1,size(X,2))),nfft);
fY=fft(YY.*(wind*ones(1,size(X,2))),nfft);
cX=fX.*conj(fY);
a=sum(cX,2);
b=sum(fX.*conj(fX),2).*sum(fY.*conj(fY),2);
co=a.*conj(a)./b;
f=(0:1:(nfft-1))*fs/nfft;
f=f(:,1:round(nfft/2));
co=co(1:round(nfft/2));