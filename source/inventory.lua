-- 0 = nothing
-- 1 = dirt

function inventoryInit()
	player.inventory = {}
	player.inventory[1] = 10
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
			player.inventory[item.kind] = player.inventory[item.kind] + 1
			return true
		end
	end
	return false
end