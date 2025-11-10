module expr1_module
    implicit none
contains
    function calc_v1(k2, E0, S, KM) result(v1)
        real(kind=8), intent(in) :: k2, E0, S, KM
        real(kind=8) :: v1
        
        v1 = k2 * E0 * S / (KM + S)
    end function calc_v1
end module expr1_module