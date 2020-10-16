function [boundCirc] = totalBoundCirculation(gam, np)
%Sums the bound circulation

boundCirc = 0;

for i = 2:np
    boundCirc = boundCirc + gam(i);
end

end

