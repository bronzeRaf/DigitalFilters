# DigitalFilters
A set of digital filters in MATLAB

## Wiener
This  is a set of scripts that contain an implementation of a Wiener filter calculator. A steepest descent algorithm is purposed to calculate faster and accurate Wiener filter coefficients. 

**Wien0.m** contains a comparison between an exact Wiener-Hopf algorithm and a steepest descent algorithm to calculate the Wiener filter coefficients. The two algorithms are compared based on their runtime and their accuracy. The Wiener-Hopf algorithm is exact but requires heavy computational resources. The steepest descent algorithms uses an iterative method to approach the solution way faster. The script plots the Jw metric of the learning process of steepest descent.
Indicatively, to calculate a Wiener filter of 500 coefficients with steepest descent 

**Wien1.m** contains an example that uses the purposed steepest descent algorithm and the Wiener-Hopf algorithm to apply a Wiener filter to a sound, The sounds could be found in the "sounds.mat" and consist of:
- d > the instrumental including the noise
- u > the recording of the noise
- x > the clean instrumental
