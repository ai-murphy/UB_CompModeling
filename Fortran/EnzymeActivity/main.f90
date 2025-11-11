program enzymatic_activity
    use expr1_module
    use expr2_module
    implicit none
    
    ! Variables for first dataset
    real(kind=8) :: k2_1, E0_1, KM_1, I_1, KI_1
    ! Variables for second dataset
    real(kind=8) :: k2_2, E0_2, KM_2, I_2, KI_2
    
    ! Loop and calculation variables
    !integer :: j
    !real(kind=8) :: S, v1, v2
    
    ! Initialize parameters for first table
    k2_1 = 0.002d0
    E0_1 = 0.04d0
    KM_1 = 0.005d0
    I_1 = 0.1d0
    KI_1 = 0.002d0
    
    ! Initialize parameters for second table
    k2_2 = 0.0005d0
    E0_2 = 0.06d0
    KM_2 = 0.01d0
    I_2 = 0.03d0
    KI_2 = 0.03d0
    
    ! Generate first table
    call generate_table(1, k2_1, E0_1, KM_1, I_1, KI_1)
    
    ! Generate second table
    call generate_table(2, k2_2, E0_2, KM_2, I_2, KI_2)
    
contains
    subroutine generate_table(table_num, k2, E0, KM, I, KI)
        integer, intent(in) :: table_num
        real(kind=8), intent(in) :: k2, E0, KM, I, KI
        integer :: j
        real(kind=8) :: S, v1, v2
        character(len=20) :: filename
        
        ! Determine output filename
        write(filename, '(A,I1,A)') 'table', table_num, '.out'
        
        ! Open output file
        open(unit=10, file=trim(filename), status='replace', action='write')
        
        ! Print header to screen
        print *, '====== Table ', table_num, ' ======'
        print '(3(A15))', '[S] (M)', 'v1', 'v2'
        print '(50A)', ('-', j=1,50)
        
        ! Print header to file
        write(10, '(3(A15))') '[S] (M)', 'v1', 'v2'
        write(10, '(50A)') ('-', j=1,50)
        
        ! Loop from [S] = 0.01 to 0.1 in steps of 0.01
        do j = 1, 10
            S = 0.01d0 * j
            v1 = calc_v1(k2, E0, S, KM)
            v2 = calc_v2(k2, E0, S, KM, I, KI)
            
            ! Print to screen with proper formatting
            print '(3(F15.8))', S, v1, v2
            
            ! Print to file with proper formatting
            write(10, '(3(F15.8))') S, v1, v2
        end do
        
        ! Print footer to screen
        print '(50A)', ('-', j=1,50)
        print *
        
        ! Print footer to file
        write(10, '(50A)') ('-', j=1,50)
        
        close(unit=10)
    end subroutine generate_table
end program enzymatic_activity