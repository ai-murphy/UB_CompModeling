program average_column
  implicit none
  integer :: n, i
  real, allocatable :: col1(:), col2(:)
  real :: avg1, avg2
  character(len=100) :: filename
  integer :: ios        !used to check for file errors gracefully
  filename = "data.dat"

  ! Open the file, using unit #10 (arbitrary, but no overlap)
  ! status='old' means that file must already exist. other possible values:
  !        'new','replace','scratch' (deleted @ close), 'unknown' (interpreter decides)
  ! action can be 'read', 'write', or 'readwrite'
  open(unit=10, file=filename, status='old', action='read', iostat=ios)
  if (ios /= 0) then
     print *, "Error opening file:", filename
     stop
  end if

  ! Read number of points
  read(10, *) n
  allocate(col1(n), col2(n))

  ! Read the two columns
  do i = 1, n
     read(10, *) col1(i), col2(i)
  end do
  close(10)

  ! Compute averages
  avg1 = sum(col1) / n
  avg2 = sum(col2) / n

  ! Display results
  print *, "Number of points:", n
  print *, "Average of column 1:", avg1
  print *, "Average of column 2:", avg2

end program average_column

!!!OUTPUT!!!
!-------------
! Number of points:           5
! Average of column 1:   3.00000000    
! Average of column 2:   6.00000000  