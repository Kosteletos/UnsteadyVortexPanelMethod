close all
clear all

t = 10;
dt = 0.2;
np = 0;
xyPanel = [];
xyBoundVortex = [];
gam = [];
xygFSVortex = [0.5,0.5,1; 0.5,-0.5,-1; -0.5,0.5,-1 ; -0.5,-0.5,1 ];

linkdata on
axis equal

n = t/dt;

for i =1:n
    
    xy1(i,:)= xygFSVortex(1,1:2);
    xy2(i,:)= xygFSVortex(2,1:2);
    xy3(i,:)= xygFSVortex(3,1:2);
    xy4(i,:)= xygFSVortex(4,1:2);
    plot(xy1(:,1),xy1(:,2));
    hold on
    plot(xy2(:,1),xy2(:,2));
    plot(xy3(:,1),xy3(:,2));
    plot(xy4(:,1),xy4(:,2));
                
    hold off
    
    xygFSVortex = biotSavart(dt, np, xyPanel, xyBoundVortex, gam, xygFSVortex);

    
end
xy1