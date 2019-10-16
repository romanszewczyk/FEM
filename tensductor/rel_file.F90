! MIT License
! 
! Permission is hereby granted, free of charge, to any person obtaining a copy
! of this software and associated documentation files (the "Software"), to deal
! in the Software without restriction, including without limitation the rights
! to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
! copies of the Software, and to permit persons to whom the Software is
! furnished to do so, subject to the following conditions:
! 
! The above copyright notice and this permission notice shall be included in all
! copies or substantial portions of the Software.
! 
! THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
! IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
! FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
! AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
! LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
! OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
! SOFTWARE.
!
module ReluctInterp
 contains 

  function LinInterpSimple(x0) RESULT(y0)
	USE Types 
	IMPLICIT None
	real(kind=dp) :: x0, y0

        y0 = 5715.063+266.726*x0*1d-6

  end function LinInterpSimple


  function LinInterp(x0i) RESULT(y0)
	USE Types 
	IMPLICIT None
	real(kind=dp) :: x0, x0i, y0
	real, Dimension(69) :: xT, yT
	integer :: i
      
	x0=x0i / 1d6		! Convert to MPa

	xT = [-5.00, -4.75, -4.50, -4.25, -4.00, -3.75, -3.50, -3.25, -3.00, -2.75, -2.50, &
	      -2.25, -2.00, -1.75, -1.50, -1.25, -1.00, -0.75, -0.50, -0.25, 0.00, 0.25, &
	      0.50, 0.75, 1.00, 1.25, 1.50, 1.75, 2.00, 2.25, 2.50, 2.75, 3.00, 3.25, 3.50, &
              3.75, 4.00, 4.25, 4.50, 4.75, 5.00, 5.25, 5.50, 5.75, 6.00, 6.25, 6.50, 6.75, &
              7.00, 7.25, 7.50, 7.75, 8.00, 8.25, 8.50, 8.75, 9.00, 9.25, 9.50, 9.75, 10.00, &
              10.25, 10.50, 10.75, 11.00, 11.25, 11.50, 11.75, 12.00] 

	yT = [4870.0, 4871.6, 4874.0, 4876.8, 4880.0, 4883.6, 4887.9, 4893.3, 4900.0, 4910.2, &
	     4924.8, 4941.9, 4960.0, 4979.3, 5000.9, 5024.6, 5050.0, 5075.1, 5101.2, 5132.9, &
	     5175.0, 5251.9, 5353.9, 5456.5, 5541.7, 5630.1, 5746.7, 5859.8, 5929.8, 5995.8, &
             6069.8, 6159.0, 6288.2, 6370.2, 6469.1, 6565.3, 6644.1, 6700.5, 6734.0, 6773.6, &
             6804.1, 6808.9, 6802.3, 6775.0, 6670.0, 6592.6, 6522.8, 6459.2, 6400.0, 6343.5, &
             6290.0, 6241.6, 6200.0, 6164.7, 6133.2, 6105.2, 6080.0, 6055.5, 6032.0, 6012.5, &
             6000.0, 5993.0, 5987.7, 5983.5, 5980.0, 5976.8, 5974.0, 5971.6, 5970.0]
	
	if (x0 .LT. xT(1)) then
	   y0=yT(1)

	else if (x0 .GT. xT(69)) then
           y0=yT(69)

	else

	  i=floor(1+(x0+5)/0.25)
	  y0=yT(i)+(x0-xT(i))*(yT(i+1)-yT(i))/(xT(i+1)-xT(i))

	end if

  end function LinInterp


  function Matrix3x3Inv(Ri) RESULT(Ro)
	USE Types 
	IMPLICIT None
	real(kind=dp), Dimension (3,3) :: Ri, Ro
	real(kind=dp) :: Det, s

  Det = Ri(1,1)*Ri(2,2)*Ri(3,3)-Ri(1,1)*Ri(2,3)*Ri(3,2)- & 
        Ri(1,2)*Ri(2,1)*Ri(3,3)+Ri(1,2)*Ri(2,3)*Ri(3,1)+ & 
        Ri(1,3)*Ri(2,1)*Ri(3,2)-Ri(1,3)*Ri(2,2)*Ri(3,1)		! direct calculatios version

  if (Det .NE. 0) then
     s = 1d0 / Det
  else
     s = 1d25
  end if
    
  Ro(1,1) =  s *   (Ri(2,2)*Ri(3,3) - Ri(3,2)*Ri(2,3))
  Ro(2,1) = -1*s * (Ri(2,1)*Ri(3,3) - Ri(3,1)*Ri(2,3))
  Ro(3,1) =  s *   (Ri(2,1)*Ri(3,2) - Ri(3,1)*Ri(2,2))
    
  Ro(1,2) = -1*s * (Ri(1,2)*Ri(3,3) - Ri(3,2)*Ri(1,3))
  Ro(2,2) =  s *   (Ri(1,1)*Ri(3,3) - Ri(3,1)*Ri(1,3))
  Ro(3,2) = -1*s * (Ri(1,1)*Ri(3,2) - Ri(3,1)*Ri(1,2))

  Ro(1,3) =  s *   (Ri(1,2)*Ri(2,3) - Ri(2,2)*Ri(1,3))
  Ro(2,3) = -1*s * (Ri(1,1)*Ri(2,3) - Ri(2,1)*Ri(1,3))
  Ro(3,3) =  s *   (Ri(1,1)*Ri(2,2) - Ri(2,1)*Ri(1,2))

  end function Matrix3x3Inv



