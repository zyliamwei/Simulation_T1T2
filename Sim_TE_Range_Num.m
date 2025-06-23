clear all
clc
close all

% Parameters used in the simulation
T2=36;         % unit: ms; T2 of global brain tissue
fun=@(beta,x)(beta(1).*exp(-x./beta(2)));   % fitting equation
TEnum=2:40;         % total number of TE
TErange=(1:0.1:5.0)*T2;  % dynamic range of TE
niter=20;         % iteration number
noise=1/100;    % normalized noise level
noise=0;

for mi=1:length(TEnum)
    for ni=1:length(TErange)
        TE=linspace(7.5,TErange(ni),TEnum(mi));
        sig=exp(-TE./T2);
        for pi=1:niter
            sigtemp=abs(sig+noise.*randn(size(TE)));
            beta=nlinfit(TE,sigtemp,fun,[1 T2]);
            T1fit(pi,mi,ni)=beta(2);
        end
        disp([num2str(mi) '-' num2str(ni)]);
    end 
end

for mi=1:length(TErange)
    cov(mi,:)=std(T1fit(:,:,mi))./mean(T1fit(:,:,mi)).*100;
end
figure;imshow(cov,[0 10],'initialmag','fit');colormap(jet);colorbar;




