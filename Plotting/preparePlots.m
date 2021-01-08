function [h,M, xm, ym, nx, ny] = preparePlots(h,M)
%Prepares plots with axes info that doesn't need to be repeated

    %figure('Name','streamlines');

    xmin =-0.2;
    xmax =0.2;
    ymin =-0.2;
    ymax =0.2;
    nx = 51;
    ny = 51;   

    x = xmin:((xmax-xmin)/(nx-1)):xmax;
    y = ymin:((ymax-ymin)/(ny-1)):ymax;
    [ym,xm]=meshgrid(y,x);

    
    box off
    
    xlabel('x')
    ylabel('y')
    set(gca,'Fontn','Times','FontSize',10,'linewidth',1)
    set(gca,'NextPlot','replacechildren');
    


end

