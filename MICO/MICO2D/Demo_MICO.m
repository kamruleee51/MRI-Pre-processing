% This Matlab file demomstrates the method for simultaneous segmentation and bias field correction
% in Chunming Li et al's paper:
%    "Multiplicative intrinsic component optimization (MICO) for MRI bias field estimation and tissue segmentation",
%     Magnetic Resonance Imaging, vol. 32 (7), pp. 913-923, 2014
% Author: Chunming Li, all rights reserved
% E-mail: li_chunming@hotmail.com
% URL:  http://imagecomputing.org/~cmli/

clc;
close all;
clear all;
tic;
%% This section is for parameters
iterNum = 20;
N_region=3;  
q=1;
WhichSliceVisualize=15;

%% Read the Images 
currentDirectory=pwd;
ImagePath=strcat(currentDirectory,'\DATA\');

Image_1='t1_icbm_normal_1mm_pn0_rf40.nii';
Image_2='t1_icbm_normal_1mm_pn0_rf20.nii';

WhichGT='t1_icbm_normal_1mm_pn0_rf0.nii';

whichImage=Image_1;

fullPath=strcat(ImagePath,whichImage);
fullPath_GT=strcat(ImagePath,WhichGT);

Image3D=niftiread(fullPath);
Image3D_GT=niftiread(fullPath_GT);

%% Image storage initializations
sizeImage=size(Image3D);
Segmented3D=zeros(sizeImage);
Biased3D=zeros(sizeImage);
Corrected3D=zeros(sizeImage);
index=1;

for whichslice=1:1:sizeImage(3)
    Img=Image3D(:,:,whichslice);
    image_GT=Image3D_GT(:,:,whichslice);
    
    if max(max(Img))~=0
        Img = double(Img(:,:,1));

        %load ROI
        A=255;
        Img_original = Img;
        [nrow,ncol] = size(Img);
        n = nrow*ncol;

        ROI = (Img>20); 
        ROI = double(ROI);

        tic

        Bas=getBasisOrder3(nrow,ncol);
        N_bas=size(Bas,3);
        for ii=1:N_bas
            ImgG{ii} = Img.*Bas(:,:,ii).*ROI;
            for jj=ii:N_bas
                GGT{ii,jj} = Bas(:,:,ii).*Bas(:,:,jj).*ROI;
                GGT{jj,ii} = GGT{ii,jj} ;
            end
        end


        energy_MICO = zeros(3,iterNum);

        b=ones(size(Img));
        for ini_num = 1:1
            C=rand(3,1);
            C=C*A;
            M=rand(nrow,ncol,3);
            a=sum(M,3);
            for k = 1 : N_region
                M(:,:,k)=M(:,:,k)./a;
            end

            [e_max,N_max] = max(M,[], 3);
            for kk=1:size(M,3)
                M(:,:,kk) = (N_max == kk);
            end

            M_old = M; chg=10000;
            energy_MICO(ini_num,1) = get_energy(Img,b,C,M,ROI,q);


            for n = 2:iterNum
                pause(0.1)

                [M, b, C]=  MICO(Img,q,ROI,M,C,b,Bas,GGT,ImgG,1, 1);
                energy_MICO(ini_num,n) = get_energy(Img,b,C,M,ROI,q);

                figure(2),
                if(mod(n,1) == 0)
                    PC=zeros(size(Img));
                    for k = 1 : N_region
                        PC=PC+C(k)*M(:,:,k);
                    end
                    subplot(241),imshow(uint8(Img)),title('original')
                    subplot(242),imshow(PC.*ROI,[]); colormap(gray);
                    iterNums=['segmentation: ',num2str(n), ' iterations'];
                    title(iterNums);
                    subplot(243),imshow(b.*ROI,[]),title('bias field')
                    img_bc = Img./b;  % bias field corrected image
                    subplot(244),imshow(uint8(img_bc.*ROI),[]),title('bias corrected')
                    subplot(2,4,[5 6 7 8]),plot(energy_MICO(ini_num,:))
                    xlabel('iteration number');
                    ylabel('energy');
                    pause(0.1)
                end
            end
        end

        [M,C]=sortMemC(M,C);
        seg=zeros(size(Img));
        for k = 1 : N_region
            seg=seg+k*M(:,:,k);   % label the k-th region 
        end
    [Entropy_difference,TGD_difference,MSE,PSNR,AMBE,CII,ssimval]=MesurePerformance(double(image_GT),double(img_bc.*ROI));
    ncc=Calculate_NCC(double(image_GT),double(img_bc.*ROI));
    Metric_store(index,:)=[Entropy_difference;TGD_difference;MSE;PSNR;AMBE;CII;ssimval;ncc];

    Segmented3D(:,:,whichslice)=seg.*ROI;
    Biased3D(:,:,whichslice)=b.*ROI;
    Corrected3D(:,:,whichslice)=img_bc.*ROI;
    index=index+1;
    end
    disp(['Slice Number=',num2str(whichslice),' Done!!!'])
    close all
end
%% Save Filtered Images
SavePath=strcat(currentDirectory,'\Output_biased_corrected\');

Save_Segmented3D=strcat(SavePath,'Segmented3D_',whichImage);
niftiwrite(Segmented3D,Save_Segmented3D);

Save_Biased3D=strcat(SavePath,'Biased3D_',whichImage);
niftiwrite(Biased3D,Save_Biased3D);

Save_Corrected3D=strcat(SavePath,'Corrected3D_',whichImage);
niftiwrite(Corrected3D,Save_Corrected3D);

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
subplot(221),imshow(Image3D(:,:,WhichSliceVisualize),[]),title('Original image');
subplot(222),imshow(Segmented3D(:,:,WhichSliceVisualize),[]),title('Segmentation result');
subplot(223),imshow(Biased3D(:,:,WhichSliceVisualize),[]),title('bias field')
subplot(224),imshow(Corrected3D(:,:,WhichSliceVisualize),[]),title('bias corrected')
toc;
%% ------------------ The END---------------------------------

