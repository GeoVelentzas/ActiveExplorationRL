function [ ] = showQ(Q)
figure(3);
%m = min(Q(:));
%M = max(Q(:));
m = -1;
M = 1;

subplot(3,3,6);
cla;
imagesc(Q(:,:,1), [m M]); colormap(gray); drawnow;
%title('right');

subplot(3,3,4);
cla;
imagesc(Q(:,:,2), [m M]); colormap(gray); drawnow;
%title('left');

subplot(3,3,2);
cla;
imagesc(Q(:,:,3), [m M]); colormap(gray); drawnow;
%title('up');
 
subplot(3,3,8);
cla;
imagesc(Q(:,:,4), [m M]); colormap(gray); drawnow;
%title('down');

subplot(3,3,5);
cla;
imagesc(max(Q,[],3), [m M]); colormap(gray); drawnow;
%title('down');



end

