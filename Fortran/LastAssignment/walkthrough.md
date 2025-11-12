# Homework Exercise

## Task Prompt
Make a program in Fortran90 that analyze the coordinates of a given molecule.

- The user has to especify the name of the file having the molecular coordinates in
xyz format.
- Using a function, the program has to determine the molar mass (in g/mol) of the
given molecule.
- The program has to determine the maximum a minimum distance among all atoms.
It should be indicated the type and numbering of those atoms.
- The program has to determine the maximum a minimum distance among heavy
atoms (all atoms except hydrogens).
It should be indicated the type and numbering of those atoms.
- The program has to determine the number of hydroxil groups. Consider a range of
O-H distances from 0.94 to 1.05 angstroms.
- The program has to determine the number of carbonils groups. Consider a range of
C-O distances from 1.20 to 1.30
- Separate functions and/or subroutines in different files. Generate the executable
with a makefile.

## File Tree
~~~
project/
├── main.f90
├── mass_module.f90
├── distance_module.f90
├── groups_module.f90
├── utils_module.f90
└── Makefile
~~~

## Notes & Assumptions
- The program assumes an .xyz format with lines like: Element X Y Z (Example: "O 0.000000 0.000000 0.000000")
- Atomic masses are defined for common elements in utils_mod::atom_mass. Unknown element types produce a mass warning and are counted as zero mass.
- Hydroxyls are counted per O–H bond that falls inside 0.94–1.05 Å. If an O has two Hs both in range they will be counted twice (adjust logic if you want to count unique OH groups per O).
- Carbonyls are counted per C–O pair with distance in 1.20–1.30 Å. If you want stricter chemical rules (e.g., ensure O has double-bond geometry or that O is not bonded to H), extend the logic.
- The non-H min/max search excludes atoms whose type string (case-insensitive) equals 'H'.
- File and type parsing are simple; element labels longer than 4 characters will be truncated. Adjust character lengths if needed.

Save each code block to a separate file with the filename indicated, run `make`, then execute `./mol_analyze` and supply the .xyz filename when prompted.


## groups_module.f90
~~~Fortran

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
~~~

## utils_module.f90
~~~Fortran
module utils_module
    implicit none
    private
    public :: read_xyz, lower_trim, atom_mass

