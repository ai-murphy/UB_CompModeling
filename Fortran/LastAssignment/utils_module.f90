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