end module ReluctInterp

!-------------------------------------------------------------------------------

SUBROUTINE reluct_func(Model, n, X, Y)

  USE DefUtils
  USE ReluctInterp

  IMPLICIT NONE
  TYPE(Model_t) :: Model
  INTEGER :: n
  REAL(KIND=dp) :: X(*)
  REAL(KIND=dp), POINTER CONTIG :: Y(:,:)
  
  REAL(KIND=dp) :: PSx, PSy, PAxx, args(3), mi0, v
  REAL(KIND=dp) :: sin_fi, cos_fi, ssx, ssy, ssz
  REAL(KIND=dp) :: mirx, miry, mirz, mix, miy, miz
  REAL(KIND=dp) :: relx, rely, relz

  Real(KIND=dp), dimension (3,3) :: reluct, reluctT, R


  PSx = X(1)
  PSy = X(2)
  PAxx = X(3)			! receive args

! -- end of variable import --

  mi0 = 1.256637061436d-06   	! mi0=4*3.14159265359*1e-7
  v = 3d-1			! Poison ration

  sin_fi = sin(PAxx)
  cos_fi = cos(PAxx)		! sinus and cosinus of Z axis rotation angle

  ssx = PSx-v*PSy
  ssy = PSy-v*PSx 
  ssz = 0d0			! effective stresses calculated from principal stresses 

  mirx = LinInterpSimple(ssx)
  miry = LinInterpSimple(ssy)
  mirz = LinInterpSimple(ssz)

!  mirx = LinInterp(ssx)
!  miry = LinInterp(ssy)
!  mirz = LinInterp(ssz)	! values of diagonal tensor of relative permeability
				! determined from linear interpolation in function LinInterp

  if (mirx .LT. 20) then 
     mirx = 20
  end if
  if (miry .LT. 20) then 
     miry = 20
  end if
  if (mirz .LT. 20) then 
     mirz = 20
  end if			! limit lower value of relative permeabiltity to 20


  mix = mi0*mirx
  miy = mi0*miry
  miz = mi0*mirz		! calculate the permeability


  relx = 1/mix
  rely = 1/miy
  relz = 1/miz			! calculate diagonal values of reluctivity tensor


  reluctT(1,1) = relx
  reluctT(2,2) = rely
  reluctT(3,3) = relz		! reluctivity tensor matrix
  
  reluctT(1,2) = 0d0
  reluctT(1,3) = 0d0
  reluctT(2,1) = 0d0
  reluctT(2,3) = 0d0
  reluctT(3,1) = 0d0
  reluctT(3,2) = 0d0		! set zeros to other


  R(3,3)=1d0
  R(1,1)=cos_fi
  R(2,2)=cos_fi
  R(1,2)=(-1)*sin_fi
  R(2,1)=sin_fi			! rotation matrix

  R(1,3) = 0d0
  R(2,3) = 0d0
  R(3,1) = 0d0
  R(3,2) = 0d0			! set zeros to other

  reluct=MatMul(R,MatMul(reluctT,Matrix3x3Inv(R)))	 ! rotation of tensor reluctT by rotation matrix R
							 ! reluct = R * teluctT * R'

! -- export variables --

  Y(1,1)=reluct(1,1)
  Y(1,2)=reluct(1,2)
  Y(1,3)=reluct(1,3)

  Y(2,1)=reluct(2,1)
  Y(2,2)=reluct(2,2)
  Y(2,3)=reluct(2,3)

  Y(3,1)=reluct(3,1)
  Y(3,2)=reluct(3,2)
  Y(3,3)=reluct(3,3)

END SUBROUTINE reluct_func

