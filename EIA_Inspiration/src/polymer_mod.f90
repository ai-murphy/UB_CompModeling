module polymer_mod
    ! authored by: Person B
    use kinds_mod
    implicit none

    integer, parameter :: max_atoms = 2000
    real(dp), parameter :: bond_length = 1.54d0      ! C-C bond length in Angstroms
    real(dp), parameter :: bond_angle_deg = 114.0d0  ! C-C-C bond angle in degrees
    real(dp), parameter :: pi = acos(-1.0d0)

    type :: polymer_type
        integer :: n_carbons
        real(dp), allocatable :: coords(:,:) ! 3 x n_carbons
        real(dp), allocatable :: torsions(:) ! n_carbons - 3 torsions
    end type polymer_type

contains

    subroutine init_polymer(poly, n)
        type(polymer_type), intent(inout) :: poly
        integer, intent(in) :: n
        integer :: i

        poly%n_carbons = n
        allocate(poly%coords(3, n))
        allocate(poly%torsions(n-3))

        ! Initial torsions all zero (trans configuration)
        do i = 1, n-3
            poly%torsions(i) = 180.0d0
        end do

        call build_coords(poly)
    end subroutine init_polymer

    subroutine destroy_polymer(poly)
        type(polymer_type), intent(inout) :: poly
        if (allocated(poly%coords)) deallocate(poly%coords)
        if (allocated(poly%torsions)) deallocate(poly%torsions)
    end subroutine destroy_polymer

    subroutine build_coords(poly)
        type(polymer_type), intent(inout) :: poly
        integer :: i
        real(dp) :: theta_rad, bond_angle_rad
        real(dp) :: p1(3), p2(3), p3(3), p4(3)
        real(dp) :: v1(3), v2(3), n(3), n2(3), u(3), v(3), w(3)
        real(dp) :: cos_phi, sin_phi, phi_rad

        bond_angle_rad = bond_angle_deg * pi / 180.0d0
        theta_rad = pi - bond_angle_rad

        ! First atom at origin
        poly%coords(:, 1) = [0.0d0, 0.0d0, 0.0d0]

        if (poly%n_carbons >= 2) then
            ! Second atom along x-axis
            poly%coords(:, 2) = [bond_length, 0.0d0, 0.0d0]
        end if

        if (poly%n_carbons >= 3) then
            ! Third atom in xy-plane
            poly%coords(1, 3) = poly%coords(1, 2) + bond_length * cos(theta_rad)
            poly%coords(2, 3) = poly%coords(2, 2) + bond_length * sin(theta_rad)
            poly%coords(3, 3) = 0.0d0
        end if

        ! Subsequent atoms based on torsions
        do i = 4, poly%n_carbons
            phi_rad = poly%torsions(i-3) * pi / 180.0d0
            p1 = poly%coords(:, i-3)
            p2 = poly%coords(:, i-2)
            p3 = poly%coords(:, i-1)

            ! Local coordinate system at p3
            v1 = p2 - p1
            v2 = p3 - p2
            
            ! Normalize v2 to get z-axis of local frame
            w = v2 / sqrt(dot_product(v2, v2))
            
            ! Cross product v1 x v2 to get y-axis of local frame
            n = cross_product(v1, v2)
            if (sqrt(dot_product(n, n)) < 1.0d-8) then
                n = [0.0d0, 0.0d0, 1.0d0] ! Fallback if collinear
            else
                n = n / sqrt(dot_product(n, n))
            end if
            
            ! Cross product w x n to get x-axis
            u = cross_product(w, n)

            ! Position in local frame (spherical coordinates)
            ! bond length L, bond angle angle, torsion phi
            p4 = p3 + bond_length * ( &
                 -cos(theta_rad) * w + &
                 sin(theta_rad) * cos(phi_rad) * u + &
                 sin(theta_rad) * sin(phi_rad) * n )

            poly%coords(:, i) = p4
        end do
    end subroutine build_coords

    function cross_product(a, b) result(c)
        real(dp), intent(in) :: a(3), b(3)
        real(dp) :: c(3)
        c(1) = a(2)*b(3) - a(3)*b(2)
        c(2) = a(3)*b(1) - a(1)*b(3)
        c(3) = a(1)*b(2) - a(2)*b(1)
    end function cross_product

    subroutine save_pdb(poly, filename)
        type(polymer_type), intent(in) :: poly
        character(len=*), intent(in) :: filename
        integer :: i, u
        open(newunit=u, file=filename, status='replace')
        do i = 1, poly%n_carbons
            write(u, '(A6,I5,A1,A4,A1,A3,A1,A1,I4,A1,3F8.3)') &
                "HETATM", i, " ", " C  ", " ", "POL", " ", "A", 1, " ", &
                poly%coords(1,i), poly%coords(2,i), poly%coords(3,i)
        end do
        write(u, '(A)') "END"
        close(u)
    end subroutine save_pdb

    subroutine compute_observables(poly, r_ee, r_g)
        type(polymer_type), intent(in) :: poly
        real(dp), intent(out) :: r_ee, r_g
        real(dp) :: dx, dy, dz
        real(dp) :: cm(3)
        integer :: i
        real(dp) :: sum_sq_dist

        ! End-to-end distance
        dx = poly%coords(1, poly%n_carbons) - poly%coords(1, 1)
        dy = poly%coords(2, poly%n_carbons) - poly%coords(2, 1)
        dz = poly%coords(3, poly%n_carbons) - poly%coords(3, 1)
        r_ee = sqrt(dx*dx + dy*dy + dz*dz)

        ! Center of mass (assuming all C atoms have same mass, so just center of geometry)
        cm = [0.0d0, 0.0d0, 0.0d0]
        do i = 1, poly%n_carbons
            cm(1) = cm(1) + poly%coords(1, i)
            cm(2) = cm(2) + poly%coords(2, i)
            cm(3) = cm(3) + poly%coords(3, i)
        end do
        cm = cm / real(poly%n_carbons, dp)

        ! Radius of gyration
        sum_sq_dist = 0.0d0
        do i = 1, poly%n_carbons
            dx = poly%coords(1, i) - cm(1)
            dy = poly%coords(2, i) - cm(2)
            dz = poly%coords(3, i) - cm(3)
            sum_sq_dist = sum_sq_dist + dx*dx + dy*dy + dz*dz
        end do
        r_g = sqrt(sum_sq_dist / real(poly%n_carbons, dp))

    end subroutine compute_observables

end module polymer_mod
