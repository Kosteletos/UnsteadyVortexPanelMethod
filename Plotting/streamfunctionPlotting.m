function [M,h] = streamfunctionPlotting(M,h, xm, ym, nx, ny, alpha_rad, pos, vel, gam , xygFSVortex_rel, np, t, dt, panelLength, Streamlines)
 
    [xyPanel, ~, xyBoundVortex, ~] = makePanels(alpha_rad, pos, np, panelLength);
    
    %Rel frame to inertial frame transform
    inerToRel = [cos(alpha_rad), sin(alpha_rad); -sin(alpha_rad), cos(alpha_rad)]; % inertial frame to relative frame
    
    if size(xygFSVortex_rel) ~= 0 
        xygFSVortex_rel(:,1:2) = (inerToRel*xygFSVortex_rel(:,1:2).').' + pos;
    end
    
    figure(h);
    cla
    axis equal
    
      
    
    if Streamlines == 1
    
        psi = zeros([nx,ny]);

        % psi due to bound vorticity
        for i = 1:np+1
            xV = xyBoundVortex(i,1);
            yV = xyBoundVortex(i,2);
            r = sqrt((xm-xV).^2 + (ym-yV).^2);  
            psi = psi - (gam(i)/(2*pi))*log(r);
        end

        % psi due to free stream vortices
        inputSize = size(xygFSVortex_rel);
        for i = 1:inputSize(1)
            xV = xygFSVortex_rel(i,1);
            yV = xygFSVortex_rel(i,2);
            gam_fsv = xygFSVortex_rel(i,3);
            r = sqrt((xm-xV).^2 + (ym-yV).^2);  
            psi = psi - (gam_fsv/(2*pi))*log(r);
        end
        
        contour(xm,ym,psi,50,'g')
    end
   

    hold on
    
    %quiver(xyCollocation(:,1),xyCollocation(:,2),uv_vec(:,1),uv_vec(:,2) );
    
    if size(xygFSVortex_rel) ~= 0
        pos = xygFSVortex_rel(:,3)>0;
        scatter(xygFSVortex_rel(pos,1), xygFSVortex_rel(pos,2),[], 'b', 'x', 'linewidth',1);
        scatter(xygFSVortex_rel(~pos,1), xygFSVortex_rel(~pos,2),[], 'r', 'x', 'linewidth',1);


    end
    plot(xyPanel(:,1),xyPanel(:,2),'k','linewidth',2);
    hold off 
    title(strcat('alpha (deg) = ',num2str(alpha_rad*180/pi,3), ';  V = [', num2str(vel(1)),', ',num2str(vel(2)), '];  t = ', num2str(t), ';  dt = ', num2str(dt), ';  Np = ', num2str(np)));
    xlim([-0.3, 0.3]) 
    %ylim([-0.08, 0.08])
    
    set(gca,'visible','off')
    filename = 'test.gif';
    
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    if t == dt
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','DelayTime',0.1,'WriteMode','append');
    end
        
    
end