function out=resize_2d(s2,com_sig,num,noise,verbose)

[~,p1]=min(abs(s2.f1-(s2.wavenumber-100)));
[~,p2]=min(abs(s2.f1-(s2.wavenumber+100)));
f1=linspace(s2.f1(p1),s2.f1(p2),num);
[~,p1]=min(abs(s2.f2-(s2.wavenumber-100)));
[~,p2]=min(abs(s2.f2-(s2.wavenumber+100)));
f2=linspace(s2.f2(p1),s2.f2(p2),num);

%disp(p2-p1);
[F1,F2]=meshgrid(f1,f2);
sig24=interp2(com_sig.F1,com_sig.F2,com_sig.sig,F1,F2);

sig24_real=interp2(com_sig.F1,com_sig.F2,com_sig.sig_real,F1,F2);

maxi=abs(max(sig24,[],'all'));mini=abs(min(sig24,[],'all'));
sig24=sig24+noise*randn(size(sig24));
if maxi>mini
    sig24=sig24/maxi;
else
    sig24=sig24/mini;
end


maxi=abs(max(sig24_real,[],'all'));mini=abs(min(sig24_real,[],'all'));
if maxi>mini
    sig24_real=sig24_real/maxi;
else
    sig24_real=sig24_real/mini;
end

if verbose
    figure;
    subplot(1,2,1)
    contourf(F1,F2,sig24,20);
    xlim([s2.wavenumber-100,s2.wavenumber+100]);ylim([s2.wavenumber-100,s2.wavenumber+100]);pbaspect([1,1,1]);title('scat+noise resize64x64');
    xlabel('\omega1[cm^{-1}]');ylabel('\omega3[cm^{-1}]');

    subplot(1,2,2)
    contourf(F1,F2,sig24_real,20);
    xlim([s2.wavenumber-100,s2.wavenumber+100]);ylim([s2.wavenumber-100,s2.wavenumber+100]);pbaspect([1,1,1]);title('real resize64x64');
    xlabel('\omega1[cm^{-1}]');ylabel('\omega3[cm^{-1}]');
end
%disp(size(com_sig.sig(p1:p2,p1:p2)));

out.sig24=sig24;
out.sig24_real=sig24_real;
out.F1=F1;
out.F2=F2;

end