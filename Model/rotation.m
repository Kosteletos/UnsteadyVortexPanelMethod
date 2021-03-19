
function [alphaOut, alphaDot,flag,i] = rotation(tc, dt, optimisationFlag, deltaLift, alpha, alphaIter, iterationCounter,i)
%Defines the rotation of the plate, and its lift mitigation

t = tc*dt;
alphaPrev = alpha(tc+1);
alpha0 = alpha(tc);
flag = 0;


if optimisationFlag == 0
    
%     % Prescribed rotation
%     omega = 0.01;
%     alphaOut = omega*t;
%     alphaDot = omega;
    
%     omega = 0.3;
%     alphaOut = 0.5*sin(omega*t);
%     alphaDot = 0.5*omega*cos(omega*t);

    % Constant alpha
    alphaOut = 0.261799; 
    alphaDot = (alphaOut - alpha0)/dt;
    if t == dt
        alphaDot = 0; % this is a poor fix as initial alphaDot could be non-zero
    end


elseif optimisationFlag == 1
    
    %%
%     % Hacky method to get the job done
%     
%     alphaVec = alpha0-0.2:0.04:alpha0+0.2;
%     if iterationCounter <= 11
%         alphaOut = alphaVec(iterationCounter);
%     elseif iterationCounter == 12
%         [~,i] = min(deltaLift(2:12));
%         alphaOut = alphaIter(i+1);
%     end
%     
% 
%     if iterationCounter <= 22 && iterationCounter >= 12
%         alphaVec = alphaIter(i+1)-0.02:0.004:alphaIter(i+1)+0.02;
%         alphaOut = alphaVec(iterationCounter-11);
% 
%     elseif iterationCounter == 23
%         [~,i] = min(deltaLift(13:23));
%         alphaOut = alphaIter(i+12);
%     end
%     
%     
%     if iterationCounter <= 33 && iterationCounter >= 23
%         alphaVec = alphaIter(i+12)-0.002:0.0004:alphaIter(i+12)+0.002;
%         alphaOut = alphaVec(iterationCounter-22);
% 
%     elseif iterationCounter == 34
%         [~,i] = min(deltaLift(24:34));
%         alphaOut = alphaIter(i+23);
%     end
%     
%     
%     if iterationCounter <= 44 && iterationCounter >= 34
%         alphaVec = alphaIter(i+23)-0.0002:0.00004:alphaIter(i+23)+0.0002;
%         alphaOut = alphaVec(iterationCounter-33);
% 
%     elseif iterationCounter == 45
%         [~,i] = min(deltaLift(35:45));
%         alphaOut = alphaIter(i+34);
%     end
%     
%     if iterationCounter <= 55 && iterationCounter >= 45
%         alphaVec = alphaIter(i+34)-0.00002:0.000004:alphaIter(i+34)+0.00002;
%         alphaOut = alphaVec(iterationCounter-44);
% 
%     elseif iterationCounter == 56
%         [~,i] = min(deltaLift(46:56));
%         alphaOut = alphaIter(i+45);
%     end
%     
%     if iterationCounter <= 66 && iterationCounter >= 56
%         alphaVec = alphaIter(i+45)-0.000002:0.0000004:alphaIter(i+45)+0.000002;
%         alphaOut = alphaVec(iterationCounter-55);
% 
%     elseif iterationCounter == 67
%         [~,i] = min(deltaLift(57:67));
%         alphaOut = alphaIter(i+56);
%     end
%     
%     if iterationCounter <= 77 && iterationCounter >= 67
%         alphaVec = alphaIter(i+56)-0.0000002:0.00000004:alphaIter(i+56)+0.0000002;
%         alphaOut = alphaVec(iterationCounter-66);
% 
%     elseif iterationCounter == 78
%         [~,i] = min(deltaLift(68:78));
%         %alphaOut = (alphaIter(i+56) + alpha(tc) + alpha(tc-1) + alpha(tc-2))/4 ;
%         alphaOut = alphaIter(i+67);
%         flag = 1;
%     end
    
    %%
    % Lift mitigation
     %alphaOut = alphaPrev + deltaLift/50000000; %1000000 for 1 chords/s, 10 for 10 chords/s
     
     
     %%
     if iterationCounter == 0
        alphaOut = alpha0;
     elseif iterationCounter == 1
         alphaOut = alpha0 + 0.001;
     elseif iterationCounter == 2
         alphaOut = alpha0 -0.001;
     
         
        
%      elseif t >= 2.90% && t< 4.53&& (iterationCounter == 2 || iterationCounter == 3) % Debugging <-        delete
%           alphaVec = -pi:0.01:pi;
%           alphaVec = 0.1939:0.00001:0.940;
%           alphaOut = alphaVec(iterationCounter);
%             %alphaOut = -1;
      

     elseif mod(iterationCounter,2) == 1
        alphaOut = alphaPrev + 1e-8;     
     else
        m = (deltaLift(iterationCounter-1) - deltaLift(iterationCounter))/(alphaIter(iterationCounter-1) - alphaIter(iterationCounter)); 
        alphaOut = alphaPrev - deltaLift(iterationCounter)/m;
     end
    
    
    if (alphaOut > pi) || (alphaOut <-0.5)
       alphaOut = 0.6; 
    end

%%
    alphaDot = (alphaOut - mean(alpha(tc-5:tc)))/dt;  
    %alphaDot = (alphaOut - alpha0)/dt;  
    %alpha = smooth(alpha,10);
    %alphaDot = (-2*alpha(tc-2) +9*alpha(tc-1) -18*alpha(tc) + 11*alphaOut)/(6*dt);
else
    
    alphaOut = alpha0; 
    alphaDot = (alphaOut - alpha0)/dt;

end


end

