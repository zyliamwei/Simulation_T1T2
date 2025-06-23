clear all 
clc
close all

% Parameters to be set
numiter=2000;    % total number of simulation
gT2=20:0.5:60;    % unit: ms; longitudinal relaxation time
TE=[7.5:7.5:150];    % unit: ms; repetition time
noise=linspace(0,0.05,100);   % normalized noise level
scale=size(TE);

fun = @(beta,x)(beta(1).*exp(-x./beta(2)));
% Monte Carlo simulation
for pi=1:length(gT2)
    T2=gT2(pi);
    sig=exp(-TE./T2);     % normalized signal
    for mi=1:length(noise)
        noisetemp=noise(mi);
        for ni=1:numiter
            sigtemp=abs(sig+noisetemp.*randn(scale));
            beta=nlinfit(TE,sigtemp,fun,[1 T2]);
            T2fit(ni,mi,pi)=beta(2);
        end  
    end
    disp([num2str(pi) '-' num2str(mi)]);
end

for pi=1:length(gT2)
    cov(pi,:)=std(T2fit(:,:,pi))./mean(T2fit(:,:,pi))*100;
end
figure;imshow(cov,[0 20],'initialmag','fit');colormap(jet);colorbar;