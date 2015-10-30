-- 0 = nothing
-- 1 = dirt

-- 5 - bio

-- 20 = mono
-- 21 = kuro
-- 22 = tabe

function inventoryInit()
	player.inventory = {}
	player.inventory[1] = 10
	player.inventory[5] = 0
	player.inventory[20] = 0
	player.inventory[21] = 0
	player.inventory[22] = 0
end

function itemInit()
	local item = {
		kind =  1,
		x = 0,
		y = 0
	}
	return item
end

function itemUpdate(item,dt)
	local speed = 2
	local dist = math.sqrt(math.pow(item.x - player.x,2) + math.pow(item.y - player.y,2))
	for i=1,3 do
		if dist < 4 then
			if math.abs(item.x - player.x) > 0.2 then
				if item.x < player.x then
					item.x = item.x + speed*dt
				else
					item.x = item.x - speed*dt
				end
			end
			if math.abs(item.y - player.y) > 0.2 then
				if item.y < player.y then
					item.y = item.y + speed*dt
				else
					item.y = item.y - speed*dt
				end
			end
		end
		if dist < 1 then
			if player.inventory[item.kind] then
				player.inventory[item.kind] = player.inventory[item.kind] + 1
			end
			return true
		end
	end

	if dist > 4 then
		if grid[math.floor(item.x)][math.floor(item.y+0.25)].kind == 0 then
			item.y = item.y + 2*dt
		end
	end
	return false
end