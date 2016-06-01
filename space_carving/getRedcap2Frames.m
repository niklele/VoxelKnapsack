addpath(genpath('functions'));

% Define images to process
imageFileNames = {
    'redcap2/1.jpg',...
    'redcap2/2.jpg',...
    'redcap2/3.jpg',...
    'redcap2/4.jpg',...
    'redcap2/5.jpg',...
    'redcap2/6.jpg',...
    'redcap2/7.jpg',...
    'redcap2/8.jpg',...
    'redcap2/9.jpg',...
    'redcap2/10.jpg',...
    'redcap2/11.jpg',...
    'redcap2/12.jpg',...
    'redcap2/13.jpg',...
    'redcap2/14.jpg',...
    'redcap2/15.jpg',...
    'redcap2/16.jpg',...
    'redcap2/17.jpg',...
    'redcap2/18.jpg',...
    'redcap2/19.jpg',...
    'redcap2/20.jpg',...
    'redcap2/21.jpg',...
    'redcap2/22.jpg',...
    'redcap2/23.jpg',...
    'redcap2/24.jpg',...
    'redcap2/25.jpg',...
    'redcap2/26.jpg',...
    'redcap2/27.jpg',...
    'redcap2/28.jpg',...
    'redcap2/29.jpg',...
    'redcap2/30.jpg',...
    'redcap2/31.jpg',...
    'redcap2/32.jpg',...
    'redcap2/33.jpg',...
    'redcap2/34.jpg',...
    };
% 
% for k = 1:length(imageFileNames)
%     impath = imageFileNames{k};
%     resize_im = resizeImage(impath, 1024, 768);
%     out_path = sprintf('%s', impath);
%     imwrite(resize_im, out_path);
% end

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Generate world coordinates of the corners of the squares
squareSize = 0.866;  % in units of 'in'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'in', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', []);

frames = createFramesArray(imageFileNames, cameraParams, worldPoints);
save('redcap2_frames.mat', 'frames');

figure; showExtrinsics(cameraParams,'patternCentric');