function drawcircle( px,py,r,c,varargin)

t = 0:0.01:2*pi;
x = r*cos(t);
y = r*sin(t);

switch nargin
    case 4
        patch(x+px,y+py,c);
    case 5
        if ~varargin{1}
            patch(x+px, y+py, c, 'EdgeColor', 'None');
        else
            patch(x+px, y+py, c, 'EdgeColor', 'k');
        end
end


end

