function [MSE,PSNR]=Calculate_MSE_PSNR(input_original,image_output)
%% This code is written by Md. Kamrul Hasan
% Reference: http://shodhganga.inflibnet.ac.in/bitstream/10603/23580/8/08_chapter%203.pdf
%% Implementation
[rows_org,columns_org] = size(input_original);
[rows_out,columns_out] = size(image_output);
if rows_org==rows_out && columns_org==columns_out
    Total_Pixels=rows_org*columns_org;
    SquaredError = (double(input_original) - double(image_output)) .^ 2;
    MSE = sum(SquaredError(:)) / (Total_Pixels);
    L=max(max(input_original));
    PSNR = 10 * log10( L^2 / MSE);
else 
    disp('Sorry!! Your should have same dimensional Image');
end
end