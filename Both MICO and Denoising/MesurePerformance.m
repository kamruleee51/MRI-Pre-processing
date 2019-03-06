function [Entropy_difference,TGD_difference,MSE,PSNR,AMBE,CII,ssimval]=MesurePerformance(OriginalImage,OutputImage)

%Calculations of Entropy for both Images
Entropy_Original=entropy(OriginalImage);
Entropy_Output=entropy(OutputImage);
Entropy_difference=Entropy_Original-Entropy_Output;

%Tenengrad Measure for both Images
TGD_Original=Tenengrad_Measure(OriginalImage);
TGD_Output=Tenengrad_Measure(OutputImage);
TGD_difference=TGD_Original-TGD_Output;

%Calculations of MSE and PSNR for BBHE
[MSE,PSNR]=Calculate_MSE_PSNR(OriginalImage,OutputImage);

%Calculations of AMBE for BBHE
AMBE=Absolute_Mean_Brightness_Error(OriginalImage,OutputImage);

%Contrast Improvement Index (CII)
CII=Calulate_CII(OriginalImage,OutputImage);

%Structural Similarity Index (SSIM) for measuring image quality
ssimval= ssim(OriginalImage,OutputImage);

end