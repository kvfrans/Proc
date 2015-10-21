function buildingUpdate(dt)
	local mouseBlockX = math.floor((love.mouse.getX()+camera.x)/scale)
	local mouseBlockY = math.floor((love.mouse.getY()+camera.y)/scale)
	valuetrain.mousex = mouseBlockX
	valuetrain.mousey = mouseBlockY

	if love.mouse.isDown("l") and buildingRange(mouseBlockX,mouseBlockY) then
		grid[mouseBlockX][mouseBlockY].kind = 0
	end

	if love.mouse.isDown("r") and buildingRange(mouseBlockX,mouseBlockY) then
		interact(mouseBlockX,mouseBlockY)
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