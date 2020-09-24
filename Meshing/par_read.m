function [section, np, Re, alpha, nt] = par_read(parfile)
%
%  function [section np Re alpha] = par_read(parfile)
%
%    Reads in aerofoil section id and run parameters from file
%

%    Open file and read data
[fid, message] = fopen(parfile,'rt');
if fid==-1
    fprintf(1,'File %s failed to open. Error message: %s\n',parfile,message);
    return
end

inputline=fgetl(fid);
section = inputline(35:length(inputline));
disp(['Section identifier: ' section])

inputline=fgetl(fid);
np = sscanf(inputline(35:length(inputline)),'%i');
disp(['Number of panels: ' num2str(np)])

inputline=fgetl(fid);
Re = sscanf(inputline(35:length(inputline)),'%f');
disp(['Reynolds number: ' num2str(Re/1e6) ' million'])

inputline=fgetl(fid);
alfswp = inputline(35:length(inputline));
disp(['Range of incidences (degrees): ' alfswp])
alpha = eval(alfswp);

inputline=fgetl(fid);
nt = sscanf(inputline(35:length(inputline)),'%i');
disp(['Number of time steps: ' num2str(nt)])
fclose(fid);