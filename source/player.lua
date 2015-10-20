function playerInit(xa,ya)
	player = {
		x = xa,
		y = ya,
		speed = 8,
		sidebound = 0.2,
		gravity = 30,
		yVel = 0,
		jump = 15,
	}
end

function playerMove(dt)

	if not playerCollidingDown() then
		player.yVel = player.yVel - player.gravity*dt
	else
		if player.yVel < 0 then
			player.yVel = 0
		end
	end

	if keyPressed("up") then
		if not playerCollidingUp(true) then
			player.yVel = player.jump
		end
	end
	if keyDown("down") then
		-- if not playerCollidingDown() then
		-- 	player.y = player.y + player.speed*dt
		-- end
	end
	if keyDown("left") then
		local fallLeft = player.speed*dt
		local go = false
		while fallLeft > 0.1 do
			if not playerCollidingLeft() then
				go = true
				player.x = player.x - 0.1
				fallLeft = fallLeft - 0.1
			else
				go = false
				break
			end
		end
		if go then
			player.x = player.x - fallLeft
		end
	end
	if keyDown("right") then
		local fallLeft = player.speed*dt
		local go = false
		while fallLeft > 0.1 do
			if not playerCollidingRight() then
				go = true
				player.x = player.x + 0.1
				fallLeft = fallLeft - 0.1
			else
				go = false
				break
			end
		end
		if go then
			player.x = player.x + fallLeft
		end
	end

	-- if playerCollidingLeft() then
	-- 	player.x = player.x + 0.01
	-- end

	-- if playerCollidingRight() then
	-- 	player.x = player.x - 0.01
	-- end

	-- if player.yVel < -10 then
	-- 	player.yVel = -10
	-- end

	if player.yVel < 0 then
		local fallLeft = player.yVel*dt
		local go = true
		while fallLeft < -0.1 do
			if not playerCollidingDown() then
				player.y = player.y + 0.1
				fallLeft = fallLeft + 0.1
			else
				go = false
				break
			end
		end
		if go then
			player.y = player.y - fallLeft
		end
		-- if not playerCollidingDown() then
		-- 	player.y = player.y - player.yVel*dt
		-- end
	end



	if player.yVel > 0 then
		local fallLeft = player.yVel*dt
		local go = true
		while fallLeft > 0.1 do
			if not playerCollidingUp() then
				player.y = player.y - 0.1
				fallLeft = fallLeft - 0.1
			else
				go = false
				player.yVel = 0
				break
			end
		end
		if go then
			player.y = player.y - fallLeft
		end
	end
end

function playerCollidingDown(small)
	local px = math.floor(player.x)
	local py = math.floor(player.y)
	for y = py - 2, py + 2 do
	    for x = px - 2, px + 2 do
	    	if blockAt(x,y) then
	    		if small then
		    		if CheckCollision(player.x + player.sidebound,player.y + (1 - player.sidebound),player.sidebound,player.sidebound,x,y,1,1) then
		    			return true
		    		end
		    	else
		    		if CheckCollision(player.x,player.y + (1 - player.sidebound),1,player.sidebound,x,y,1,1) then
		    			return true
		    		end
	    		end
	    	end
	    end
	end
	return false
end

function playerCollidingLeft()
	local px = math.floor(player.x)
	local py = math.floor(player.y)
	for y = py - 2, py + 2 do
	    for x = px - 2, px + 2 do
	    	if blockAt(x,y) then
	    		if CheckCollision(player.x - 0.2,player.y + player.sidebound,player.sidebound,player.sidebound,x,y,1,1) then
	    			return true
	    		end
	    	end
	    end
	end
	return false
end

function playerCollidingRight()
	local px = math.floor(player.x)
	local py = math.floor(player.y)
	for y = py - 2, py + 2 do
	    for x = px - 2, px + 2 do
	    	if blockAt(x,y) then
	    		if CheckCollision(player.x + (1 - player.sidebound) + 0.2,player.y + player.sidebound,player.sidebound,player.sidebound,x,y,1,1) then
	    			return true
	    		end
	    	end
	    end
	end
	return false
end

function playerCollidingUp(small)
	local px = math.floor(player.x)
	local py = math.floor(player.y)
	for y = py - 2, py + 2 do
	    for x = px - 2, px + 2 do
	    	if blockAt(x,y) then
	    		if small then
		    		if CheckCollision(player.x + player.sidebound,player.y,player.sidebound,player.sidebound,x,y,1,1) then
		    			return true
		    		end
		    	else
		    		if CheckCollision(player.x,player.y,1,player.sidebound,x,y,1,1) then
		    			return true
		    		end
		    	end
	    	end
	    end
	end
	return false
end


function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end