% clear all
% clc
% close all

% Parameters used in the simulation
gT1=1000:100:3000;         % unit: ms; T1 of global brain tissue
fun=@(beta,x)(beta(1).*(1-exp(-x./beta(2))));   % fitting equation
noise=linspace(0,0.05,50);   % normalized noise level
niter=1000;         % iteration number

% % Using equidistant TR
% TR=[5500 3000 1500 800 500 300];    % unit: ms; repetition time
% for pi=1:length(gT1)
%     T1=gT1(pi);
%     sig=1-exp(-TR./T1);
%     for ni=1:length(noise)
%         for mi=1:niter
%             sigtemp=abs(sig+noise(ni).*randn(size(TR)));
%             beta=nlinfit(TR,sigtemp,fun,[1 T1]);
%             T1fit(mi,ni,pi)=beta(2);
%         end
%     end
%     disp([num2str(pi) '/' num2str(length(gT1))]);
% end
% 
% for pi=1:length(gT1)
%     cov1(pi,:)=std(T1fit(:,:,pi))./mean(T1fit(:,:,pi)).*100;
% end
% figure;imshow(cov1,[0 20],'initialmag','fit');colormap(jet);colorbar;
% 
% % Using nonequidistant TR
% TR=linspace(300,5500,6);    % unit: ms; repetition time
% for pi=1:length(gT1)
%     T1=gT1(pi);
%     sig=1-exp(-TR./T1);
%     for ni=1:length(noise)
%         for mi=1:niter
%             sigtemp=abs(sig+noise(ni).*randn(size(TR)));
%             beta=nlinfit(TR,sigtemp,fun,[1 T1]);
%             T1fit(mi,ni,pi)=beta(2);
%         end
%     end
%     disp([num2str(pi) '/' num2str(length(gT1))]);
% end
% 
% for pi=1:length(gT1)
%     cov2(pi,:)=std(T1fit(:,:,pi))./mean(T1fit(:,:,pi)).*100;
% end
% figure;imshow(cov2,[0 20],'initialmag','fit');colormap(jet);colorbar;

% Statistical analyses
T1=gT1.'*ones(1,length(noise));
T1=T1(:);
T1=[T1;T1;];
noise=ones(length(gT1),1)*noise;
noise=noise(:);
noise=[noise;noise;];
cov=[cov1(:);cov2(:);];
scheme=[ones(length(cov1(:)),1);zeros(length(cov1(:)),1);];
ds=dataset(T1,noise,cov,scheme);
lm=fitlm(ds,'cov ~ T1 + noise + scheme')




