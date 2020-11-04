
# DigitalFilters
A set of digital filters in MATLAB

## Wiener
This  is a set of scripts that contain an implementation of a Wiener filter calculator. A steepest descent algorithm is purposed to calculate faster and accurate the Wiener filter coefficients. 

**Wien0.m** contains a comparison between an exact Wiener-Hopf algorithm and a steepest descent algorithm to calculate the Wiener filter coefficients. The two algorithms are compared based on their runtime and their accuracy. For the comparison, a sinoid is used to represent the signal and a white noise  to represent the noise that the filters should cutoff. 

**Wien1.m** contains an example that uses the purposed steepest descent algorithm to apply a Wiener filter to a song. The song could be found in the "sounds.mat" and consist of:
- d > the instrumental including the noise
- u > the recording of the noise
- x > the clear instrumental

#### Conclusions
- The Wiener-Hopf algorithm is exact but requires heavy computational resources. 
- The steepest descent algorithms uses an iterative method to approach the solution way faster. 
- The steepest descent algorithm may need optimization, on the learning rate and the number of iterations in some cases. In this case it is optimized for general purpose filters.
- The Parameter Error (calculated vs exact coefficients) could get very low, increasing the number of iterations. This could have only a small impact on the rutime (~1 sec for 10 times more iterations).

More specifications could be found in the scripts. The scripts plot all the information of the comparison. Feel free to test changing the learning rate and the number of iterations of the steepest descent algorithm.


## BlockLMS
This  is a set of scripts and functions that contain a comparison between several implementations of Block LMS algorithm. An unknown system is modeled through 4 different BlockLMS function, comparing their complexity and their efficiency. 

The 4 implementations of the BlockLMS algorithm are in the "implementations" folder and are the following:

**blocklms1.m** contains an implementation based on 2 nested loops.

**blocklms2.m** contains an implementation based on 1 loops and matrix computations.

**blocklms3.m** contains an implementation in frequency domain using FFT.

**blocklms4.m** contains an unconstrained implementation in frequency domain.

In the implementations a set of helping file has been used. The helping files are store in the "helpers" folder and their summary is:

**plant.p** An unknown system we would like to model, using Block LMS.

**fastMul.m** An approximate O(n logn) implementation fuction of a multiplication y=Tw, where T is a Toeplitz matrix and w is vector.

**mulCom.m** A script to compare the exact and the approximate multiplication y=Tw (approximate algorithm found in fastMul.m) with random numbers. Presents plots and outputs with the runtime and the errors of these implementations.

**convTheory.m** A script to compare 4 different ways to calculate the convolution of two random signals x, y. The result is calculated using Matlab built in function conv(), Yx multiplication (where Y is the Toeplitz representation of y), multiplication Cx (where C is the Circulant representation of y) and Fourier transformation.

**modelPlant.m** A script to compare the 4 different implementations of the Block LMS algorithm (found in implementations folder) with the unknown system plant.p and white noise as an input. Presents plots and outputs with the runtime and the errors of these implementations.


#### Conclusions
- **blocklms3** outperforms the rest of the implementations with best runtime and error specification. 
- **blocklms4** has the worst error but the best runtime. It was expected, as unconstrained methods give a faster convergence.
- **blocklms1** and **blocklms2** give a way slower convergence and a similar error with the frequency domain methods .
- Frequency domain methods seem to give the fastest and more efficient solution to the BlockLMS algorithm.

More specifications could be found in the scripts. The scripts plot all the information of the comparison. Feel free to test changing the learning rate.


