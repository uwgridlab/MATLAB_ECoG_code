function ok = nnfexist(d)
%NNFEXIST Neural Network Design utility function.

% Copyright 1994-2011 Martin T. Hagan
% $Revision: 1.6.4.2 $
% First Version, 8-31-95.


%==================================================================

ok = exist('hardlim');

if ~ok

  % FIND WINDOW IF IT EXISTS
  fig = nnfgflag('Warning');
  if ~isempty(fig)
    delete(fig)
  end

  % NEW FIG
  fig = figure('visible','off');

  % GET SCREEN SIZE
  su = get(0,'units');
  set(0,'units','points');
  ss = get(0,'ScreenSize');
  set(0,'units',su);
  left = ss(1);
  bottom = ss(2);
  width = ss(3);
  height = ss(4);

  % CENTER FIGURE ON SCREEN

  x = 310;
  y = 160;
  pos = [(width-x)/2+left, (height-y)/2+bottom, x y];

  set(fig,...
    'units','points',...
    'position',pos, ...
    'resize','off', ...
    'color',nnltgray,...
    'inverthardcopy','off', ...
    'nextplot','add',...
    'visible','off',...
    'name','Warning',...
    'numbertitle','off');
  
  % FIGURE AXIS
  fig_axis = nnsfo('a0');

  % BORDER LINE
  plot([0 0 310 310 0],[0 159 159 0 0],'color',nnblack)

  % TITLE
  text(35,140,'Neural Network', ...
    'color',nnblack, ...
    'fontname','times', ...
    'fontsize',16, ...
    'fontangle','italic', ...
    'fontweight','bold');
  text(35,120,'Design',...
    'color',nnblack, ...
    'fontname','times', ...
    'fontsize',20, ...
    'fontweight','bold');

  % TOP LINE
  nndrwlin([0 215],[105 105],4,nndkblue);

  % NOTE
  text(35,85,['Demo "' upper(d) '" requires either the'],...
    'color',nndkblue, ...
    'fontname','helvetica', ...
    'fontsize',14);

  text(35,67,'MININNET functions on the NND disk',...
    'color',nndkblue, ...
    'fontname','helvetica', ...
    'fontsize',14);
  
  text(35,49,' or Neural Network Toolbox.',...
    'color',nndkblue, ...
    'fontname','helvetica', ...
    'fontsize',14);

  uicontrol(...
    'units','points',...
    'position',[120 10 60 20],...
    'string','OK',...
    'callback','close')

  set(fig,'color',nnltgray','nextplot','new')

  % BEEP
  s = nndsnd(6);
  set(fig,'visible','on');
  nnsound(s,8192);
  drawnow
  nnsound(s,8192);
end
