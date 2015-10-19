function buildingUpdate(dt)
	local mouseBlockX = math.floor((love.mouse.getX+camera.x)*scale)
	local mouseBlockY = math.floor((love.mouse.getY+camera.y)*scale)

	if love.mouse.isDown("l") then
		grid[mouseBlockX][mouseBlockY].kind = 0
	end
end