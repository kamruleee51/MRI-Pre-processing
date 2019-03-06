function AMBE=Absolute_Mean_Brightness_Error(Original_Image,Output_Image)
%% This code is written by Md. Kamrul Hasan
% Reference: http://shodhganga.inflibnet.ac.in/bitstream/10603/23580/8/08_chapter%203.pdf
%% Implementation
if numel(size(Original_Image))>2
    Original_Image=rgb2gray(Original_Image);
elseif numel(size(Output_Image))>2
       Output_Image=rgb2gray(Output_Image);
end
mean_Original_Image=mean2(Original_Image);
mean_output_Image=mean2(Output_Image);
AMBE=abs(mean_Original_Image-mean_output_Image);
end