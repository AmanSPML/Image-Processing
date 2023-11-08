% Step 1: Load the input image
input_image = imread("C:\Users\Let`s engineer\Downloads\Digital Image Processing\Ground truth image for multiresolution bilateral filtering.jpg");  % Replace with the actual path to your grayscale image.

    % Display the input image
figure;
subplot(1,3,1);
imshow(input_image);
title('Input Image');
axis off;

% Step 2: Add noise to the input image (you can change the type and parameters of noise)
noise_type = 'gaussian';
mean = 0;
variance = 1000;
sigma = sqrt(variance);
noise = normrnd(mean, sigma, size(input_image));
noised_input = double(input_image) + noise;
% Normalize the noisy input image to [0, 1]


    % Display the noised input image
subplot(1,3,2);
imshow(uint8(noised_input));
title('Noised Input Image');
axis off;

% Step 3: Perform wavelet decomposition
[cA_o, cH_o, cV_o, cD_o] = dwt2(noised_input, 'haar');
                                                                                                                                                                            
    % Now, to get the second level of coefficients for cA, cH, cV, and cD
[cA_2nd, cH_2nd, cV_2nd, cD_2nd] = dwt2(cA_o, 'haar'); % cA_2nd, cH_2nd, cV_2nd, and cD_2nd now represent the second-level coefficients
                                                                                    
                                                                                     
% Step 4: Apply bilateral filtering to the approximation subband of level 2.

approximation_filtered_level2 = imbilatfilt(cA_2nd, 100 ,1.5);

% Step 5: Apply wavelet thresholding to the detail subbands

% Step 1: Load the input image
input_image = imread("C:\Users\Let`s engineer\Downloads\Digital Image Processing\Ground truth image for multiresolution bilateral filtering.jpg");  % Replace with the actual path to your grayscale image.

% Step 2: Add noise to the input image (you can change the type and parameters of noise)
noise_type = 'gaussian';
mean = 0;
variance = 500;
sigma = sqrt(variance);
noise = normrnd(mean, sigma, size(input_image));
noised_input = uint8(double(input_image) + noise);
[THR, SORH, KEPAPP] = ddencmp('den', 'wv', noised_input);
threshold = THR;  % You may need to adjust this threshold value
cH_2ndthresh = wthresh(cH_2nd, 's', threshold);
cV_2ndthresh = wthresh(cV_2nd, 's', threshold);
cD_2ndthresh = wthresh(cD_2nd, 's', threshold);


% Step 6: Combining the approximate coefficients and detail
% coefficients at the second level.

reconstruct_approx_level2 = idwt2(approximation_filtered_level2, cH_2ndthresh, cV_2ndthresh, cD_2ndthresh, 'haar');

% Step 7: Bilt
bilat_rec_approx_level2 = imbilatfilt(reconstruct_approx_level2, 1000, 1.5);

    %upsampling it to the level 1
%approx_filtered_up = imresize(bilat_rec_approx_level2, size(cA_o));

% Step 8: Thresholding the level1 detailed coefficients
threshold = THR;  % You may need to adjust this threshold value
cH_thresh = wthresh(cH_o, 's', threshold);
cV_thresh = wthresh(cV_o, 's', threshold);
cD_thresh = wthresh(cD_o, 's', threshold);


% Step 9: Reconstructing the final output image that has to be passed
% through the final bilateral filter

final_rec_image = idwt2(bilat_rec_approx_level2, cH_thresh, cV_thresh, cD_thresh, 'haar');

% Step 10: Final bilateral filtering

denoised_image = imbilatfilt(final_rec_image, 1000, 1.5);

                                                                                           
% Step 10: Reconstruct the image using the filtered approximation and thresholded details
%reconstructed_image = idwt2(approximation_filtered, cH_thresh, cV_thresh, cD_thresh, 'haar');

% Display the denoised output image
subplot(1,3,3);
imshow(uint8(denoised_image));
title('Denoised Output Image');
axis off;

% Show the plot
sgtitle('Denoising of Grayscale Image Using Multiresolution Framework', 'FontSize', 20);

% Step 11: Calculate the SNR value of output image
input_image = double(input_image);
denoised_image = double(denoised_image);
snr_value = 10 * log10(sum(sum(input_image.^2)) / sum(sum((input_image - denoised_image).^2)));
fprintf('SNR: %.2f dB\n', snr_value);



