function nor_cc=Calculate_NCC(I_moving,I_fixed)
%% This code is written by Md. Kamrul Hasan
[r_moving,c_moving]=size(I_moving);
[r_fixed,c_fixed]=size(I_fixed);

if r_moving==r_fixed && c_moving==c_fixed
    %Calculate mean of Moving and Fixed Image
    Moving_mean=mean(I_moving(:));
    fixed_mean=mean(I_fixed(:));
    
    Covariance_moving_fixed_Image=sum(sum((I_fixed-fixed_mean).*(I_moving-Moving_mean)));
    Variance_fixed_Image=sum(sum((I_fixed-fixed_mean).^2));
    Variance_Moving_Image=sum(sum((I_moving-Moving_mean).^2));
    
    nor_cc=Covariance_moving_fixed_Image/sqrt(Variance_fixed_Image*Variance_Moving_Image);
else
    disp('Moving and fixed Image suppose to have same dimension!!!')
end
end