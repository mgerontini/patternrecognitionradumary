%AnimateCharacter(xybpoints)
%or
%AnimateCharacter(xybpoints,ax)
%or
%AnimateCharacter(xybpoints,ax,delay)
%or
%AnimateCharacter(xybpoints,ax,delay,allxy)
%
%Animates drawn characters from pen trace data
%
%Usage:
%Recreates a character drawn using DrawCharacter from the corresponding
%mouse trace data series, using an animation. The location and style of
%the plot can be set through optional arguments.
%
%Input:
%xybpoints= Mouse trace information matrix, as returned by DrawCharacter.
%ax=        (Optional) An axis in which to draw the character. Turn HOLD
%           on for best results. A new canvas is created if the ax
%           argument is absent or empty.
%delay=     (Optional) A delay, in milliseconds, for each frame of the
%           animation. The default is 20 ms, corresponding to 50 fps.
%allxy=     (Optional) If this argument is given and true, mouse trace
%           from when the pen was lifted will also be shown, dotted,
%           while traces while drawing are shown with solid lines. This
%           works best if the style argument does not specify a line style.
%
%Gustav Eje Henter 2012-08-26 tested

function AnimateCharacter(xybpoints,ax,delay,allxy)

if (nargin < 1) || isempty(xybpoints),
    return; % Do nothing
end

if (nargin < 2) || isempty(ax),
    
    % Create canvas
    fh = figure();
    axis([0 1 0 1]);
    ah = gca;
    
    figpos = get(fh,'Position');
    figside = min(figpos(3:4));
    set(fh,'Position',[figpos(1:2),[1,1]*figside]);
    
    axis equal;
    set(ah,'XTick',[]);
    set(ah,'YTick',[]);
    box on;
    axis manual;
    hold on;
    
else
    ah = ax;
end
prehold = ishold(ah);

if (nargin < 3) || isempty(delay) || ~isnumeric(delay),
    delay = 20;
else
    delay = abs(delay(1));
end
delay = delay/1000; % Convert ms to seconds

if (nargin < 4) || isempty(allxy),
    allxy = false;
else
    allxy = allxy(1);
end

nf = size(xybpoints,2);

xypoints = xybpoints(1:2,:);
pstatus = double(logical(xybpoints(3,:))) + 1;
pstyles = {':','-'};

% Draw initial pen location

penh = plot(ah,xypoints(1,1),xypoints(2,1),'r.');

drawnow;
pause(delay); % Update screen image
tic;

delete(penh); % Remove pen dot

% Animate drawing of line segments
for i = 1:nf-1,
    penh = plot(ah,xypoints(1,i:i+1),xypoints(2,i:i+1),...
        ['r' pstyles{pstatus(i)}],...
        xypoints(1,i+1),xypoints(2,i+1),'r.');
    
    drawnow; % Update screen image
    
    drawtime = toc;
    pause(max(delay - drawtime,0)); % Pause as required to retain frame ratio
    tic;
    
    delete(penh); % Remove latest pen segment and dot
    if allxy || (pstatus(i) > 1),
        plot(ah,xypoints(1,i:i+1),xypoints(2,i:i+1),...
            ['b' pstyles{pstatus(i)}]);
    end
end
toc;

if prehold,
    hold on;
else
    hold off;
end