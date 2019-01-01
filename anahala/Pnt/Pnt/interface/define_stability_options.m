

load define_stability_options

h0 = figure('Color',[0.8 0.8 0.8], ...
	'Colormap',mat0, ...
	'FileName','C:\MATLABR11\work\kk.m', ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[105 227 400 292], ...
	'Tag','Fig1', ...
    'MenuBar','none', ...
    'ToolBar','none');

hh1 = uicontrol('Parent',h0, ...
    'Callback', 'set_options_nodes',...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[93 154.5 112.5 22.5], ...
	'String', 'SSP|Two-nodes|Three-nodes|n-best-nodes|n-nodes',...
	'Style','popupmenu', ...
	'Tag','PopupMenu1');

h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[93 186.75 112.5 18], ...
    'String','Nodes number in stabilization', ...
	'Style','text', ...
   	'ForegroundColor',[0 0 1], ...
	'Tag','StaticText1');

h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[93.75 126 112.5 18], ...
    'String','Nodes type', ...
	'Style','text', ...
   	'ForegroundColor',[0 0 1], ...
	'Tag','StaticText1');

hhh1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[93.75 93.75 112.5 22.5], ...
   	'String','Parents|Children|Parents-Children|Neighbors', ...
	'Style','popupmenu', ...
    'Enable','off',...
	'Tag','PopupMenu2');

h1 = uicontrol('Parent',h0, ...
    'Callback', 'get_stability_options',...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[57 32.25 57 24.75], ...
   	'String','Ok', ...
	'Tag','Pushbutton1');

h1 = uicontrol('Parent',h0, ...
    'Callback', 'Close',...
	'Units','points', ...
	'ListboxTop',0, ...
	'Position',[186.75 32.25 57 24.75], ...
    'String','Cancel', ...
	'Tag','Pushbutton1');

%if nargout > 0, fig = h0; end
