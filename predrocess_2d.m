function y=predrocess_2d(out)
    % angular frequencies & means
    % add random jitter to mean
    % angular frequencies & means
    % add random jitter to mean
    x1=2*pi*3*10.^10.*out.w1a/1e12;
    x2=2*pi*3*10.^10.*out.w3a/1e12;
    y.mean_x1=mean(x1(x1>0)); % mean_x1=mean_x1-mean_x1*0.2;% add random jitter to central freq where phase is 2pi
    y.mean_x2=mean(x2(x2>0));
    % HR meshgrid
    [om1,om3]=meshgrid(x1,x2);

    y.om1=om1;y.om3=om3;

   
    w3i=out.w3;w1i=out.w1;
    [X_32,Y_32]=meshgrid(linspace(w3i(1),w3i(end),32),linspace(w1i(1),w1i(end),32));
    [X_org,Y_org]=meshgrid(w3i,w1i);

    y.xorg=X_org;
    y.yorg=Y_org;
    y.x32=X_32;
    y.y32=Y_32;
   

end