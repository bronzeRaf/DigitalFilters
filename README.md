# DigitalFilters
A set of digital filters in MATLAB

## Wiener
This  is a set of scripts that contain an implementation of a Wiener filter calculator. A steepest descent algorithm is purposed to calculate faster and accurate the Wiener filter coefficients. 

**Wien0.m** contains a comparison between an exact Wiener-Hopf algorithm and a steepest descent algorithm to calculate the Wiener filter coefficients. The two algorithms are compared based on their runtime and their accuracy. For the comparison, a sinoid is used to represent the signal and a white noise  to represent the noise that the filters should cutoff. 

**Wien1.m** contains an example that uses the purposed steepest descent algorithm and the Wiener-Hopf algorithm to apply a Wiener filter to a song. The song could be found in the "sounds.mat" and consist of:
- d > the instrumental including the noise
- u > the recording of the noise
- x > the clear instrumental

#### Conclusions
- The Wiener-Hopf algorithm is exact but requires heavy computational resources. 
- The steepest descent algorithms uses an iterative method to approach the solution way faster. 
- The steepest descent algorithm may need optimization, on the learning rate and the number of iterations in some cases. In this case it is optimized for general purpose filters.

More specifications could be found in the table below:

|  Algorithm                   | Runtime  | Number of Coeffiecients | Parameter Error |
|------------------------------|----------|-------------------------|-----------------|
| Wiener-Hopf                  | 326 secs | 500                     | 0               |
| Steepest Descent (3000 iter) |          | 500                     |                 |

