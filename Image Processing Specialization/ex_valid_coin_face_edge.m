%% Valid Coin Face Edges
% For this problem your code will need to create a mask which only includes 
% true pixels for all valid coin regions. That is, you need to end up with _true 
% pixels in the interior of each valid coin, but nowhere else_. Use variable name 
% |*faceEdgeMask*|. 
% 
% One workflow to accomplish this is given below (see the project reading for 
% more detials):
%% 
% # Use the |*edge*| function to create a binary image showing many edges on 
% the coins, and few to no edges on the surface of the blanks. *NOTE:* The background 
% of the original image is not smooth. Background edges could bias an automatically 
% chosen edge threshold. You may find it advantageous to use the masked foreground 
% image for your edge calculations. 
% # Eliminate the pixels in the edge mask other than those in the valid coins. 
% Remember, you should have true pixels in your edge mask distributed into the 
% center of the coins, while you have no true pixels other than near the outer 
% rim of the blanks. Logically combining your edge mask with an eroded version 
% of your foreground segmentation mask should leave you with only the edges closer 
% to the coin centers. 

testCoinImage = imread("testCoinImage3.png");
imshow(testCoinImage)
[testcoinMask,MaskedtestCoin] = segmentCoin(testCoinImage);
% Shrink the coin mask.
se = strel('disk', 20, 0);
testcoinMask = imfill(testcoinMask, 'holes'); % Fill any holes in it.
testcoinMask = imerode(testcoinMask, se); % Shrink by 3 layers of pixels.

% Find edges using original poster's code.
imgFilt = imgaussfilt(MaskedtestCoin,0.5,...
    Padding="circular",FilterDomain="frequency",FilterSize=3);
faceEdgeMask = edge(imgFilt,"sobel",0.05,"both");
% Erase outside the shrunken coin mask to get rid of outer boundary.
faceEdgeMask(~testcoinMask) = false;
imshow(faceEdgeMask);
%%
function [testcoinMask,MaskedtestCoin] = segmentCoin(X)
%segmentImage Segment image using auto-generated code from Image Segmenter app
%  [BW,MASKEDIMAGE] = segmentImage(X) segments image X using auto-generated
%  code from the Image Segmenter app. The final segmentation is returned in
%  BW, and a masked image is returned in MASKEDIMAGE.

% Auto-generated by imageSegmenter app on 31-Dec-2022
%----------------------------------------------------
X = im2gray(X);

% Threshold image - manual threshold
testcoinMask = im2gray(X) > 200;

% Close mask with default
radius = 12;
decomposition = 4;
se = strel('disk', radius, decomposition);
testcoinMask = imclose(testcoinMask, se);

% Create masked image.
MaskedtestCoin = X;
MaskedtestCoin(~testcoinMask) = 0;
end