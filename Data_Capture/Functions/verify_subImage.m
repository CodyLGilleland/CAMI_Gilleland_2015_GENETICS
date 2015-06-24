function [T, B, L, R, adjusted,subSize] = verify_subImage(T, B, L, R, sizeImage)


adjusted = [0 0];

% check the first dimension
  if T < 1
     T = 1;
     adjusted(1) = 1;
 end
 
 if B > sizeImage(1)
     B = sizeImage(1);
     adjusted(1) = 1;
 end

 % check the second dimension
 if L < 1
     L = 1;
     adjusted(2) = 1;
 end

 if R > sizeImage(2)
     R = sizeImage(2);
     adjusted(2) = 1;
 end
 
 subSize = [B-T, R-L];