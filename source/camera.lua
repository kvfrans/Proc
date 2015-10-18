function cameraUpdate(dt)
	local cameraspeed = 300*dt
	local border = 100
	-- if love.mouse.getX() < border then
	-- 	camera.x = camera.x - cameraspeed
	-- end
	-- if love.mouse.getY() < border then
	-- 	camera.y = camera.y - cameraspeed
	-- end
	-- if love.mouse.getY() > winH - border then
	-- 	camera.y = camera.y + cameraspeed
	-- end
	-- if love.mouse.getX() > winW - border then
	-- 	camera.x = camera.x + cameraspeed
	-- end

	camera.x = camera.x - (camera.x - ((player.x*scale) - winW / 2)) * dt * 5
	camera.y = camera.y - (camera.y - ((player.y*scale) - winH / 2)) * dt * 5
end