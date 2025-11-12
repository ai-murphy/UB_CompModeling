program Exercise1
implicit none

    ! declare variables
    real :: num1, num2, modnum

    !Prompt user for numbers
    print *,'Enter 2 integers. Number 1?'
    read *, num1

    print *,'Now number 2?'
    read *, num2

    !Evaluate numbers and display the greater of the 2
    print *,'Got it - you entered ', num1, ' and ', num2
    if (num1 > num2) then
        print *, 'Number 1 (', num1, ') is the greater number.'
    else
        print *, 'Number 2 (', num2, ') is the greater number.'
    end if

    if (modnum == 0) then
        print *, 'which is divisible by the other number.'
    else
        print *, 'which is not divisible by the other number.'
    end if

end program Exercise1



!!!!OUTPUT!!!!
!---------------
! Enter 2 integers. Number 1?
!5
! Now number 2?
!8
! Got it - you entered    5.00000000      and    8.00000000
! Number 2 (   8.00000000     ) is the greater number.
! which is not divisible by the other number.