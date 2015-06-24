  % EXAMPLE 1: Recover a transformed image using SURF feature points
      Iin  = imread('cameraman.tif'); imshow(Iin); title('Base image');
      Iout = imresize(Iin, 0.7); figure;
      Iout = imrotate(Iout, 31); imshow(Iout); title('Transformed image');
      % detect and extract features from both images
      ptsIn  = detectSURFFeatures(Iin);
      ptsOut = detectSURFFeatures(Iout);
      [featuresIn   validPtsIn]  = extractFeatures(Iin,  ptsIn);
      [featuresOut validPtsOut]  = extractFeatures(Iout, ptsOut);
      % match feature vectors
      index_pairs = matchFeatures(featuresIn, featuresOut);
      % get matching points
      matchedPtsIn  = validPtsIn(index_pairs(:,1));
      matchedPtsOut = validPtsOut(index_pairs(:,2));
      cvexShowMatches(Iin,Iout,matchedPtsIn,matchedPtsOut);
      title('Matched SURF points, including outliers');
      % compute the transformation matrix using RANSAC
      gte = vision.GeometricTransformEstimator;
      gte.Transform = 'Nonreflective similarity';
      [tform inlierIdx] = step(gte, matchedPtsOut.Location, ...
                          matchedPtsIn.Location);
      cvexShowMatches(Iin,Iout,matchedPtsIn(inlierIdx),...
                      matchedPtsOut(inlierIdx),'inliersIn','inliersOut');
      title('Matching inliers');
      % recover the original image Iin from Iout
      agt = vision.GeometricTransformer;
      Ir = step(agt, im2single(Iout), tform);
      figure; imshow(Ir); title('Recovered image');