
module groups_module
    use utils_module
    use distance_module
    implicit none
    private
    public :: count_hydroxyls, count_carbonyls

contains

    !counts the hydrxyl groups
    function count_hydroxyls(atom_ct, types, x, y, z) result(n_oh)
        integer, intent(in) :: atom_ct
        character(len=4), intent(in) :: types(atom_ct)
        real(kind=8), intent(in) :: x(atom_ct), y(atom_ct), z(atom_ct)
        integer :: n_oh
        integer :: i, j
        real(kind=8) :: d
        character(len=4) :: ti, tj

        n_oh = 0
        do i = 1, atom_ct
            ti = lower_trim(adjustl(types(i)))
            if (ti /= 'o') cycle
            do j = 1, atom_ct
                if (j == i) cycle
                tj = lower_trim(adjustl(types(j)))
                if (tj /= 'h') cycle
                d = dist(x(i),y(i),z(i), x(j),y(j),z(j))
                if (d >= 0.94d0 .and. d <= 1.05d0) then
                    n_oh = n_oh + 1
                end if
            end do
        end do
    end function count_hydroxyls

    !counts the carbonyl groups
    function count_carbonyls(atom_ct, types, x, y, z) result(n_co)
        integer, intent(in) :: atom_ct
        character(len=4), intent(in) :: types(atom_ct)
        real(kind=8), intent(in) :: x(atom_ct), y(atom_ct), z(atom_ct)
        integer :: n_co
        integer :: i, j
        real(kind=8) :: d
        character(len=4) :: ti, tj

        n_co = 0
        do i = 1, atom_ct
            ti = lower_trim(adjustl(types(i)))
            if (ti /= 'c') cycle
            do j = 1, atom_ct
                if (j == i) cycle
                tj = lower_trim(adjustl(types(j)))
                if (tj /= 'o') cycle
                d = dist(x(i),y(i),z(i), x(j),y(j),z(j))
                if (d >= 1.20d0 .and. d <= 1.30d0) then
                    n_co = n_co + 1
                end if
            end do
        end do
    end function count_carbonyls

end module groups_module
