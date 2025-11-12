program Exercise4
implicit none

    !declare vars
    real, dimension(2,7) :: matrix
    real, dimension(2) :: centroid
    integer :: i,j,closest
    real :: x,y,dx,dy,dist,mindist,minx,miny

    !generate random points and fill the matrix
    call random_seed()
    do i = 1,7
        call random_number(x)
        call random_number(y)
        print *, "Point ", i, ": (",(x-0.5)*20,",",(y-0.5)*20,")"
        matrix(1,i) = (x-0.5)*20
        matrix(2,i) = (y-0.5)*20
    end do
    !print *, matrix
    
    !find the centroid (reusing x & y values)
    x = sum(matrix(1,:))/7
    y = sum(matrix(2,:))/7
    centroid(1) = x
    centroid(2) = y
    print *, "Centroid", centroid

    !calculate distance b/w centroid & points in the matrix, saving the closest  
    !start mindist above the farthest possible distance
    mindist = 15.0
    do i = 1, 7
        dx = abs(matrix(1,i) - centroid(1))
        dy = abs(matrix(2,i) - centroid(2))
        dist = sqrt(dx**2 + dy**2)
        if (dist < mindist) then
            mindist = dist
            closest = i
        end if
    end do
    
    write (*, '("Point ", I2, " (",F8.5,",",F8.5,") is closest to the centroid at (",F8.5",",F8.5, &
                ") at a distance of ",F8.5)') &
                closest,matrix(1,closest),matrix(2,closest),centroid(1),centroid(2),mindist


end program 


!!!OUTPUT!!!
!-------------
! Point            1 : (   9.21225071     ,   6.06712914     )
! Point            2 : (   2.59335995     ,  -8.97675896     )
! Point            3 : (  -9.50598621     , -0.569437742     )
! Point            4 : (   9.68006611     ,   9.20207024     )
! Point            5 : (   8.35799408     ,   9.33956051     )
! Point            6 : (  -1.97941422     ,   4.77235889     )
! Point            7 : (  0.720711946     ,  -9.49118710     )
! Centroid   2.72556901       1.47767651
!Point  6 (-1.97941, 4.77236) is closest to the centroid at ( 2.72557, 1.47768) at a distance of  5.74385