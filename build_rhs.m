function rhsvec = build_rhs(xs,ys,alpha) 
%builds the rhs vector b of the equation A.gamma = b

np = length(xs) - 1;
psifs = ys*cos(alpha)-xs*sin(alpha);
psifs_shift = circshift(psifs,-1); % Shifted psifs == psifs(i+1)
rhsvec = zeros(np+1,1);

%using these dimensions to leave last two elements = 0
rhsvec(1:np-1) = psifs(1:np-1) - psifs_shift(1:np-1); 

end