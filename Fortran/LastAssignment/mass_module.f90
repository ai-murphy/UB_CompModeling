module mass_module
    use utils_module
    implicit none
    private
    public :: compute_molar_mass

contains

    !computes the molar mass of given atoms/types in g/mol
    function compute_molar_mass(atom_ct, types) result(total_mass)
        integer, intent(in) :: atom_ct
        character(len=4), intent(in) :: types(atom_ct)
        real(kind=8) :: total_mass
        integer :: i
        real(kind=8) :: m

        total_mass = 0.0d0
        do i = 1, atom_ct
            m = atom_mass(types(i))
            if (m <= 0.0d0) then
                write(*,*) 'Warning: unrecognized atom type "', trim(types(i)), '" treated as mass 0.'
            end if
            total_mass = total_mass + m
        end do
    end function compute_molar_mass

end module mass_module
