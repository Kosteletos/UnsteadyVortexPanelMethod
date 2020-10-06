function streamfunction_plotting(gam, xyPanel, xyBoundVortex, alpha_rad, np)

    xmin =-1.5;
    xmax =2.5;
    ymin =-1.5;
    ymax =1.5;
    nx = 101;
    ny = 81;   

    x = xmin:((xmax-xmin)/(nx-1)):xmax;
    y = ymin:((ymax-ymin)/(ny-1)):ymax;
    [ym,xm]=meshgrid(y,x);

    
    psi = ym;
    
   for i = 1:np
       xV = xyBoundVortex(i,1);
       yV = xyBoundVortex(i,2);
       r = sqrt((xm-xV).^2 + (ym-yV).^2);  
       psi = psi - (gam(i)/(2*pi))*log(r);
   end

    
    c = -5:0.04:5;
    figure('Name','streamlines');
    contour(xm,ym,psi,c,'b')
    hold on
    plot(xyPanel(:,1),xyPanel(:,2),'k','linewidth',2);
    hold off 
    xlabel('x')
    ylabel('y')
    set(gca,'Fontn','Times','FontSize',10,'linewidth',1)
    title(strcat('Streamlines at alpha (deg) =',num2str(alpha_rad*180/pi)));
    
end