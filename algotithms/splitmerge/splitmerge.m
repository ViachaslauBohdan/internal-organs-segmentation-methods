function output_img = splitmerge(img, mindim, cb1) 
close all;

 
% Pad image with zeros to guarantee that function qtdecomp will 
% split regions down to size 1-by-1. 
Q = 2^nextpow2(max(size(img))); 
[M, N] = size(img); 
img = padarray(img, [Q - M, Q - N], 'post'); 
 
%Perform splitting first.  
S = qtdecomp(img, @split_test, mindim, cb1); 
 
% Now merge by looking at each quadregion and setting all its  
% elements to 1 if the block satisfies the predicate. 
 
% Get the size of the largest block. Use full because S is sparse. 
Lmax = full(max(S(:)))
% Set the output image initially to all zeros.  The MARKER array is 
% used later to establish connectivity. 
output_img = zeros(size(img)); 
MARKER = zeros(size(img)); 
% Begin the merging stage. 
for j = 1:Lmax  
   [vals, row, column] = qtgetblk(img, S, j); 
   if ~isempty(vals) 
      % Check the predicate for each of the regions 
      % of size K-by-K with coordinates given by vectors 
      % r and c. 
      for k = 1:length(row) 
         xlow = row(k); ylow = column(k); 
         xhigh = xlow + j - 1; yhigh = ylow + j - 1; 
         region = img(xlow:xhigh, ylow:yhigh); 
         flag = feval(cb1, region); 
         if flag  
            output_img(xlow:xhigh, ylow:yhigh) = 1; 
            MARKER(xlow, ylow) = 1; 
         end 
      end 
   end 
end 

% Finally, obtain each connected region and label it with a 
% different integer value using function bwlabel. 
output_img = bwlabel(imreconstruct(MARKER, output_img))
% output_img = bwlabel( output_img); 
 
% Crop and exit 
output_img = output_img(1:M, 1:N); 

%-------------------------------------------------------------------% 
function v = split_test(B, mindim, fun) 
% THIS FUNCTION IS PART OF FUNCTION SPLIT-MERGE. IT DETERMINES  
% WHETHER QUADREGIONS ARE SPLIT. The function returns in v  
% logical 1s (TRUE) for the blocks that should be split and  
% logical 0s (FALSE) for those that should not. 
 
% Quadregion B, passed by qtdecomp, is the current decomposition of 
% the image into k blocks of size m-by-m. 
 
% k is the number of regions in B at this point in the procedure. 
k = size(B, 3); 
 
% Perform the split test on each block. If the predicate function 
% (fun) returns TRUE, the region is split, so we set the appropriate 
% element of v to TRUE. Else, the appropriate element of v is set to 
% FALSE. 
v(1:k) = false; 
for i = 1:k 
   quadregion = B(:, :, i); 
   if size(quadregion, 1) <= mindim 
      v(i) = false; 
      continue 
   end 
   flag = feval(fun, quadregion); 
   if flag 
      v(i) = true; 
   end 
end 




