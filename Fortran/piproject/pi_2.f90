module pi_2_module
    implicit none
contains
    function pi_2(n) result(pi_approx)
        implicit none
        integer, intent(in) :: n
        real(kind=8) :: pi_approx
        integer :: k
        real(kind=8) :: sum_term

        sum_term = 0.0d0
        do k = 1, n
            sum_term = sum_term + 1.0d0 / (real(k, kind=8)**2)
        end do

        pi_approx = sqrt(6.0d0 * sum_term)
    end function pi_2
end module pi_2_module