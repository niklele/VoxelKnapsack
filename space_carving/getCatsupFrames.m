addpath(genpath('functions'));

% Define images to process
imageFileNames = {'catsup/IMG_0050.jpg',...
    'catsup/IMG_0051.jpg',...
    'catsup/IMG_0052.jpg',...
    'catsup/IMG_0053.jpg',...
    'catsup/IMG_0054.jpg',...
    'catsup/IMG_0055.jpg',...
    'catsup/IMG_0056.jpg',...
    'catsup/IMG_0057.jpg',...
    'catsup/IMG_0058.jpg',...
    'catsup/IMG_0059.jpg',...
    };



% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Generate world coordinates of the corners of the squares
squareSize = 1;  % in units of 'in'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'in', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', []);

frames = createFramesArray(imageFileNames, cameraParams);
save('catsup_frames.mat', 'frames');