% num = match(image1, image2)
%
% This function reads two images, finds their SIFT features, and
%   displays lines connecting the matched keypoints.  A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match.
% It returns the number of matches displayed.
%
% Example: match('scene.pgm','book.pgm');

%  function num = match(image1, image2)
 function [inv1,num1] = match1(image1,desc1,locc1,image2,desc2,locc2)
% Find SIFT keypoints for each image
%  [im1, des1, loc1] = sift(image1);
%  [im2, des2, loc2] = sift(image2);
 im1=image1;
 des1=desc1;
 osh1=locc1;
 im2=image2;
 des2=desc2;
dsh1=locc2;

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = .6;   

% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results

   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match1(i) = indx(1);
   else
      match1(i) = 0;
   end
end

% Create a new image showing the two images side by side.
im3 = appendimages(im1,im2);

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
 inv1=[];
cols1 = size(im1,2);
for i = 1: size(osh1,1)
  if (match1(i) > 0)
    line([osh1(i,2) dsh1(match1(i),2)+cols1],[osh1(i,1) dsh1(match1(i),1)], 'Color', 'c');
    a=[osh1(i,1),dsh1(match1(i),1)];
     inv1=[inv1;a];
  end
end

hold off;
num1 = sum(match1 > 0);
fprintf('Found %d matches.\n', num1);
end




