function [posPIV, velPIV, alphaPIV, alphaDotPIV] = kinematicsFromPIV(t, PIV)
%Defines the movement of the plate from the experimental tests done

tPIV = PIV.Time - PIV.Time(1);
[~,closestIdx] = min(abs(tPIV-t));

if tPIV(closestIdx)-t > 0
    pos = PIV.BodyX(closestIdx-1) +(PIV.BodyX(closestIdx)-PIV.BodyX(closestIdx-1))*(t-tPIV(closestIdx-1))/(tPIV(closestIdx)-tPIV(closestIdx-1)); 
    vel = PIV.Velocity(closestIdx-1) +(PIV.Velocity(closestIdx)-PIV.Velocity(closestIdx-1))*(t-tPIV(closestIdx-1))/(tPIV(closestIdx)-tPIV(closestIdx-1));
else
    pos = PIV.BodyX(closestIdx) +(PIV.BodyX(closestIdx+1)-PIV.BodyX(closestIdx))*(t-tPIV(closestIdx))/(tPIV(closestIdx+1)-tPIV(closestIdx)); 
    vel = PIV.Velocity(closestIdx) +(PIV.Velocity(closestIdx+1)-PIV.Velocity(closestIdx))*(t-tPIV(closestIdx))/(tPIV(closestIdx+1)-tPIV(closestIdx));
end

posPIV = [pos,0];
velPIV = [-vel,0];
alphaPIV = 0.2618;
%alphaPIV = pi/4;
alphaDotPIV = 0;


end

