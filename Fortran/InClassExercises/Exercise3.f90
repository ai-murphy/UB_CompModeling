program Exercise3
implicit none

    !declare vars
    integer, dimension(2,10) :: matrix
    !real, dimension(10) :: points = [p1,p2,p3,p4,p5,p6,p7,p8,p9,p10]
    integer :: i,j,minp,maxp
    real :: randx,randy,dx,dy,distance,maxd,mind

    !generate random points and store them in the matrix
    call random_seed()
    do i = 1, 10
        call random_number(randx)
        call random_number(randy)
        print *, "Point ", i, ": (",int(randx*100),",",int(randy*100),")"
        matrix(1, i) = int(randx*100)
        matrix(2, i) = int(randy*100)
    end do

    print *, "------------------------------"

    !iterate over the matrix, stating where each point is using
    !inner loop to calculate max/min distance from any given point
    do i = 1, 10
        mind = 10e4
        maxd = 0
        minp = 0
        maxp = 0
        !print *, "Point ", i, ": (",matrix(1,i),",",matrix(2,i),")"
        calc_dist: do j = 1, 10
            !skip over calculating distances from the same point
            if (i == j) then 
                cycle calc_dist 
            end if
            
            dx = matrix(1,i)-matrix(1,j)
            dy = matrix(2,i)-matrix(2,j)
            distance = sqrt(dx**2 + dy**2)
            if (distance < mind) then
                mind = distance
                minp = j
            end if
            if (distance > maxd) then
                maxd = distance
                maxp = j
            end if
        end do calc_dist
        !print *, "Point ", i, ": (",matrix(1,i),",",matrix(2,i),") is farthest away from point ", &
        !         maxp, "at a distance of ", maxd, "and closest to ", minp, " at a distance of ", mind
        write (*, '("Point ", I2, " (",I3,",",I3,") is farthest from point #",I2, &
                  " at a distance of ",F6.2," and closest to #",I2, " at a distance of ",F6.2)') &
                 i,matrix(1,i),matrix(2,i),maxp,maxd,minp,mind
    end do


end program Exercise3


!!!OUTPUT!!!
!------------
! Point            1 : (           6 ,          13 )
! Point            2 : (          73 ,          48 )
! Point            3 : (          20 ,          25 )
! Point            4 : (          25 ,          13 )
! Point            5 : (           2 ,          74 )
! Point            6 : (          20 ,          59 )
! Point            7 : (          71 ,          37 )
! Point            8 : (          69 ,          60 )
! Point            9 : (          21 ,          24 )
! Point           10 : (          13 ,          57 )
! ------------------------------
!Point  1 (  6, 13) is farthest from point # 8 at a distance of  78.60 and closest to # 3 at a distance of  18.44
!Point  2 ( 73, 48) is farthest from point # 5 at a distance of  75.61 and closest to # 7 at a distance of  11.18
!Point  3 ( 20, 25) is farthest from point # 8 at a distance of  60.22 and closest to # 9 at a distance of   1.41
!Point  4 ( 25, 13) is farthest from point # 5 at a distance of  65.19 and closest to # 9 at a distance of  11.70
!Point  5 (  2, 74) is farthest from point # 7 at a distance of  78.29 and closest to #10 at a distance of  20.25
!Point  6 ( 20, 59) is farthest from point # 7 at a distance of  55.54 and closest to #10 at a distance of   7.28
!Point  7 ( 71, 37) is farthest from point # 5 at a distance of  78.29 and closest to # 2 at a distance of  11.18
!Point  8 ( 69, 60) is farthest from point # 1 at a distance of  78.60 and closest to # 2 at a distance of  12.65
!Point  9 ( 21, 24) is farthest from point # 8 at a distance of  60.00 and closest to # 3 at a distance of   1.41
!Point 10 ( 13, 57) is farthest from point # 7 at a distance of  61.35 and closest to # 6 at a distance of   7.28