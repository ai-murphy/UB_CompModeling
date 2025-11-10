module pi_1_module
    implicit none
contains
    function pi_1(n) result(pi_approx)
        implicit none
        integer, intent(in) :: n
        real(kind=8) :: pi_approx
        integer :: k
        real(kind=8) :: sum_term

        sum_term = 0.0d0
        do k = 0, n - 1
            sum_term = sum_term + ((-1.0d0)**k) / (2.0d0 * k + 1.0d0)
        end do

        pi_approx = 4.0d0 * sum_term
    end function pi_1
end module pi_1_module