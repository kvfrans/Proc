function buildingUpdate(start)
	local mouseBlockX = math.floor((love.mouse.getX()+camera.x)/scale)
	local mouseBlockY = math.floor((love.mouse.getY()+camera.y)/scale)
	-- valuetrain.mousex = mouseBlockX
	-- valuetrain.mousey = mouseBlockY

	if love.mouse.isDown("l") and buildingRange(mouseBlockX,mouseBlockY) then

		local changed = false

		if breakBlock(mouseBlockX,mouseBlockY) then changed = true end
			if breakBlock(mouseBlockX+1,mouseBlockY+1) then changed = true end
				if breakBlock(mouseBlockX+1,mouseBlockY-1) then changed = true end
					if breakBlock(mouseBlockX+1,mouseBlockY) then changed = true end
						if breakBlock(mouseBlockX-1,mouseBlockY+1) then changed = true end
							if breakBlock(mouseBlockX-1,mouseBlockY-1) then changed = true end
								if breakBlock(mouseBlockX-1,mouseBlockY) then changed = true end
									if breakBlock(mouseBlockX,mouseBlockY+1) then changed = true end
										if breakBlock(mouseBlockX,mouseBlockY-1) then changed = true end
		if changed then
			buildUpdate()
		end

	end

	-- if love.mouse.isDown("r") and start and buildingRange(mouseBlockX,mouseBlockY) then
	-- 	interact(mouseBlockX,mouseBlockY)
	-- end
end

function breakBlock(x,y)
	if grid[x][y].kind ~= 0 and grid[x][y].kind ~= 3 and grid[x][y].kind ~= 2 then
		local item = itemInit()
		item.kind = grid[x][y].kind
		grid[x][y].kind = 0
		item.x = x + 0.25
		item.y = y + 0.25
		table.insert(items,item)
		return true
	else
		return false
	end
end


function buildingRange(x,y)
	local px = math.floor(player.x)
	local py = math.floor(player.y)

	local dist = helperDistance(px,py,x,y)
	if dist < 10 then
		return true
	end
	return false
end

function helperDistance(x1,y1,x2,y2)
	local xs = x2 - x1;
	xs = xs * xs;
	local ys = y2 - y1;
	ys = ys * ys;
	return math.sqrt( xs + ys );
end


function buildUpdate()
	local px = math.floor(player.x)
	local py = math.floor(player.y)
	for y = 1,gridsize do
		for x = 1,gridsize do
			if (x + 1) * scale > camera.x and (y + 1) * scale > camera.y and (x - 1) * scale < camera.x + winW and (y - 1) * scale < camera.y + winH then
				grid[x][y].light = baselight
			end
		end
	end
	for y = 1,gridsize do
		for x = 1,gridsize do
			if (x + 1) * scale > camera.x and (y + 1) * scale > camera.y and (x - 1) * scale < camera.x + winW and (y - 1) * scale < camera.y + winH then
				if grid[x][y].kind == 4 then
					helperLights(grid,x,y)
				end
			end
		end
	end
end