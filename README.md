# Image-Pre-processing
## Written by Md. Kamrul Hasan
## E-mail: kamruleeekuet@gmail.com

Almost in every image processing or analysis work, image pre-preprocessing is crucial  step. In medical image analysis, pre-processing is a very important step because the further success or performance of the algorithm mostly dependent  on pre-processed image. In this  lab,  we are working with 3D Brain MRI data. In case of working with brain MRI  removing the noise and bias field (which is due to inhomogeneity of the magnetic field) is very important  part of preprocessing of  brain MRI.  To do so,  we widely used algorithm Anisotropic diffusion, isotropic diffusion  which can  diffuse  in  any  direction,  and  Multiplicative  intrinsic  component  optimization  (MICO)  have  been  used  for  noise  removal and bias field correction respectfully.  Both quantitative and qualitative  performance  of the algorithms  also  have been analyzed.

The metric used for the evaluation of pre-processing algorithms are- 

    * Entropy difference 
    * Tenengrad (TGD) difference
    * Mean Square Error (MSE) 
    * Peak Signal to Noise Ratio (PSNR) 
    * Absolute Mean Brightness Error (AMBE) 
    * Contrast Improvement Index (CII) 
    * Structural Similarity Index (SSIM) 
    * Normalized Cross Correlation (NCC)
