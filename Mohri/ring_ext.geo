# MIT License
# 
# Copyright (c) 2019 Roman Szewczyk, rszewczyk@onet.pl
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
# --------------------------------------------------------------
#
# Ring shaped core magnetized by single wire
#
# Netgen 6.2 required
#
# --------------------------------------------------------------

algebraic3d

# Ring core

solid RingOut = cylinder ( 0, 0, -0.0035; 0, 0, 0.0035; 0.015)
	and plane (0, 0, -0.003; 0, 0, -1)
	and plane (0, 0,  0.003; 0, 0, 1);

solid RingIn= cylinder ( 0, 0, -0.004; 0, 0, 0.004; 0.0124)
	and plane (0, 0, -0.0035; 0, 0, -1)
	and plane (0, 0,  0.0035; 0, 0, 1);

solid Ring = RingOut and not RingIn; 


#cutting plane 1:

solid Ring1= Ring and plane (0.0145, 0, 0; 1, 0, 0);

#cutting plane 2:

solid Ring2= Ring1 and plane (-0.0145, 0, 0; -1, 0, 0)
	-maxh=0.00025; 

# Cable

solid Cable = cylinder ( 0, 0, -0.12; 0, 0, 0.12; 0.002 )
	and plane (0, 0, -0.1; 0, 0, -1)
	and plane (0, 0,  0.1; 0, 0, 1) -maxh=0.0005; 

# Sphere

solid Range = sphere (0, 0, 0; 0.3) 
	 and not Ring2
	 and not Cable -maxh=0.2;  


tlo Ring2 -col=[0,0,1];

tlo Cable -col=[0,1,0];

tlo Range -col=[1,0,0] -transparent;
