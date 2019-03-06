clc
close all 
clear all
tic;
%% Specify the parameters
num_iter = 25;
delta_t = 0.25;
kappa = 3;
option = 2;
constnat_for_isotropic=1;
iterNum_outer=25;  % outer iteration
iterCM=2;  % inner interation for C and M
iter_b=1;  % inner iteration for bias
q = 1;   % fuzzifier
th_bg = 5;  %% threshold for removing background
N_region = 3; %% number of tissue types, e.g. WM, GM, CSF
tissueLabel=[1, 2, 3];
WhichSliceVisualize=100;

%% Read the Images
currentDirectory=pwd;
Datapath=strcat(currentDirectory,'\');

Image='t1_icbm_normal_1mm_pn5_rf20.nii';

whichImage=Image;

whichImage_GT='t1_icbm_normal_1mm_pn0_rf0.nii';

fullpath_Image=strcat(Datapath,whichImage);
fullpath_GT=strcat(Datapath,whichImage_GT);

image=niftiread(fullpath_Image);
GT=niftiread(fullpath_GT);

A_diffusion=zeros(length(image(:,1,1)),length(image(1,:,1)),length(image(1,1,:)));

for whichSlice=1:1:length(image(1,1,:))
% Take the ith Slice   
Image_Slice=double(image(:,:,whichSlice));
if (max(max(Image_Slice)))~=0
    %% Anisotropic diffusion
    temp_aniso=anisodiff(Image_Slice,num_iter,kappa,delta_t,option);
    A_diffusion(:,:,whichSlice)=temp_aniso;
    
    %% Visualize slice by slice
    subplot 131, imshow(Image_Slice,[]), title(['Original ',num2str(whichSlice),'th slice'])
    subplot 132, imshow(GT(:,:,whichSlice),[]), title(['GT ',num2str(whichSlice),'th slice'])
    subplot 133, imshow(temp_aniso,[]), title(['Anisotropic ',num2str(whichSlice),'th slice'])
    pause(0.1)
end
end
%% Save Filtered Images
SavePath=strcat(currentDirectory,'\');

Save_ansotropic=strcat(SavePath,'Denoising_ansotropic_',whichImage);
niftiwrite(A_diffusion,Save_ansotropic);

%% Start Bias field correction

whichData='Denoising_ansotropic_t1_icbm_normal_1mm_pn5_rf20.nii';

GroundTruth=niftiread('t1_icbm_normal_1mm_pn0_rf0.nii');

str_vector{1} = whichData;   % input a sequence of image file names

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
%% --------------------END-------------------------