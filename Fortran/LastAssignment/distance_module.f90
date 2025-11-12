
module distance_module
    use utils_module
    implicit none
    private
    public :: dist, dist_info, find_minmax_all, find_minmax_nonH

    !class type to store min/max pair data & counts
    type :: dist_info
        real(kind=8) :: min_dist
        integer :: min_i, min_j
        character(len=4) :: min_type_i, min_type_j

        real(kind=8) :: max_dist
        integer :: max_i, max_j
        character(len=4) :: max_type_i, max_type_j

        integer :: count_pairs
    end type dist_info

contains

    !find euclidean distance b/w 3D points.
    function dist(x1,y1,z1,x2,y2,z2) result(d)
        real(kind=8), intent(in) :: x1,y1,z1,x2,y2,z2
        real(kind=8) :: d
        d = sqrt( (x1-x2)**2 + (y1-y2)**2 + (z1-z2)**2 )
    end function dist

    !scans all pairs and updates info for min/max/count
    subroutine find_minmax_all(atom_ct, types, x, y, z, info)
        integer, intent(in) :: atom_ct
        character(len=4), intent(in) :: types(atom_ct)
        real(kind=8), intent(in) :: x(atom_ct), y(atom_ct), z(atom_ct)
        type(dist_info), intent(out) :: info

        integer :: i, j
        real(kind=8) :: d

        info%min_dist = 1.0d30
        info%max_dist = -1.0d30
        info%count_pairs = 0

        do i = 1, atom_ct-1
            do j = i+1, atom_ct
                d = dist(x(i),y(i),z(i), x(j),y(j),z(j))
                info%count_pairs = info%count_pairs + 1
                if (d < info%min_dist) then
                    info%min_dist = d
                    info%min_i = i; info%min_j = j
                    info%min_type_i = types(i); info%min_type_j = types(j)
                end if
                if (d > info%max_dist) then
                    info%max_dist = d
                    info%max_i = i; info%max_j = j
                    info%max_type_i = types(i); info%max_type_j = types(j)
                end if
            end do
        end do
    end subroutine find_minmax_all

    !like find_minmax_all(), but without Hydrogen
    subroutine find_minmax_nonH(atom_ct, types, x, y, z, info)
        integer, intent(in) :: atom_ct
        character(len=4), intent(in) :: types(atom_ct)
        real(kind=8), intent(in) :: x(atom_ct), y(atom_ct), z(atom_ct)
        type(dist_info), intent(out) :: info

        integer :: i, j
        real(kind=8) :: d
        character(len=4) :: ti, tj
        info%min_dist = 1.0d30
        info%max_dist = -1.0d30
        info%count_pairs = 0

        do i = 1, atom_ct-1
            ti = adjustl(types(i))
            if (lower_trim(ti) == 'h') cycle
            do j = i+1, atom_ct
                tj = adjustl(types(j))
                if (lower_trim(tj) == 'h') cycle
                d = dist(x(i),y(i),z(i), x(j),y(j),z(j))
                info%count_pairs = info%count_pairs + 1
                if (d < info%min_dist) then
                    info%min_dist = d
                    info%min_i = i; info%min_j = j
                    info%min_type_i = types(i); info%min_type_j = types(j)
                end if
                if (d > info%max_dist) then
                    info%max_dist = d
                    info%max_i = i; info%max_j = j
                    info%max_type_i = types(i); info%max_type_j = types(j)
                end if
            end do
        end do
    end subroutine find_minmax_nonH

end module distance_module