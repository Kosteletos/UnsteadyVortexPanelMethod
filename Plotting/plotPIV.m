xGrid = PIV.xi;
yGrid = PIV.yi;

timeIndex = 753;

ui = PIV.Ui(:,:,timeIndex);
vi = PIV.Vi(:,:,timeIndex);

bodySurfaceX = PIV.BodySurfaceX(timeIndex,:);
bodySurfaceY = PIV.BodySurfaceY(timeIndex,:);

quiver(xGrid, yGrid, ui, vi);
hold on
fill(bodySurfaceX, bodySurfaceY,'b');

hold off
