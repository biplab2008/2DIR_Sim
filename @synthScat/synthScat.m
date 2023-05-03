classdef synthScat<handle
    %%
    % usage : sc=synthScat(1500:4:1700,0:4:1000);sc.spectra();sc.plot();

    %%
    properties
        cms = 2.9979 * 10^8; % speed of light in m/s
        ccmfs = 2.9979 * 10^-5;% speed of light in cm/femtoseconds
        %cmumperfs = cms * 10^6/10^15;% speed of light in micrometers/femtoseconds
        t;
        wn;
        w0;%central frequency
        scatsigT;
        scatsigW;
        wavenumber;
        om1;om3;
        dummyvar=false;

    end

    methods
        function obj=synthScat(wn,w0,t)
            obj.w0=w0;
            obj.scatsigT=zeros(length(wn),length(t));
            obj.wn=wn;
            obj.t=t;
            ccmfs=obj.ccmfs;

            for i=1:length(wn)
                wi=wn(i)-2:0.2:wn(i)+2;
                dummy=zeros(1,length(t));
                for j=1:length(wi)
                    dummy=dummy+obj.g(2*pi*wi(j) * ccmfs,t,1);
                end
                obj.scatsigT(i,:)=dummy;
            end

        end


        function spectra(obj)

            % fft
            obj.scatsigW=zeros(size(obj.scatsigT));
            
            for i=1:size(obj.scatsigW,1)
                obj.scatsigW(i,:)=fft(obj.scatsigT(i,:));
            end
            
            obj.scatsigW=real(obj.scatsigW)/max(real(obj.scatsigW),[],'all');
            
            tstep=obj.t(2)-obj.t(1);
            pointnumber = size(obj.scatsigT,2);
            freqstep = 1/ tstep/ pointnumber/ obj.ccmfs;
            freqlist = ((1:pointnumber)-1)* freqstep;
            probelist =obj.wn;
            
            takepos=round(numel(freqlist)/2);
            freqlist=freqlist(1:takepos);
            obj.scatsigW=obj.scatsigW(:,1:takepos);


            [obj.om3,obj.om1]=meshgrid(probelist,freqlist);

            obj.dummyvar=true;
        end

        function plot(obj)
            if ~obj.dummyvar;error('aborted : run spectra method first');end
            figure;
            cmmin=obj.w0-100;cmmax=obj.w0+100;
            clevel=linspace(-1,1,20);
            contourf(obj.om3,obj.om1,real(obj.scatsigW).',clevel);ylim([cmmin,cmmax]);xlim([cmmin,cmmax]);
            xlabel('\omega3[cm^{-1}]');xlabel('\omega1[cm^{-1}]');
            pbaspect([1,1,1]);

        end
    end


    methods(Access=private)
        function out=g(obj,omega,dt,beta) 
            
            out=beta.^2+2*beta*cos(omega.*dt);
       
        end


    end




















end