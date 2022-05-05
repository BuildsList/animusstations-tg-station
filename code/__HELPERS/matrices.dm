/matrix/proc/TurnTo(old_angle, new_angle)
	. = new_angle - old_angle
	Turn(.) //BYOND handles cases such as -270, 360, 540 etc. DOES NOT HANDLE 180 TURNS WELL, THEY TWEEN AND LOOK LIKE SHIT


/atom/proc/SpinAnimation(speed = 10, loops = -1)
	var/matrix/m120 = matrix(transform)
	m120.Turn(120)
	var/matrix/m240 = matrix(transform)
	m240.Turn(240)
	var/matrix/m360 = matrix(transform)
	speed /= 3      //Gives us 3 equal time segments for our three turns.
	                //Why not one turn? Because byond will see that the start and finish are the same place and do nothing
	                //Why not two turns? Because byond will do a flip instead of a turn
	animate(src, transform = m120, time = speed, loops)
	animate(transform = m240, time = speed)
	animate(transform = m360, time = speed)


/atom/proc/GrowAndFade()
    // expand (scale by 2x2) and fade out over 1/2s
    animate(src, transform = matrix()*2, alpha = 0, time = 5)


/atom/proc/SexAct(dir = 4,howLong = 10)

	var/matrix/M = matrix()
	if(dir == 4)
		M.Turn(rand(30,40))
	else if(dir == 8)
		M.Turn(rand(-30,-40))
	else
		return

	animate(src, transform = M, time = howLong, loop = rand(5,10), easing = SINE_EASING)
	animate(transform = null, time = howLong, easing = SINE_EASING)