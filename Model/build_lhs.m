function lhsmat = build_lhs(xs,ys) 
%builds the lhs matrix A of the equation A.gamma = b
np = length(xs) - 1;
psip = zeros(np,np+1); 

% calculates intermediate psi matrix, populating each column at a time.


%populating first and last columns
[infa, infb] =  panelinf(xs(1),ys(1),xs(2),ys(2),xs(1:np),ys(1:np));
psip(:,1) = infa;
inf_b_prev = infb;
    
[~, infb] =  panelinf(xs(np),ys(np),xs(np+1),ys(np+1),xs(1:np),ys(1:np));
psip(:,np+1) = infb;


%looping over the columns of psi to fill middle columns 
for j = 2:np
    [infa, infb] =  panelinf(xs(j),ys(j),xs(j+1),ys(j+1),xs(1:np),ys(1:np));
    psip(:,j) = infa + inf_b_prev;
    inf_b_prev = infb;
end


% Build A (lhsmat) from psi_p and a shifted Psi_p
lhsmat = zeros(np+1,np+1);

psip_shift = circshift(psip,-1,1); % Shifted psip == psip(i+1,j)
lhsmat(1:np-1,:) = psip_shift(1:np-1,:)-psip(1:np-1,:); %these dimensions to leave final rows zeros

lhsmat(np,1) = 1;
lhsmat(np,2) = -1;
lhsmat(np,3)=1/2;
lhsmat(np,np-1) = -1/2;
lhsmat(np,np) = 1;


lhsmat(np+1,1)=1;
%lhsmat(np+1,2) = -1;
%lhsmat(np+1,3)=1/2;
%lhsmat(np+1,np-1) = -1/2;
%lhsmat(np+1,np) = 1;
lhsmat(np+1,np+1) = 1;
end

