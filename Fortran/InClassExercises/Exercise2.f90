program Exercise2
implicit none

    !declare vars
    integer :: i
    real, dimension(10) :: vector1, vector2
    real :: dot_product

    call random_number(vector1)
    call random_number(vector2)

    do i = 1, 10
        dot_product = dot_product + vector1(i) * vector2(i)        
    end do

    print *, "Vector 1: ", vector1
    print *, "Vector 2: ", vector2
    print *, "Scalar product: ", dot_product

end program

!!!OUTPUT!!!
!-----------
! Vector 1:   0.924184144       1.90124512E-02  0.365186036      0.614554107      0.363096356      0.317839622       5.27833700E-02  0.188417733      0.159953833      0.348423898
! Vector 2:   0.129475176      0.561719477      0.435007751      0.856184125      0.682268202      0.790467441      0.800969899      0.425792277      0.915916920      0.709400535
! Scalar product:    1.83052087