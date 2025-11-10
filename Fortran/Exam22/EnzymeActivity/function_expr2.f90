module expr2_module
    implicit none
contains
    function calc_v2(k2, E0, S, KM, I, KI) result(v2)
        real(kind=8), intent(in) :: k2, E0, S, KM, I, KI
        real(kind=8) :: v2
        
        v2 = k2 * E0 * S / (KM * (1.0d0 + I/KI) + S)
    end function calc_v2
end module expr2_module