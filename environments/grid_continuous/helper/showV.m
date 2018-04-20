function [ ] = showV(V)
figure(2);
cla;
imagesc(V,[-20 1]); colormap(gray); drawnow;
end

