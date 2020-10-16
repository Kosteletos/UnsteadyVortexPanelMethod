function [boundCirc] = totalBoundCirculation(LEVortex, TEVortex, gam, np)
%Sums the bound circulation

%TE Vortex release
if TEVortex == 1
    endPoint = np;
else
    endPoint = np+1;
end

% LE Vortex release
if LEVortex ==1 
    startPoint = 2;
else
    startPoint = 1;
end


boundCirc = 0;

for i = startPoint:endPoint
    boundCirc = boundCirc + gam(i);
end

end

