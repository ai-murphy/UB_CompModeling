program calculate_pi
    use pi_1_module
    use pi_2_module
    implicit none

    integer :: n
    real(kind=8) :: pi_leibniz, pi_euler, pi_actual

    ! Ask user for number of terms
    write(*, '(A)', advance='no') 'Enter the number of terms (n): '
    read(*, *) n

    ! Validate input
    if (n <= 0) then
        write(*, *) 'Error: n must be a positive integer'
        stop
    end if

    ! Calculate π using both methods
    pi_leibniz = pi_1(n)
    pi_euler = pi_2(n)

    ! Calculate actual π value
    pi_actual = acos(-1.0d0)

    ! Display results
    write(*, '(A)') ''
    write(*, '(A)') '========== Results =========='
    write(*, '(A, F15.10)') 'Leibniz formula (π_1):  ', pi_leibniz
    write(*, '(A, F15.10)') 'Euler formula (π_2):    ', pi_euler
    write(*, '(A, F15.10)') 'Actual π value:         ', pi_actual
    write(*, '(A)') '============================'

end program calculate_pi