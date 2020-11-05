function [posPIV, velPIV, alphaPIV, alphaDotPIV] = kinematicsFromPIV(t, dt, PIV)
%Defines the movement of the plate from the experimental tests done

tPIV = PIV.Time - PIV.Time(1);
[~,closestIdx] = min(abs(tPIV-t));
posPIV = [PIV.BodyX(closestIdx),0];
velPIV = [-PIV.Velocity(closestIdx),0];
alphaPIV = pi/4;
alphaDotPIV = 0;


end

