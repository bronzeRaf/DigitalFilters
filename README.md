
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

**plant.p** An unknown sample system we would like to model, using Block LMS.

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

## StraightElimination
This  is a set of scripts and functions that contain a filter of periodic noise without a reference signal, based on a Wiener filter. 

The 3 main scripts of the project are the following:

**matVec.m** contains a mathematical proof that if Rw = r<sup>B</sup> then R<sup>T</sup>w<sup>B</sup> = r, where R is a complex Toeplitz matrix with the upper triangular part to be the complex conjugate of the lower triangular part and w, r vectors. With T we symbolize the Transpose matrix and with B the reversed element order vector.

**AugmWiener.m** contains an calculation of the augmented Wiener-Hopf equations using the Lagrange method.

**EliminateStraight.m** contains a calculation of the optimal Wiener filter coefficients, as well as an implementation to eliminate a periodic noise from a signal, without a reference, using a Regression Filter and a Joint Process Estimator.

In the implementations a set of helping file has been used. The helping files are store in the "helpers" folder and their summary is:

**LevinsonDurbin_iterative.m** An implementation of the Levinson-Durbin algorithm to calculate the Gamma values.

**jointProcessFilter.m** An implementation of a Joint Process Filter, to apply regression filters.

In the project there are also some resources found in the "resource" folder and their summary is:

**music.mat** A sample Matlab workspace with an example music track, including the periodic noise.

**times.txt** A text file containing  the runtimes of the Wiener, Levinson-Durbin and Regression Filter coefficient calculations, for 100, 500 and 1024 coefficients.

#### Conclusions
- Optimal Wiener Filters eliminate this kind of noises with a similar, or an even smaller computational complexity with Regression Filter. 
- Regression Filters with many coefficients require a heavy computational effort.
- The elimination of periodic noise without reference signals is possible in a good manner but it could affect the final volume of the signal

More specifications could be found in the scripts. The scripts plot all the information of the comparison. Feel free to test changing the coefficients' number.


