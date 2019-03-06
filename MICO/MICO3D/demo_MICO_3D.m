% This Matlab file demomstrates the method for simultaneous segmentation and bias field correction 
% in Chunming Li et al's paper:
%    "Multiplicative intrinsic component optimization (MICO) for MRI bias field estimation and tissue segmentation",
%     Magnetic Resonance Imaging, vol. 32 (7), pp. 913-923, 2014
% Author: Chunming Li, all rights reserved
% E-mail: li_chunming@hotmail.com
% URL:  http://imagecomputing.org/~cmli/

% Note: The 3D MICO algorithm is used to segment a synthetic 3D MR image in
% this demo. The code only shows the original image and segmentation result in one 2D slice, 
% although it produces 3D segmentation result.

% The 3D MICO algorithm perfoprms 3D segmentation and bias field
% correction, and the segmented image and bias field corrected image are
% saved as two files with file name 

clear all;
close all;

iterNum_outer=25;  % outer iteration
iterCM=2;  % inner interation for C and M
iter_b=5;  % inner iteration for bias
q = 1;   % fuzzifier
th_bg = 5;  %% threshold for removing background
N_region = 3; %% number of tissue types, e.g. WM, GM, CSF
tissueLabel=[1, 2, 3];
WhichSliceVisualize=100;
currentDirectory=pwd;
datapath=strcat(currentDirectory,'\DATA\');

image_1='t1_icbm_normal_1mm_pn0_rf20.nii';
image_2='t1_icbm_normal_1mm_pn0_rf40.nii';

whichData=image_2;

GroundTruth=niftiread('t1_icbm_normal_1mm_pn0_rf0.nii');

str_vector{1} = image_1;   % input a sequence of image file names


Bias_corrected=MICO_3Dseq(str_vector, N_region, q, th_bg, iterNum_outer, iter_b, iterCM, tissueLabel);

index=1;
for slice=1:1:length(GroundTruth(1,1,:))
    if (max(max(GroundTruth(:,:,slice))))~=0 && (max(max(Bias_corrected(:,:,slice))))~=0 
        GT_Slice=GroundTruth(:,:,slice);
        BC_Slice=Bias_corrected(:,:,slice);
        index_NAN=find(isnan(BC_Slice)==1);
        GT_Slice(index_NAN)=0;
        BC_Slice(index_NAN)=0;
        [Entropy_difference,TGD_difference,MSE,PSNR,AMBE,CII,ssimval]=MesurePerformance(double(GT_Slice),double(BC_Slice));
        ncc=Calculate_NCC(double(GT_Slice),double(BC_Slice));
        Metric_store(index,:)=[Entropy_difference;TGD_difference;MSE;PSNR;AMBE;CII;ssimval;ncc];
    end
    index=index+1;
end
%% Quantitative Performance Measurement
Mean_Metric_store=mean(Metric_store);
fprintf('\n --------Quantitative Performance Measurement for biased correction------- \n \n');
disp(['Avg. Entropy difference for biased correction is ' num2str(Mean_Metric_store(1))]);
disp(['Avg. TGD difference for biased correction is ' num2str(Mean_Metric_store(2))]);
disp(['Avg. MSE for biased correction is ' num2str(Mean_Metric_store(3))]);
disp(['Avg. PSNR for biased correction is ' num2str(Mean_Metric_store(4))]);
disp(['Avg. AMBE for biased correction is ' num2str(Mean_Metric_store(5))]);
disp(['Avg. CII for biased correction is ' num2str(Mean_Metric_store(6))]);
disp(['Avg. SSIM for biased correction is ' num2str(Mean_Metric_store(7))]);
disp(['Avg. NCC for biased correction is ' num2str(Mean_Metric_store(8))]);

%% Qualititative visualization of the particular slice
figure;
subplot(121),imshow(GroundTruth(:,:,WhichSliceVisualize),[]),title('GT image');
subplot(122),imshow(Bias_corrected(:,:,WhichSliceVisualize),[]),title('bias corrected')
toc;
%% --------------------------THE END----------------------------------
