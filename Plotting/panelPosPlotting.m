function  panelPosPlotting(xyPanel, xyCollocation, xyBoundVortex)


    scatter(xyPanel(:,1), xyPanel(:,2), 'filled');
    %plot(xyPanel(:,1), xyPanel(:,2),'-o');
    axis equal
    hold on;
    %plot(xyCollocation(:,1), xyCollocation(:,2),'-o');
    %plot(xyBoundVortex(:,1), xyBoundVortex(:,2),'-o');
    scatter(xyCollocation(:,1), xyCollocation(:,2), 'filled');
    scatter(xyBoundVortex(:,1), xyBoundVortex(:,2), 'filled');
    hold off;


end

