!===================================================== QUANOR.FOR
      DOUBLE PRECISION FUNCTION QUANOR(F,PARA)
!***********************************************************************
!*                                                                     *
!*  FORTRAN CODE WRITTEN FOR INCLUSION IN IBM RESEARCH REPORT RC20525, *
!*  'FORTRAN ROUTINES FOR USE WITH THE METHOD OF L-MOMENTS, VERSION 3' *
!*                                                                     *
!*  J. R. M. HOSKING                                                   *
!*  IBM RESEARCH DIVISION                                              *
!*  T. J. WATSON RESEARCH CENTER                                       *
!*  YORKTOWN HEIGHTS                                                   *
!*  NEW YORK 10598, U.S.A.                                             *
!*                                                                     *
!*  VERSION 3     AUGUST 1996                                          *
!*                                                                     *
!***********************************************************************
!
!  QUANTILE FUNCTION OF THE NORMAL DISTRIBUTION
!
!  OTHER ROUTINES USED: QUASTN
!
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      DOUBLE PRECISION PARA(2)
      DATA ZERO/0D0/,ONE/1D0/
      IF(PARA(2).LE.ZERO) write(6,*) 'PARA(2)=',PARA(2)
      IF(PARA(2).LE.ZERO)GOTO 1000
      IF(F.LE.ZERO.OR.F.GE.ONE)GOTO 1010
      QUANOR=PARA(1)+PARA(2)*QUASTN(F)
      RETURN
!
 1000 WRITE(6,7000)
      QUANOR=ZERO
      RETURN
 1010 WRITE(6,7010)
      QUANOR=ZERO
      RETURN
!
 7000 FORMAT(' *** ERROR *** ROUTINE QUANOR : PARAMETERS INVALID')
 7010 FORMAT(' *** ERROR *** ROUTINE QUANOR :',
     *  ' ARGUMENT OF FUNCTION INVALID')
      END
