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
    
## Anisotropic diffusion
Avoid the undesirable effect of linear filtering such as blurring the meaningful edges of the image, Anisotropic Diffusion (AD) a non-linear partial differential equation-based diffusion process proposed by Perona and Malik become an obvious choice for image smoothing, edge detection, image segmentation and image enhancement [1]. AD method can successfully smooth noise, while respecting the region boundaries and small structures within the image, if some of its crucial parameters are estimated correctly. 


## Multiplicative intrinsic component optimization (MICO)
Bias field correction also called intensity inhomogeneity which is due to the inhomogeneity of the magnetic field that depends on the strength of the magnetic field. Multiplicative intrinsic component optimization (MICO) is a state-of-art method for bias field correction and segmentation proposed by Li et al. at [2]. MICO is an energy minimization method and formulation of energy is convex in each of its variable, which provide robustness of the energy minimization algorithm. MICO algorithm decompose MRI images into two multiplicative intrinsic components [2].


## Reference
[1] P. Perona and J. Malik. “Scale-space and edge detection using ansotropic diffusion.” IEEE Transactions on Pattern Analysis and Machine Intelligence, 12(7):629-639, July 1990. <b>
   
[2] Li, C., Gore, J. and Davatzikos, C. “Multiplicative intrinsic component optimization (MICO) for MRI bias field estimation and tissue segmentation.” Magnetic Resonance Imaging, 32(7), pp.913-923, 2014. <b>
   
[3] Puniani, S. and Arora, S. “Performance Evaluation of Image Enhancement Techniques. ” International Journal of Signal Processing, Image Processing and Pattern Recognition, 8(8), pp.251-262,2015. <b>

[4] Inflibnetacin. (2018). Inflibnetacin. Retrieved 28 October, 2018, from http://shodhganga.inflibnet.ac.in/bitstream/10603/23580/8/08_chapter 3.pdf  <b>


[5] Zhou, W., A. C. Bovik, H. R. Sheikh, and E. P. Simoncelli. "Image Qualifty Assessment: From Error Visibility to Structural Similarity." IEEE Transactions on Image Processing. Vol. 13, Issue 4, April 2004, pp. 600–612.
