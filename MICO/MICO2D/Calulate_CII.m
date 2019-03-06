function CII=Calulate_CII(original_Image,Output_Image)
%% This code is written by Md. Kamrul Hasan
% Reference: http://www.sersc.org/journals/IJSIP/vol8_no8/27.pdf
%% Implementation
slidingmean_Original=conv2(original_Image,ones(3)/9,'same');
slidingmean_Output_Image=conv2(Output_Image,ones(3)/9,'same');
mean_Original=mean2(slidingmean_Original);
mean_output_Image=mean2(slidingmean_Output_Image);
CII=mean_output_Image/mean_Original;
end