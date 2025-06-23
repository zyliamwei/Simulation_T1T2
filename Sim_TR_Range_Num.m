clear all
clc
close all

% Parameters used in the simulation
T1=2000;         % unit: ms; T1 of global brain tissue
fun=@(beta,x)(beta(1).*(1-exp(-x./beta(2))));   % fitting equation
TRnum=2:40;         % total number of TR
TRrange=(1:0.1:5.0)*T1;  % dynamic range of TR
niter=20;         % iteration number
noise=1/100;    % normalized noise level
noise=0;

for mi=1:length(TRnum)
    for ni=1:length(TRrange)
        TR=linspace(300,TRrange(ni),TRnum(mi));
        sig=1-exp(-TR./T1);
        for pi=1:niter
            sigtemp=abs(sig+noise.*randn(size(TR)));
            beta=nlinfit(TR,sigtemp,fun,[1 T1]);
            T1fit(pi,mi,ni)=beta(2);
        end
        disp([num2str(mi) '-' num2str(ni)]);
    end 
end

for mi=1:length(TRrange)
    cov(mi,:)=std(T1fit(:,:,mi))./mean(T1fit(:,:,mi)).*100;
end
figure;imshow(cov,[0 20],'initialmag','fit');colormap(jet);colorbar;





