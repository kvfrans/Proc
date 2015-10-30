function aiTick(bot)
	bot.hunger = bot.hunger - 1

	if bot.hunger < 10 then
	end

	bot.y = bot.y - bot.velocity
	if bot.velocity > 0 then
		bot.velocity = bot.velocity - 1
	end

	local falling = false
	if not blockAt(bot.x,bot.y + 1) then
		bot.y = bot.y + 1
		falling = true
	end

	-- jump
	if bot.target.y < bot.y then
		if blockAt(bot.x,bot.y + 1) then
			bot.velocity = 3
		end
	end

	-- moving
	if not falling then
		if bot.target.x > bot.x then
			if not blockAt(bot.x + 1, bot.y) then
				bot.x = bot.x + 1
			else
				bot.target.x = 0
			end
		elseif bot.target.x < bot.x then
			if not blockAt(bot.x - 1, bot.y) then
				bot.x = bot.x - 1
			else
				bot.target.x = 200
			end
		end
	end

end

function aiInit()
	local bot = {
		x = 0,
		y = 0,
		hunger = 0,
		velocity = 0,
	}
	bot.target = {
		x = 0,
		y = 0,
	}
	return bot
end

function blockAt(x,y)
	if grid[x][y].kind == 0 or grid[x][y].kind == 3 or grid[x][y].kind == 2 or grid[x][y].kind == 4 then
		return false
	else
		return true
	end
end

function caveBlockAt(x,y)
	if grid[x][y].kind == 1 or grid[x][y].kind == 20 or grid[x][y].kind == 21 or grid[x][y].kind == 22 or grid[x][y].kind == 23 or grid[x][y].kind == 4 or grid[x][y].kind == 30 then
		return true
	else
		return false
	end
end