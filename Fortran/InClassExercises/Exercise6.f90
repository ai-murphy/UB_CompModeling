program genetic_inheritance
  implicit none
  integer, parameter :: n = 20
  integer :: i
  real :: crossover_point
  integer, dimension(n) :: father, mother, son1, son2

  ! Initialize random seed
  call random_seed()

  ! Set father and mother traits
  father = 1
  mother = 2

  ! Generate a random crossover point between 1 and n
  call random_number(crossover_point)
  ! random_number returns a real var between 0 & 1, set it back to integer
  crossover_point = int(crossover_point * n) + 1

  ! Create offspring using crossover
  do i = 1, n
     if (i <= crossover_point) then
        son1(i) = father(i)
        son2(i) = mother(i)
     else
        son1(i) = mother(i)
        son2(i) = father(i)
     end if
  end do

  ! Display results
  print *, "Crossover point:", crossover_point
  !print *, "Father: ", father
  !print *, "Mother: ", mother
  !print *, "Son 1:  ", son1
  !print *, "Son 2:  ", son2
  !better output (with less space)
  write(*,'("Father: ",20(I1,1X))') father
  write(*,'("Mother: ",20(I1,1X))') mother
  write(*,'("Son 1:  ",20(I1,1X))') son1
  write(*,'("Son 2:  ",20(I1,1X))') son2

end program genetic_inheritance


!!!OUTPUT!!!
!------------
! Crossover point:   7.00000000    
!Father: 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
!Mother: 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
!Son 1:  1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2
!Son 2:  2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1 1 1 1
