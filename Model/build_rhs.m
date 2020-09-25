function rhsvec = build_rhs(xs,ys,alpha, xfsVortex, yfsVortex, gamfsVortex) 
%builds the rhs vector b of the equation A.gamma = b

np = length(xs) - 1;
%BC - Surface of body is a streamline, phi(i+1)=phi(i)
psifs = ys*cos(alpha)-xs*sin(alpha);
psiVortices = zeros(1,length(xs));

for i =1:length(xfsVortex)
    r = (xfsVortex(i)-xs).^2 + (yfsVortex(i)-ys).^2;
    psiVortices = psiVortices - gamfsVortex(i).*log(r)./(2*pi);  % defined for an anti-clockwise vortex - check the +- on this
end

psifs = psifs + psiVortices;
psifs_shift = circshift(psifs,-1); % Shifted psifs == psifs(i+1)
rhsvec = zeros(np+1,1);

%using these dimensions to leave last element empty
rhsvec(1:np) = psifs(1:np) - psifs_shift(1:np);


rhsvec(np+1) = -sum(gamfsVortex);

end