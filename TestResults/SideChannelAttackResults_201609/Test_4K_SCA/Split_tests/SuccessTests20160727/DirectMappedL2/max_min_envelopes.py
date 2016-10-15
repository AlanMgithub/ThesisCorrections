from numpy import array, sign, zeros
from scipy.interpolate import interp1d
from matplotlib.pyplot import plot,show,hold,grid
import numpy

from scipy.interpolate import interp1d

#s = array([1,4,3,5,3,2,4,3,4,5,4,3,2,5,6,7,8,7,8]) #This is your noisy vector of values.
s = array([
55
,32
,75
,61
,55
,39
,67
,61
,45
,47
,44
,52
,73
,43
,49
,42
,55
,71
,45
,47
,46
,50
,73
,43
,49
,44
,53
,71
,45
,47
,46
,50
,73
,43
,49
,44
,53
,71
,45
,47
,46
,50
,73
,43
,49
,44
,53
,71
,45
,47
,46
,50
,73
,43
,49
,44
,53
,71
,45
,47
,46
,50
,73
,43
]) #This is your noisy vector of values.

q_u = zeros(s.shape)
q_l = zeros(s.shape)

#Prepend the first value of (s) to the interpolating values. This forces the model to use the same starting point for both the upper and lower envelope models.

u_x = [0,]
u_y = [s[0],]

l_x = [0,]
l_y = [s[0],]

#Detect peaks and troughs and mark their location in u_x,u_y,l_x,l_y respectively.
N = 1
for k in xrange(1,len(s)-N):
    if (sign(s[k]-s[k-N])==1) and (sign(s[k]-s[k+N])==1):
        u_x.append(k)
        u_y.append(s[k])

    if (sign(s[k]-s[k-N])==-1) and ((sign(s[k]-s[k+N]))==-1):
        l_x.append(k)
        l_y.append(s[k])

#Append the last value of (s) to the interpolating values. This forces the model to use the same ending point for both the upper and lower envelope models.

u_x.append(len(s)-1)
u_y.append(s[-1])

l_x.append(len(s)-1)
l_y.append(s[-1])

#Fit suitable models to the data. Here I am using cubic splines, similarly to the MATLAB example given in the question.

u_p = interp1d(u_x,u_y, kind = 'cubic',bounds_error = False, fill_value=0.0)
l_p = interp1d(l_x,l_y,kind = 'cubic',bounds_error = False, fill_value=0.0)

#Evaluate each model over the domain of (s)
for k in xrange(0,len(s)):
    q_u[k] = u_p(k)
    q_l[k] = l_p(k)

#Plot everything
plot(s);hold(True);plot(q_u,'r');plot(q_l,'g');grid(True);show()
