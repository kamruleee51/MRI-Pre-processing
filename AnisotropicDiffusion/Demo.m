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
which_Slice_Visualization=115;

%% Read the Images
currentDirectory=pwd;
Datapath=strcat(currentDirectory,'\DATA\');
Image_1='t1_icbm_normal_1mm_pn1_rf0.nii';
Image_2='t1_icbm_normal_1mm_pn5_rf0.nii';

whichImage=Image_2;

whichImage_GT='t1_icbm_normal_1mm_pn0_rf0.nii';

fullpath_Image=strcat(Datapath,whichImage);
fullpath_GT=strcat(Datapath,whichImage_GT);

image=niftiread(fullpath_Image);
GT=niftiread(fullpath_GT);

Metric_store_blurred=zeros(length(image(1,1,:)),8);
Metric_store_A_diffusion=zeros(length(image(1,1,:)),8);
Metric_store_I_diffusion=zeros(length(image(1,1,:)),8);

blurred=zeros(length(image(:,1,1)),length(image(1,:,1)),length(image(1,1,:)));
A_diffusion=zeros(length(image(:,1,1)),length(image(1,:,1)),length(image(1,1,:)));
I_diffusion=zeros(length(image(:,1,1)),length(image(1,:,1)),length(image(1,1,:)));

for whichSlice=1:1:length(image(1,1,:))
% Take the ith Slice   
Image_Slice=double(image(:,:,whichSlice));
if (max(max(Image_Slice)))~=0
%% Bluring 
     H = fspecial('disk',3);
     tempBlurred= imfilter(Image_Slice,H,'replicate');
     blurred(:,:,whichSlice)=tempBlurred;

    %% Anisotropic diffusion
    temp_aniso=anisodiff(Image_Slice,num_iter,kappa,delta_t,option);
    A_diffusion(:,:,whichSlice)=temp_aniso;

    %% Isotropic diffusion
    temp_iso=isodiff(Image_Slice,delta_t,constnat_for_isotropic);
    I_diffusion(:,:,whichSlice)=temp_iso;
    
    %% Visualize slice by slice
    subplot 231, imshow(Image_Slice,[]), title(['Original ',num2str(whichSlice),'th slice'])
    subplot 232, imshow(GT(:,:,whichSlice),[]), title(['GT ',num2str(whichSlice),'th slice'])
    subplot 233, imshow(temp_aniso,[]), title(['Anisotropic ',num2str(whichSlice),'th slice'])
    subplot 234, imshow(temp_iso,[]), title(['Isotropic ',num2str(whichSlice),'th slice'])
    subplot 235, imshow(tempBlurred,[]), title(['Blured ',num2str(whichSlice),'th slice'])
    pause(0.1)
end
end
%% Save Filtered Images
SavePath=strcat(currentDirectory,'\Output_Filtered_Image\');

Save_Blurred=strcat(SavePath,'Denoising_Blurring_',whichImage);
niftiwrite(blurred,Save_Blurred);

Save_isotropic=strcat(SavePath,'Denoising_isotropic_',whichImage);
niftiwrite(I_diffusion,Save_isotropic);

Save_ansotropic=strcat(SavePath,'Denoising_ansotropic_',whichImage);
niftiwrite(A_diffusion,Save_ansotropic);

%% Quantitative Performance Measurement
for whichSlice=1:1:length(image(1,1,:))
    
GT_Slice=double(GT(:,:,whichSlice));

blurred_slice=double(blurred(:,:,whichSlice));
ncc=Calculate_NCC(GT_Slice,blurred_slice);
[Entropy_difference,TGD_difference,MSE,PSNR,AMBE,CII,ssimval]=MesurePerformance(GT_Slice,blurred_slice);
Metric_store_blurred(whichSlice,:)=[Entropy_difference;TGD_difference;MSE;PSNR;AMBE;CII;ssimval;ncc];

A_diffusion_slice=double(A_diffusion(:,:,whichSlice));
ncc=Calculate_NCC(GT_Slice,A_diffusion_slice);
[Entropy_difference,TGD_difference,MSE,PSNR,AMBE,CII,ssimval]=MesurePerformance(GT_Slice,A_diffusion_slice);
Metric_store_A_diffusion(whichSlice,:)=[Entropy_difference;TGD_difference;MSE;PSNR;AMBE;CII;ssimval;ncc];

I_diffusion_slice=double(I_diffusion(:,:,whichSlice));
ncc=Calculate_NCC(GT_Slice,I_diffusion_slice);
[Entropy_difference,TGD_difference,MSE,PSNR,AMBE,CII,ssimval]=MesurePerformance(GT_Slice,I_diffusion_slice);
Metric_store_I_diffusion(whichSlice,:)=[Entropy_difference;TGD_difference;MSE;PSNR;AMBE;CII;ssimval;ncc];
end

%In some slices, there is no information. As a consequence, PSNR becoming
%NaN. To calculate the average values of performance metric. Lets, fint out
%those slice that have no informations. 
ind_NnN_PSNR=find(isnan(Metric_store_A_diffusion(:,4))==0);

Mean_Metric_blurred=mean(Metric_store_blurred(ind_NnN_PSNR,:));

Mean_Metric_A_diffusion=mean(Metric_store_A_diffusion(ind_NnN_PSNR,:));

Mean_Metric_I_diffusion=mean(Metric_store_I_diffusion(ind_NnN_PSNR,:));

%% Quantitative Performance Measurement
%For the Anisotropic diffusion
fprintf('\n --------Quantitative Performance Measurement for Anisotropic diffusion------- \n \n');
disp(['Avg. Entropy difference for Anisotropic diffusion is ' num2str(Mean_Metric_A_diffusion(1))]);
disp(['Avg. TGD difference for Anisotropic diffusion is ' num2str(Mean_Metric_A_diffusion(2))]);
disp(['Avg. MSE for Anisotropic diffusion is ' num2str(Mean_Metric_A_diffusion(3))]);
disp(['Avg. PSNR for Anisotropic diffusion is ' num2str(Mean_Metric_A_diffusion(4))]);
disp(['Avg. AMBE for Anisotropic diffusion is ' num2str(Mean_Metric_A_diffusion(5))]);
disp(['Avg. CII for Anisotropic diffusion is ' num2str(Mean_Metric_A_diffusion(6))]);
disp(['Avg. SSIM for Anisotropic diffusion is ' num2str(Mean_Metric_A_diffusion(7))]);
disp(['Avg. NCC for Anisotropic diffusion is ' num2str(Mean_Metric_A_diffusion(8))]);

% For the Isotropic diffusion
fprintf('\n --------Quantitative Performance Measurement for Isotropic diffusion------- \n \n');
disp(['Avg. Entropy difference for Isotropic diffusion is ' num2str(Mean_Metric_I_diffusion(1))]);
disp(['Avg. TGD difference for Isotropic diffusion is ' num2str(Mean_Metric_I_diffusion(2))]);
disp(['Avg. MSE for Isotropic diffusion is ' num2str(Mean_Metric_I_diffusion(3))]);
disp(['Avg. PSNR for Isotropic diffusion is ' num2str(Mean_Metric_I_diffusion(4))]);
disp(['Avg. AMBE for Isotropic diffusion is ' num2str(Mean_Metric_I_diffusion(5))]);
disp(['Avg. CII for Isotropic diffusion is ' num2str(Mean_Metric_I_diffusion(6))]);
disp(['Avg. SSIM for Isotropic diffusion is ' num2str(Mean_Metric_I_diffusion(7))]);
disp(['Avg. NCC for Isotropic diffusion is ' num2str(Mean_Metric_I_diffusion(8))]);

%For the Bluring
fprintf('\n --------Quantitative Performance Measurement for Bluring----------- \n \n');
disp(['Avg. Entropy difference for bluring is ' num2str(Mean_Metric_blurred(1))]);
disp(['Avg. TGD difference for bluring  is ' num2str(Mean_Metric_blurred(2))]);
disp(['Avg. MSE for bluring  is ' num2str(Mean_Metric_blurred(3))]);
disp(['Avg. PSNR for bluring  is ' num2str(Mean_Metric_blurred(4))]);
disp(['Avg. AMBE for bluring  is ' num2str(Mean_Metric_blurred(5))]);
disp(['Avg. CII for bluring  is ' num2str(Mean_Metric_blurred(6))]);
disp(['Avg. SSIM for bluring  is ' num2str(Mean_Metric_blurred(7))]);
disp(['Avg. NCC for bluring  is ' num2str(Mean_Metric_blurred(8))]);

%% qualitative Performance Visualization for particular slice
figure()
subplot 231, imshow(image(:,:,which_Slice_Visualization),[]), title(['Original ',num2str(which_Slice_Visualization),'th slice'])
subplot 232, imshow(GT(:,:,which_Slice_Visualization),[]), title(['GT ',num2str(which_Slice_Visualization),'th slice'])
subplot 233, imshow(A_diffusion(:,:,which_Slice_Visualization),[]), title(['Anisotropic ',num2str(which_Slice_Visualization),'th slice'])
subplot 234, imshow(I_diffusion(:,:,which_Slice_Visualization),[]), title(['Isotropic ',num2str(which_Slice_Visualization),'th slice'])
subplot 235, imshow(blurred(:,:,which_Slice_Visualization),[]),title(['Blured ',num2str(which_Slice_Visualization),'th slice'])

toc;
%% --------------------END-------------------------