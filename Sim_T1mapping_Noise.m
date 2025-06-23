clear all 
clc
close all

% Parameters to be set
numiter=2000;    % total number of simulation
gT1=1000:20:3000;    % unit: ms; longitudinal relaxation time
TR=[5500 3000 1500 800 500 300];    % unit: ms; repetition time
noise=linspace(0,0.05,100);   % normalized noise level
scale=size(TR);

fun = @(beta,x)(beta(1).*(1-exp(-x./beta(2))));
% Monte Carlo simulation
for pi=1:length(gT1)
    T1=gT1(pi);
    sig=1-exp(-TR./T1);     % normalized signal
    for mi=1:length(noise)
        noisetemp=noise(mi);
        for ni=1:numiter
            sigtemp=abs(sig+noisetemp.*randn(scale));
            beta=nlinfit(TR,sigtemp,fun,[1 T1]);
            T1fit(ni,mi,pi)=beta(2);
        end
        disp([num2str(pi) ' ' num2str(mi)]);
    end
end

for pi=1:length(gT1)
    cov(pi,:)=std(T1fit(:,:,pi))./mean(T1fit(:,:,pi))*100;
end
figure;imshow(cov,[0 40],'initialmag','fit');colorbar;colormap(jet);