contains

    !converts atomic symbol characters to lowercase for select case in atom_mass()
    function lower_trim(s) result(out)
        character(len=*), intent(in) :: s
        character(len=len(s)) :: out
        integer :: i
        out = s
        do i = 1, len(s)
            if (ichar(s(i:i)) >= ichar('A') .and. ichar(s(i:i)) <= ichar('Z')) then
                out(i:i) = char(ichar(s(i:i)) + 32)
            else
                out(i:i) = s(i:i)
            end if
        end do
        out = adjustl(out)
    end function lower_trim

    !reads an xyz-formatted file, skipping comment lines,
    !returning number of atoms (atom_ct), their types & coords
    subroutine read_xyz(filename, atom_ct, types, x, y, z, ios)
        character(len=*), intent(in) :: filename
        integer, intent(out) :: atom_ct
        character(len=4), allocatable, intent(out) :: types(:)
        real(kind=8), allocatable, intent(out) :: x(:), y(:), z(:)
        integer, intent(out) :: ios

        integer :: iunit, i, stat
        character(len=512) :: line
        character(len=20) :: atype
        real(kind=8) :: xi, yi, zi
        
        iunit = 10
        open(unit=iunit, file=trim(filename), status='old', action='read', iostat=stat)
        if (stat /= 0) then
            ios = stat
            return
        end if

        read(iunit,*,iostat=stat) atom_ct
        if (stat /= 0) then
            ios = stat
            close(iunit)
            return
        end if

        ! skip comment line
        read(iunit, '(A)', iostat=stat) line

        allocate(types(atom_ct))
        allocate(x(atom_ct), y(atom_ct), z(atom_ct))

        do i = 1, atom_ct
            read(iunit,*,iostat=stat) atype, xi, yi, zi
            if (stat /= 0) then
                ios = stat
                close(iunit)
                return
            end if
            types(i) = adjustl(atype)
            x(i) = xi; y(i) = yi; z(i) = zi
        end do

        close(iunit)
        ios = 0
    end subroutine read_xyz

    !returns the atomic mass given the atomic symbol
    function atom_mass(atom) result(mass)
        character(len=*), intent(in) :: atom
        real(kind=8) :: mass
        character(len=:), allocatable :: a
        a = lower_trim(adjustl(atom))
        select case(trim(a))
        case('h', 'hydrogen')
            mass = 1.0080d0
        case('he', 'helium')
            mass = 4.002d0
        case('li', 'lithium')
            mass = 6.94d0
        case('be', 'beryllium')
            mass = 9.012d0
        case('b', 'boron')
            mass = 10.81d0
        case('c', 'carbon')
            mass = 12.011d0
        case('n', 'nitrogen')
            mass = 14.007d0
        case('o', 'oxygen')
            mass = 15.999d0
        case('f', 'fluorine')
            mass = 18.998d0
        case('ne', 'neon')
            mass = 20.1797d0
        case('na', 'sodium')
            mass = 22.989d0
        case('mg', 'magnesium')
            mass = 24.305d0
        case('al', 'aluminium')
            mass = 26.981d0
        case('si', 'silicon')
            mass = 28.085d0
        case('p', 'phosphorus')
            mass = 30.973d0
        case('s', 'sulfur')
            mass = 32.06d0
        case('cl', 'chlorine')
            mass = 35.45d0
        case('ar', 'argon')
            mass = 39.95d0
        case('k', 'potassium')
            mass = 39.0983d0
        case('ca', 'calcium')
            mass = 40.078d0
        case('sc', 'scandium')
            mass = 44.955d0
        case('ti', 'titanium')
            mass = 47.867d0
        case('v', 'vanadium')
            mass = 50.9415d0
        case('cr', 'chromium')
            mass = 51.9961d0
        case('mn', 'manganese')
            mass = 54.938d0
        case('fe', 'iron')
            mass = 55.845d0
        case('co', 'cobalt')
            mass = 58.933d0
        case('ni', 'nickel')
            mass = 58.6934d0
        case('cu', 'copper')
            mass = 63.546d0
        case('zn', 'zinc')
            mass = 65.38d0
        case('ga', 'gallium')
            mass = 69.723d0
        case('ge', 'germanium')
            mass = 72.630d0
        case('as', 'arsenic')
            mass = 74.921d0
        case('se', 'selenium')
            mass = 78.971d0
        case('br', 'bromine')
            mass = 79.904d0
        case('kr', 'krypton')
            mass = 83.798d0
        case('rb', 'rubidium')
            mass = 85.4678d0
        case('sr', 'strontium')
            mass = 87.62d0
        case('y', 'yttrium')
            mass = 88.905d0
        case('zr', 'zirconium')
            mass = 91.222d0
        case('nb', 'niobium')
            mass = 92.906d0
        case('mo', 'molybdenum')
            mass = 95.95d0
        case('tc', 'technetium')
            mass = 97.0d0
        case('ru', 'ruthenium')
            mass = 101.07d0
        case('rh', 'rhodium')
            mass = 102.905d0
        case('pd', 'palladium')
            mass = 106.42d0
        case('ag', 'silver')
            mass = 107.8682d0
        case('cd', 'cadmium')
            mass = 112.414d0
        case('in', 'indium')
            mass = 114.818d0
        case('sn', 'tin')
            mass = 118.710d0
        case('sb', 'antimony')
            mass = 121.760d0
        case('te', 'tellurium')
            mass = 127.60d0
        case('i', 'iodine')
            mass = 126.904d0
        case('xe', 'xenon')
            mass = 131.293d0
        case('cs', 'caesium')
            mass = 132.905d0
        case('ba', 'barium')
            mass = 137.327d0
        case('la', 'lanthanum')
            mass = 138.905d0
        case('ce', 'cerium')
            mass = 140.116d0
        case('pr', 'praseodymium')
            mass = 140.907d0
        case('nd', 'neodymium')
            mass = 144.242d0
        case('pm', 'promethium')
            mass = 145.0d0
        case('sm', 'samarium')
            mass = 150.36d0
        case('eu', 'europium')
            mass = 151.964d0
        case('gd', 'gadolinium')
            mass = 157.249d0
        case('tb', 'terbium')
            mass = 158.925d0
        case('dy', 'dysprosium')
            mass = 162.500d0
        case('ho', 'holmium')
            mass = 164.930d0
        case('er', 'erbium')
            mass = 167.259d0
        case('tm', 'thulium')
            mass = 168.934d0
        case('yb', 'ytterbium')
            mass = 173.045d0
        case('lu', 'lutetium')
            mass = 174.966d0
        case('hf', 'hafnium')
            mass = 178.486d0
        case('ta', 'tantalum')
            mass = 180.947d0
        case('w', 'tungsten')
            mass = 183.84d0
        case('re', 'rhenium')
            mass = 186.207d0
        case('os', 'osmium')
            mass = 190.23d0
        case('ir', 'iridium')
            mass = 192.217d0
        case('pt', 'platinum')
            mass = 195.084d0
        case('au', 'gold')
            mass = 196.966d0
        case('hg', 'mercury')
            mass = 200.592d0
        case('tl', 'thallium')
            mass = 204.38d0
        case('pb', 'lead')
            mass = 207.2d0
        case('bi', 'bismuth')
            mass = 208.980d0
        case('po', 'polonium')
            mass = 1.0d0
        case('at', 'astatine')
            mass = 1.0d0
        case('rn', 'radon')
            mass = 222.0d0
        case('fr', 'francium')
            mass = 223.0d0
        case('ra', 'radium')
            mass = 226.0d0
        case('ac', 'actinium')
            mass = 227.0d0
        case('th', 'thorium')
            mass = 232.0377d0
        case('pa', 'protactinium')
            mass = 231.035d0
        case('u', 'uranium')
            mass = 238.028d0
        case('np', 'neptunium')
            mass = 237.0d0
        case('pu', 'plutonium')
            mass = 244.0d0
        case('am', 'americium')
            mass = 243.0d0
        case('cm', 'curium')
            mass = 247.0d0
        case('bk', 'berkelium')
            mass = 247.0d0
        case('cf', 'californium')
            mass = 251.0d0
        case('es', 'einsteinium')
            mass = 252.0d0
        case('fm', 'fermium')
            mass = 257.0d0
        case('md', 'mendelevium')
            mass = 258.0d0
        case('no', 'nobelium')
            mass = 259.0d0
        case('lr', 'lawrencium')
            mass = 262.0d0
        case('rf', 'rutherfordium')
            mass = 267.0d0
        case('db', 'dubnium')
            mass = 270.0d0
        case('sg', 'seaborgium')
            mass = 269.0d0
        case('bh', 'bohrium')
            mass = 270.0d0
        case('hs', 'hassium')
            mass = 270.0d0
        case('mt', 'meitnerium')
            mass = 278.0d0
        case('ds', 'darmstadtium')
            mass = 281.0d0
        case('rg', 'roentgenium')
            mass = 281.0d0
        case('cn', 'copernicium')
            mass = 285.0d0
        case('nh', 'nihonium')
            mass = 286.0d0
        case('fl', 'flerovium')
            mass = 289.0d0
        case('mc', 'moscovium')
            mass = 289.0d0
        case('lv', 'livermorium')
            mass = 293.0d0
        case('ts', 'tennessine')
            mass = 293.0d0
        case('og', 'oganesson')
            mass = 294.0d0
        case default
            mass = 0.0d0
        end select
    end function atom_mass

