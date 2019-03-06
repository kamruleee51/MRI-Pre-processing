function TGD=Tenengrad_Measure(InputImage)
%% This code is written by Md. Kamrul Hasan
% Reference: http://www.sersc.org/journals/IJSIP/vol8_no8/27.pdf
%% Implementation
[GMag, ~] = imgradient(InputImage,'sobel');
TGD=sum(GMag(:))/(length(GMag(:,1))*length(GMag(1,:)));
end
