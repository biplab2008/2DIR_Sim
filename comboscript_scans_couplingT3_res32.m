%% script to generate scattering+2D+noise, scattering+2D(without noise), real 2DIR signal
% total signal : 
% interferometer_scan x central freq 1 x central freq 2 x anh1 x anh2 x delta_fast_1 x delta_fast_2 x delta_slow_1 x delta_slow_2 x pop_delay x scatter_delay x weight_scatter x weight_noise
% (2 * 2 * 2 * 2 * 2 * 2 * 2 * 5 * 5 * 3 *3 *3 * 3) = 259200
%%%%%%
% int scan : [5000 , 6000] - 2x
% peak1 = 1610 - 1630 -2x
% peak2 = 1645 - 1680 -2x
% anh1 = 10 - 30 -2x
% anh2 = 10 - 30 -2x
% pop : 200 -1500 -5x
% noise : 0.01 - 0.05 -3x
% scatter weight : 1-2 -5x
% fixed taus : [200,500]
% peak1 del1 (slow1) : upto max.008, -3x
% peak1 del2 (fast) : .008
% peak2 del1 (slow1) : upto max 0.008, -3x
% peak2 del2 (fast) : .008
% preprocess : [int scan -1000,int scan +1000] -5x

%% list of parameters
interfer_scan_list=[5000,6000];
cf1=linspace(1620,1635,10);
cf2=linspace(1640,1675,10);

% cf1=linspace(1630,1635,10);
% cf2=linspace(1665,1670,10);

anh_list=linspace(10,40,20);
delta_list_fast =[0.001,0.003];
delta_list=linspace(0.003,.007,15);
pop_delay_list=linspace(200,1200,20);
scatter_delay_list=linspace(2000,5000,20);
weight_scatter_list=linspace(1,2,10);
weight_noise_list=linspace(0.01,0.07,10);



num=32;
num_interfer_scan=2; % choose interferometer scan
num_cf1=2;%central freq 1
num_cf2=2;%central freq 2
num_anh=2;% choose 2 anharmonicities
num_pop_delay=3;% choose pop delays
num_weight_noise=3;% choose weigh of noise
num_weight_scatter=3;% choose weight of scatter sig
num_delta=5;% choose number of weights
num_scatter_delay=3;% choose scatter delay


get_list=@(list,val) list(randperm(length(list),val));

path='D:\All_files\Matlab\water_Matlab\data_broad_zn_res32\';
path_real='D:\All_files\Matlab\water_Matlab\data_broad_zn_res32\real\';
path_scat='D:\All_files\Matlab\water_Matlab\data_broad_zn_res32\scat\';
path_zn='D:\All_files\Matlab\water_Matlab\data_broad_zn_res32\zn\';
path_f1='D:\All_files\Matlab\water_Matlab\data_broad_zn_res32\f1\';
path_f2='D:\All_files\Matlab\water_Matlab\data_broad_zn_res32\f2\';

% fid=fopen('save_params_1.txt','w');
% if fid==-1;error('file could not be opened');end
%% test classes
idx=0;
tic;

for i_intf=interfer_scan_list% interferometer scan
    scatter_delay_list=linspace(i_intf-1000,i_intf+1000,15);

    cf1_scan=get_list(cf1,num_cf1);
    for i_cf1=cf1_scan % central frequency

        cf2_scan=get_list(cf2,num_cf2);
        for i_cf2=cf2_scan % central frequency

            anh_scan1=get_list(anh_list,num_anh);
            for i_anh1=anh_scan1 % anharmonicty

                anh_scan2=get_list(anh_list,num_anh);
                for i_anh2=anh_scan2 % anharmonicty

                    for i_delta_fast_1 = delta_list_fast

                        for i_delta_fast_2 = delta_list_fast

                            delta1_scan=get_list(delta_list,num_delta);
                            for i_delta1=delta1_scan % delta2 for peak 1

                                delta2_scan=get_list(delta_list,num_delta);
                                for i_delta2=delta2_scan % delta2 for peak 2

                                    pop_delay=get_list(pop_delay_list,num_pop_delay);
                                    for i_pop=pop_delay% pop delay

                                        scatter_delay=get_list(scatter_delay_list,num_scatter_delay);
                                        for i_scat=scatter_delay% scattering delay

                                            weight_scatter=get_list(weight_scatter_list,num_weight_scatter);
                                            for i_wt_scat=weight_scatter% weight scatter

                                                weight_noise=get_list(weight_noise_list,num_weight_noise);
                                                for i_wt_noise=weight_noise % weight noise

                                                    % get 2d ir signals
                                                    s2=synth2DIRMultT3(i_intf,...
                                                        [i_cf1,i_cf2],...
                                                        [i_anh1,i_anh2],...
                                                        [[100,800];[100,800]], ...
                                                        [[i_delta_fast_1,i_delta1];[i_delta_fast_2,i_delta2]], ...
                                                        i_pop);
                                                    s2.spectra();
                                                    s2.wavenumber=mean(s2.wavenumber);

                                                    % get scattering signals
                                                    out=preprocess(i_scat,s2);% 1000-5000 fs
                                                    sc=synthScat(out.wn,s2.wavenumber,out.t);sc.spectra();%sc.plot();

                                                    % combine signals
                                                    %i_wt_scat = 0;
                                                    sig_comb=combine_2d_and_scatter(s2,sc,i_wt_scat,false);
                                                    % resize
                                                    sig_resize=resize_2d(s2,sig_comb,num,i_wt_noise,false);

                                                    %% scatter+ 2D signal (zero noise)
                                                    sig_resize_zn=resize_2d(s2,sig_comb,num,0,false);

                                                    % save signals
%                                                     writematrix(sig_resize.sig24,[path_scat,'sig_scat_',num2str(idx),'.csv']);
%                                                     writematrix(sig_resize.sig24_real,[path_real,'sig_real_',num2str(idx),'.csv']);
%                                                     writematrix(sig_resize_zn.sig24,[path_zn,'sig_zn_',num2str(idx),'.csv']);
%                                                     writematrix(sig_resize.F1,[path_f1,'sig_f1_',num2str(idx),'.csv']);
%                                                     writematrix(sig_resize.F2,[path_f2,'sig_f2_',num2str(idx),'.csv']);
                                                    idx = idx +1;

                                                    if idx >1;disp('breaking');break;end
                                                    if mod(idx,500)==0;disp(['scan no: ', num2str(idx)]);end
%                                                     if idx >200
%                                                         toc;
%                                                         return;
%                                                     end

%                                                     fprintf(fid,'%6d %6f %6f %6f %6f %6f %6f %6f %6f %6f %6f %6f\n',idx,i_cf1,i_cf2,i_anh1,i_anh2,i_delta1,i_delta2,i_pop,i_intf,i_scat,i_wt_scat,i_wt_noise);
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
fclose(fid);
%toc;