end module utils_module

~~~

## distance_module.f90
~~~Fortran

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
~~~

## mass_module.f90
~~~Fortran
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

~~~

## main.f90
~~~Fortran

program molecule_analyzer
    use utils_module
    use mass_module
    use distance_module
    use groups_module
    implicit none

    character(len=256) :: filename
    integer :: atom_ct, i, ios
    character(len=4), allocatable :: types(:)
    real(kind=8), allocatable :: x(:), y(:), z(:)
    real(kind=8) :: molar_mass
    type(dist_info) :: overall, nonH
    integer :: n_hydroxyl, n_carbonyl

    print *, 'Enter .xyz filename (ex: molecule.xyz):'
    read(*,'(A)') filename

    call read_xyz(trim(filename), atom_ct, types, x, y, z, ios)
    if (ios /= 0) then
        print *, 'Error reading file: ', trim(filename)
        stop 1
    end if

    molar_mass = compute_molar_mass(atom_ct, types)
    print *
    write(*,'(A,F10.4,A)') 'Molar mass (g/mol): ', molar_mass, ''

    call find_minmax_all(atom_ct, types, x, y, z, overall)
    write(*,'(A)') ''
    print *, 'Overall distances:'
    write(*,'(A,I6,A,A,2F12.5)') 'Min distance: atom ', overall%min_i, ', ', trim(overall%min_type_i), overall%min_dist
    write(*,'(A,I6,A,A,2F12.5)') 'Max distance: atom ', overall%max_i, ', ', trim(overall%max_type_i), overall%max_dist
    print *, 'Min pair: (', overall%min_i, ',', overall%min_j, ') types: ', trim(overall%min_type_i), '-', trim(overall%min_type_j)
    print *, 'Max pair: (', overall%max_i, ',', overall%max_j, ') types: ', trim(overall%max_type_i), '-', trim(overall%max_type_j)
    print *, 'Min distance (Å): ', overall%min_dist
    print *, 'Max distance (Å): ', overall%max_dist

    call find_minmax_nonH(atom_ct, types, x, y, z, nonH)
    if (nonH%count_pairs > 0) then
        write(*,'(A)') ''
        print *, 'Non-H distances:'
        print *, 'Min non-H pair: (', nonH%min_i, ',', nonH%min_j, ') types: ', trim(nonH%min_type_i), '-', trim(nonH%min_type_j)
        print *, 'Min non-H distance (Å): ', nonH%min_dist
        print *, 'Max non-H pair: (', nonH%max_i, ',', nonH%max_j, ') types: ', trim(nonH%max_type_i), '-', trim(nonH%max_type_j)
        print *, 'Max non-H distance (Å): ', nonH%max_dist
    else
        print *, 'No non-H atom pairs found (all atoms are H or insufficient non-H atoms).'
    end if

    n_hydroxyl = count_hydroxyls(atom_ct, types, x, y, z)
    n_carbonyl = count_carbonyls(atom_ct, types, x, y, z)

    write(*,'(A,I6)') 'Number of hydroxyl groups (O-H 0.94-1.05 A): ', n_hydroxyl
    write(*,'(A,I6)') 'Number of carbonyl groups (C=O 1.20-1.30 A): ', n_carbonyl

    deallocate(types, x, y, z)

end program molecule_analyzer

~~~

## Makefile
~~~make
FC = gfortran
FFLAGS = -O2 -std=f2003
OBJS = utils_module.o mass_module.o distance_module.o groups_module.o main.o
TARGET = molecule_analyzer

all: $(TARGET)

$(TARGET): $(OBJS)
	$(FC) $(FFLAGS) -o $(TARGET) $(OBJS)

utils_module.o: utils_module.f90
	$(FC) $(FFLAGS) -c utils_module.f90

mass_module.o: mass_module.f90 utils_module.f90
	$(FC) $(FFLAGS) -c mass_module.f90

distance_module.o: distance_module.f90 utils_module.f90
	$(FC) $(FFLAGS) -c distance_module.f90

groups_module.o: groups_module.f90 distance_module.f90 utils_module.f90
	$(FC) $(FFLAGS) -c groups_module.f90

main.o: main.f90 utils_module.f90 mass_module.f90 distance_module.f90 groups_module.f90
	$(FC) $(FFLAGS) -c main.f90

clean:
	rm -f *.o $(TARGET)
.PHONY: all clean

~~~