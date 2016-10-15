#!/usr/bin/env python

from numpy import *
from scipy import *
from scipy.signal import *
from pylab import *


# Generate AM-modulated sinusoid
N = 256
t = linspace(0,2,N)

# Modulator
m = 1 + .2*cos(2*pi*t)

# Carrier
c = sin(2*pi*20*t)

# Signal is modulator times carrier
x = m*c
print x

# Calculate envelope, called m_hat via hilbert transform
m_hat = abs(hilbert(x))

# Plot x
plot(t, x)
plot(t, m_hat)
axis('tight')
xlabel('Time (seconds)')
ylabel('Amplitude')
title('X, with calculated envelope')
legend(['x', 'm_hat'])
ylim(-2,2)
show()
