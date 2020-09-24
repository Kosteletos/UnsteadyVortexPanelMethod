function streamfunction_plotting(gamma, xs, ys, alpha_rad,ipstag)

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
    
    xy = [xs.',ys.'];
    R = [cos(alpha_rad) -sin(alpha_rad); sin(alpha_rad) cos(alpha_rad)]; % Rotation matrix
    xy_rot = xy*R;
    xs = xy_rot(:,1);
    ys = xy_rot(:,2);
    
   for i = 1:np
        gamma_a = gamma(i);
        gamma_b = gamma(i+1);
        [infa,infb] = panelinf(xs(i),ys(i),xs(i+1),ys(i+1),xm,ym);
        psi = psi + gamma_a.*infa + gamma_b.*infb;
   end

    stag = [xs(ipstag),ys(ipstag)]; 
    psi_stag = interp2(ym,xm,psi,stag(2),stag(1));
    
    c = -5:0.04:5;
    figure('Name','streamlines');
    contour(xm,ym,psi,c,'b')
    hold on
    contour(xm,ym,psi,[psi_stag,psi_stag],'r','linewidth',1)
    plot(xs,ys,'k','linewidth',2);
    %fill(xs,ys,'k');
    hold off 
    xlabel('x')
    ylabel('y')
    set(gca,'Fontn','Times','FontSize',10,'linewidth',1)
    title(strcat('Streamlines at alpha (deg) =',num2str(alpha_rad*360/(2*pi))));
    
end