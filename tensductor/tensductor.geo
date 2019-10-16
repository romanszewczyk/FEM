# MIT License
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
#
#  Netgen 6.2 required 
#

algebraic3d

solid tens_core = orthobrick (-17.5, -17.5, -0.3; 17.5, 17.5, 0.3);

solid hole1 = cylinder (8.5, 8.5, 1; 8.5, 8.5, -1; 2) 
	and plane (0, 0, -0.8; 0, 0, -1)
	and plane (0, 0, 0.8; 0, 0, 1);

solid hole2 = cylinder (8.5, -8.5, 1; 8.5, -8.5, -1; 2) 
	and plane (0, 0, -0.8; 0, 0, -1)
	and plane (0, 0, 0.8; 0, 0, 1);

solid hole3 = cylinder (-8.5, 8.5, 1; -8.5, 8.5, -1; 2) 
	and plane (0, 0, -0.8; 0, 0, -1)
	and plane (0, 0, 0.8; 0, 0, 1);

solid hole4 = cylinder (-8.5, -8.5, 1; -8.5, -8.5, -1; 2) 
	and plane (0, 0, -0.8; 0, 0, -1)
	and plane (0, 0, 0.8; 0, 0, 1);

solid tens = tens_core and not hole1 and not hole2 and not hole3 and not hole4 -maxh=0.4;

solid via1 = cylinder (8.5, 8.5, 4; 8.5, 8.5, -4; 1.2) 
	and plane (0, 0, -3; 0, 0, -1)
	and plane (0, 0, 3; 0, 0, 1);
	
solid via2 = cylinder (-8.5, -8.5, 3; -8.5, -8.5, -3; 1.2) 
	and plane (0, 0, -3; 0, 0, -1)
	and plane (0, 0, 3; 0, 0, 1);



solid cable1 = cylinder (-9, -9, 2; 9, 9, 2; 1) 
	and plane (-8.5, -8.5, 2; -1, -1, 0)
	and plane (8.5, 8.5, 2; 1, 1, 0);solid cable2 = cylinder (-9, -9, -2; 9, 9, -2; 1) 
	and plane (-8.5, -8.5, 2; -1, -1, 0)
	and plane (8.5, 8.5, 2; 1, 1, 0);
	
solid szpara = cylinder (-1, -1, -2; 1, 1, -2; 1.2) 
				and plane (-0.1, -0.1, -2; -1, -1, 0)
				and plane (0.1, 0.1, -2; 1, 1, 0);			
	
solid cable2 = cylinder (-9, -9, -2; 9, 9, -2; 1) 
	and plane (-8.5, -8.5, 2; -1, -1, 0)
	and plane (8.5, 8.5, 2; 1, 1, 0);
	
solid cable = via1 or via2 or cable1 or cable2 and not szpara -maxh=0.4;

solid range = sphere (0, 0, 0; 300)
      and not tens
      and not cable;

tlo tens;
tlo cable -col=[1,0,0];
tlo range -col=[1,0,0] -transparent;
