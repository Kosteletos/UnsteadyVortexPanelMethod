
function [alpha, alphaDot,flag,i] = rotation(tc, dt, optimisationFlag, deltaLift, alpha, alphaIter, iterationCounter,i)
%Defines the rotation of the plate, and its lift mitigation

t = tc*dt;
alphaPrev = alpha(tc+1);
alpha0 = alpha(tc);
flag = 0;


if optimisationFlag == 0
    
%     % Prescribed rotation
%     omega = 0.4;
%     alpha = omega*t;
%     alphaDot = omega;
    
    % Constant alpha
    alpha = 0.50; 
    alphaDot = (alpha - alpha0)/dt;
    if t == dt
        alphaDot = 0; % this is a poor fix as initial alphaDot could be non-zero
    end
    %alpha = pi/4 + 0.035;

elseif optimisationFlag == 1
    
    %%
    % Hacky method to get the job done
    
    alphaVec = alpha0-0.2:0.04:alpha0+0.2;
    if iterationCounter <= 11
        alpha = alphaVec(iterationCounter);
    elseif iterationCounter == 12
        [~,i] = min(deltaLift(2:12));
        alpha = alphaIter(i+1);
    end
    

    if iterationCounter <= 22 && iterationCounter >= 12
        alphaVec = alphaIter(i+1)-0.02:0.004:alphaIter(i+1)+0.02;
        alpha = alphaVec(iterationCounter-11);

    elseif iterationCounter == 23
        [~,i] = min(deltaLift(13:23));
        alpha = alphaIter(i+12);
    end
    
    
    if iterationCounter <= 33 && iterationCounter >= 23
        alphaVec = alphaIter(i+12)-0.002:0.0004:alphaIter(i+12)+0.002;
        alpha = alphaVec(iterationCounter-22);

    elseif iterationCounter == 34
        [~,i] = min(deltaLift(24:34));
        alpha = alphaIter(i+23);
    end
    
    
    if iterationCounter <= 44 && iterationCounter >= 34
        alphaVec = alphaIter(i+23)-0.0002:0.00004:alphaIter(i+23)+0.0002;
        alpha = alphaVec(iterationCounter-33);

    elseif iterationCounter == 45
        [~,i] = min(deltaLift(35:45));
        %alpha = (alphaIter(i) + alpha(tc) + alpha(tc-1) + alpha(tc-2))/4 ;
        alpha = alphaIter(i+34);
    end
    
    if iterationCounter <= 55 && iterationCounter >= 45
        alphaVec = alphaIter(i+34)-0.00002:0.000004:alphaIter(i+34)+0.00002;
        alpha = alphaVec(iterationCounter-44);

    elseif iterationCounter == 56
        [~,i] = min(deltaLift(46:56));
        %alpha = (alphaIter(i) + alpha(tc) + alpha(tc-1) + alpha(tc-2))/4 ;
        alpha = alphaIter(i+45);
        flag = 1;
    end
    
    
    %%
    % Lift mitigation
     %alpha = alphaPrev + deltaLift/50000000; %1000000 for 1 chords/s, 10 for 10 chords/s
     
     
     %%
%      if iterationCounter == 0
%         alpha = alpha0;
%      elseif iterationCounter == 1
%          alpha = alpha0 + 0.001;
%      elseif iterationCounter == 2
%          alpha = alpha0 -0.001;
     
         
        
%      elseif t >= 2.90% && t< 4.53&& (iterationCounter == 2 || iterationCounter == 3) % Debugging <-        delete
%           alphaVec = -pi:0.01:pi;
%           alphaVec = 0.1939:0.00001:0.940;
%           alpha = alphaVec(iterationCounter);
%             %alpha = -1;
      

%      elseif mod(iterationCounter,2) == 1
%         alpha = alphaPrev + 1e-8;     
%      else
%         m = (deltaLift(iterationCounter-1) - deltaLift(iterationCounter))/(alphaIter(iterationCounter-1) - alphaIter(iterationCounter)); 
%         alpha = alphaPrev - deltaLift(iterationCounter)/m;
%      end
%     
%     
%     if (alpha > pi) || (alpha <-0.5)
%        alpha = 0.6; 
%     end

%%
    alphaDot = (alpha - alpha0)/dt;  
else
    
    alpha = alpha0; 
    alphaDot = (alpha - alpha0)/dt;

end


end

