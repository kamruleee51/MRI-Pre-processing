# Image-Pre-processing
## Written by Md. Kamrul Hasan
## E-mail: kamruleeekuet@gmail.com

Almost in every image processing or analysis work, image pre-preprocessing is crucial  step. In medical image analysis, pre-processing is a very important step because the further success or performance of the algorithm mostly dependent  on pre-processed image. In this  lab,  we are working with 3D Brain MRI data. In case of working with brain MRI  removing the noise and bias field (which is due to inhomogeneity of the magnetic field) is very important  part of preprocessing of  brain MRI.  To do so,  we widely used algorithm Anisotropic diffusion, isotropic diffusion  which can  diffuse  in  any  direction,  and  Multiplicative  intrinsic  component  optimization  (MICO)  have  been  used  for  noise  removal and bias field correction respectfully.  Both quantitative and qualitative  performance  of the algorithms  also  have been analyzed.

The metric used for the evaluation of pre-processing algorithms are- 

    * Entropy difference 
    * Tenengrad (TGD) difference

3.3
Mean Square Error (MSE)

3.4
Peak Signal to Noise Ratio (PSNR)

3.5
Absolute Mean Brightness Error (AMBE)

3.6
Contrast Improvement Index (CII)

3.7
Structural Similarity Index (SSIM)

3.8
Normalized Cross Correlation (NCC)

    * 
