function streamfunction_plotting(gamma, xyPanel, xyBoundVortex, alpha_rad)

    xmin =-0.5;
    xmax =1.5;
    ymin =-0.5;
    ymax =0.5;
    nx = 101;
    ny = 81;   
    np = length(gamma)-1;

    x = xmin:((xmax-xmin)/(nx-1)):xmax;
    y = ymin:((ymax-ymin)/(ny-1)):ymax;
    [ym,xm]=meshgrid(y,x);


    
    psi = ym;
    
    
   for i = 1:np
       xV = xyBoundVortex(i,1);
       yV = xyBoundVortex(i,2);
       r = (xm-xV).^2 + (ym-yV).^2;  
       psi = psi - (gam(i)/(2*pi))*log(r);
   end

    stag = [xs(ipstag),ys(ipstag)]; 
    psi_stag = interp2(ym,xm,psi,stag(2),stag(1));
    
    c = -5:0.04:5;
    figure('Name','streamlines');
    contour(xm,ym,psi,c,'b')
    hold on
    contour(xm,ym,psi,[psi_stag,psi_stag],'r','linewidth',1)
    plot(xs,ys,'k','linewidth',2);
    plot(xv_rot, yv_rot,'g','linewidth',2);
    hold off 
    xlabel('x')
    ylabel('y')
    set(gca,'Fontn','Times','FontSize',10,'linewidth',1)
    title(strcat('Streamlines at alpha (deg) =',num2str(alpha_rad*360/(2*pi))));
    
end