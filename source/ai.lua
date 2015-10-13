function aiTick(bot)
	bot.hunger = bot.hunger - 1

	if bot.hunger < 10 then

	end


	if blockAt(bot.x,bot.y + 1) then
		bot.y = bot.y + 1
	elseif blockAt(bot.x + 1, bot.y) then
		bot.x = bot.x + 1
	end

end

function aiInit()
	local bot = {
		x = 0,
		y = 0,
		hunger = 0,
	}
	return bot
end

function blockAt(x,y)
	if grid[x][y].kind == 0 or grid[x][y].kind == 3 or grid[x][y].kind == 3 then
		return true
	else
		return false
	end
end