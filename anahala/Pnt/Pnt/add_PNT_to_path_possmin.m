global HOME
HOME = 'C:/anahala/Pnt/Pnt';

files = {'CPDs', 'general', 'misc', 'graph', 'graphdraw', ...
	 'inference', 'interface', 'inference/static', ...
	 'potentials', 'potentials/Tables'};
 
eval(sprintf('addpath %s', HOME));
for i=1:length(files)
  f = files{i};
  eval(sprintf('addpath %s/%s', HOME, f));
end
