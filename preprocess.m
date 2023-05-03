function out=preprocess(interferometer_scan,s2)
%%
% based on s2 and interferometer sets time and frequency

ccmfs = 2.9979 * 10^-5;% speed of light in cm/femtoseconds
lim = interferometer_scan;% changing interferometer range changes lineshape
wavenumber=s2.wavenumber;
s=0;
undersampling = 2 *s + 1;
step = 1/(4 *wavenumber * ccmfs) * undersampling; % modulate undersampling
t= 0:step:lim;
t=t(1:end-1);% remove last elements to be consistent with mathematica
wn=linspace(s2.f1(1),s2.f1(end),size(s2.helpR,2)*2);

out.t=t;
out.wn=wn;

end