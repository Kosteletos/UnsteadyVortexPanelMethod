function [testUV] = testUV(alpha, pos, np, gam, panelLength)
[~, xyCollocation, xyBoundVortex, ~] = makePanels(alpha, pos, np, panelLength);
testUV = zeros(np,2);

for i = 1:np
    uv = 0;
    for j = 1:np+1
        uv = uv +  inducedVelocity(gam(j),xyCollocation(i,:),xyBoundVortex(j,:));
    end
    testUV(i,:) = uv;
end

end

