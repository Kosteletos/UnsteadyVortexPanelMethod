function [h,M, xm, ym, nx, ny] = preparePlots(h,M)
%Prepares plots with axes info that doesn't need to be repeated

    xmin =-2.5;
    xmax =2.5;
    ymin =-2.5;
    ymax =2.5;
    nx = 101;
    ny = 101;   

    x = xmin:((xmax-xmin)/(nx-1)):xmax;
    y = ymin:((ymax-ymin)/(ny-1)):ymax;
    [ym,xm]=meshgrid(y,x);

    axis equal
    xlabel('x')
    ylabel('y')
    set(gca,'Fontn','Times','FontSize',10,'linewidth',1)
    


end

