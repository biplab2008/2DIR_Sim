%%%
% calculate 2DIR for pop -delays
i_intf = 5000;
i_cf1 = 1640;i_cf2= 1665;
i_anh1=10;i_anh2=20;
i_delta_fast_1 = 0.001;i_delta_fast_2 = 0.003;
i_delta1 = 0.005;i_delta2 = 0.007;
i_pop = 1500;
i_scat = i_intf;
i_wt_scat = 1.5;
i_wt_noise = 0.075;

close all;

path = 'C:\Users\bdutta\work\Matlab\water_Matlab\Diffusion\scatter_delay\';
for k = 0:500:1000
    s2=synth2DIRMultT3(i_intf,...
        [i_cf1,i_cf2],...
        [i_anh1,i_anh2],...
        [[100,800];[100,800]], ...
        [[i_delta_fast_1,i_delta1];[i_delta_fast_2,i_delta2]], ...
        k);
    s2.spectra();
    s2.wavenumber=mean(s2.wavenumber);

    % get scattering signals
    scatter_del = i_scat;
    out=preprocess(scatter_del,s2);% 1000-5000 fs
    sc=synthScat(out.wn,s2.wavenumber,out.t);sc.spectra();%sc.plot();

    % combine signals
    %i_wt_scat = 0;
    sig_comb=combine_2d_and_scatter(s2,sc,i_wt_scat,false);
    % resize
    sig_resize=resize_2d(s2,sig_comb,32,i_wt_noise,false);
    clear sig_comb  s2 out;

    figure; 
    subplot(1,2,1);
    contourf(sig_resize.F1,sig_resize.F2,sig_resize.sig24_real,20);
    xlabel('\omega_{pump}[cm^{-1}]');ylabel('\omega_{probe}[cm^{-1}]');
    title(['real||pop delay : ',num2str(k),'fs']);
    subplot(1,2,2);contourf(sig_resize.F1,sig_resize.F2,sig_resize.sig24,20);
    xlabel('\omega_{pump}[cm^{-1}]');ylabel('\omega_{probe}[cm^{-1}]');
    title(['scat||scatter delay : ',num2str(scatter_del),'fs']);

%     print([path,'pop_',num2str(k)],'-dpng');

end