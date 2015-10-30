framespast = 0

function graphicsDraw()


	-- love.graphics.rectangle("fill",0,0,gridsize*scale,gridsize*scale)
	framespast = framespast + 1

	-- love.graphics.draw(canvas)
	local miniscale = 3

	for y = 1, gridsize/3 do
	    for x = 1, gridsize/3 do
	        local current = grid[x*3][y*3]
	        if current.kind == 1 then
	        	love.graphics.setColor(0,0,0)
	        	love.graphics.rectangle("fill",x,y,1,1)
	        else
	        	if current.biome == 1 then
	        		love.graphics.setColor(255,0,255)
		        	love.graphics.rectangle("fill",x,y,1,1)
		        end
		        if current.biome == 2 then
	        		love.graphics.setColor(0,0,255)
		        	love.graphics.rectangle("fill",x,y,1,1)
		        end
		        if current.biome == 3 then
	        		love.graphics.setColor(0,255,0)
		        	love.graphics.rectangle("fill",x,y,1,1)
		        end
		        if current.biome == 4 then
	        		love.graphics.setColor(0,255,255)
		        	love.graphics.rectangle("fill",x,y,1,1)
		        end
		        if current.biome == 5 then
	        		love.graphics.setColor(255,255,0)
		        	love.graphics.rectangle("fill",x,y,1,1)
		        end
		        if current.biome == 6 then
	        		love.graphics.setColor(255,255,255)
		        	love.graphics.rectangle("fill",x,y,1,1)
		        end
		        if current.biome == 7 then
	        		love.graphics.setColor(100,100,100)
		        	love.graphics.rectangle("fill",x,y,1,1)
		        end
		    end
	    end
	end

	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill",player.x/3,player.y/3,10,10)

end

function graphicsInit()
	spriteCache.dirt = love.graphics.newImage("images/dirt.png")
	spriteCache.wood = love.graphics.newImage("images/wood.png")
	spriteCache.woodbg = love.graphics.newImage("images/woodbg.png")

	local maxX = math.ceil(love.graphics.getWidth()  / spriteCache.dirt:getWidth())  + 2
	local maxY = math.ceil(love.graphics.getHeight() / spriteCache.dirt:getHeight()) + 2
	local size = maxX * maxY
	dirtBatch = love.graphics.newSpriteBatch(spriteCache.dirt, size)

	love.graphics.setDefaultFilter("nearest","nearest")
end



function graphicsDrawPOV()



	scale = 16
	framespast = framespast + 1
	local updatelights = false
	-- if framespast % 5 == 0 then
		updatelights = true
	-- end

	local px = math.floor(player.x)
	local py = math.floor(player.y)
	if updatelights then
		for y = py - 13, py + 13 do
		    for x = px - 13, px + 13 do
		    	grid[x][y].playerlight = 0
		    	-- print(grid[x][y].light)
		    end
		end
	end

	if updatelights then
		drawLights(player.x,player.y)
	end
	-- for y = 1, gridsize do
	--     for x = 1, gridsize do
	--     	if (x + 1) * scale > camera.x and (y + 1) * scale > camera.y and (x - 1) * scale < camera.x + winW and (y - 1) * scale < camera.y + winH then
	--     		if grid[x][y].kind == 4 then
	--     			drawLights(x,y)
	--     		end
	--     	end
	--     end
	-- end

	dirtBatch:clear()

	local startx = math.floor(camera.x / scale) - 1
	local starty = math.floor(camera.y / scale) - 1
	local endx = math.floor((camera.x + winW) / scale) + 1
	local endy = math.floor((camera.y + winH) / scale) + 1

	for y = starty, endy do
	    for x = startx, endx do
	        local current = grid[x][y]
	        if current.kind == 0 or current.kind == 2 or current.kind == 3 then
	        	if y > 100 then
		        	love.graphics.setColor(current.red,current.green,current.blue)
		        	drawBlock(x,y)
		        else
		        	love.graphics.setColor(current.red,current.green,current.blue)
		        	drawBlock(x,y)
		        end
	        end
	        if current.kind == 1 then
	        	dirtBatch:add(x*scale - camera.x,y*scale - camera.y,0,2,2)
	        end
	        if current.kind == 2 then
	        	love.graphics.setColor(64,140,255,current.waterDensity)
	        	drawBlock(x,y)
	        end
	        if current.kind == 3 then
	        	love.graphics.setColor(64,140,255,current.waterDensity)
	        	drawBlock(x,y)
	        end
	        if current.kind == 4 then
	        	love.graphics.setColor(100,100,100)
	        	drawBlock(x,y)
	        end
	        if current.kind == 5 then
	        	love.graphics.setColor(100,255,100)
	        	drawBlock(x,y)
	        end
	        if current.kind == 6 then
	        	love.graphics.setColor(255,255,255)
	        	drawBlock(x,y)
	        end
	        if current.kind == 7 then
	        	love.graphics.setColor(255,0,0)
	        	drawBlock(x,y)
	        end
	        if current.kind == 10 then
	        	love.graphics.setColor(200,100,100)
	        	drawBlock(x,y)
	        end
	        if current.kind == 20 then
	        	love.graphics.setColor(100,20,100)
	        	drawBlock(x,y)
	        end
	        if current.kind == 21 then
	        	love.graphics.setColor(100,100,20)
	        	drawBlock(x,y)
	        end
	        if current.kind == 22 then
	        	love.graphics.setColor(20,100,100)
	        	drawBlock(x,y)
	        end
	        if current.kind == 30 then
	        	love.graphics.setColor(current.red,current.green,current.blue)
	        	drawImage(spriteCache.wood,x,y)
	        end
	        if current.kind == 40 then
	        	love.graphics.setColor(current.red,current.green,current.blue)
	        	drawImage(spriteCache.woodbg,x,y)
	        end
		end
	end
	love.graphics.setColor(255,255,255)
	love.graphics.draw(dirtBatch)
	-- shadows
	for y = starty, endy do
	    for x = startx, endx do
	        local current = grid[x][y]
			if current.light > current.playerlight then
		        love.graphics.setColor(0,0,0,255 - current.light)
		    else
		    	love.graphics.setColor(0,0,0,255 - current.playerlight)
		    end
	        drawBlock(x,y)

	        if caveBlockAt(x,y) then
		        local thick = 2
	        	if y > 1 then
	        		if not caveBlockAt(x,y-1) then
	        			love.graphics.setColor(0,0,0)
	        			love.graphics.rectangle("fill",x*scale - camera.x,y*scale - camera.y,scale,thick)
	        		end
	        	end
	        	if x > 1 then
	        		if not caveBlockAt(x-1,y) then
	        			love.graphics.setColor(0,0,0)
	        			love.graphics.rectangle("fill",x*scale - camera.x,y*scale - camera.y,thick,scale)
	        		end
	        	end
	        	if x < gridsize then
	        		if not caveBlockAt(x+1,y) then
	        			love.graphics.setColor(0,0,0)
	        			love.graphics.rectangle("fill",(x+1)*scale - camera.x - thick,y*scale - camera.y,thick,scale)
	        		end
	        	end
	        	if y < gridsize then
	        		if not caveBlockAt(x,y+1) then
	        			love.graphics.setColor(0,0,0)
	        			love.graphics.rectangle("fill",x*scale - camera.x,(y+1)*scale - camera.y - thick,scale,thick)
	        		end
	        	end
	        end
		end
	end

	for i = 1, #items do
		local item = items[i]
		-- if item.x < startx or item.y < starty or item.x > endx or item.y > endy then
		-- 	table.remove(item,i)
		-- 	break
		-- end
		-- if item.kind == 1 then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(spriteCache.dirt,(item.x)*scale - camera.x,(item.y)*scale - camera.y,0)
		-- end

	end

	for i, bot in ipairs(npc) do
		love.graphics.setColor(255,0,0)
    	love.graphics.rectangle("fill",bot.x*scale - camera.x,bot.y*scale - camera.y,scale,scale)
	end

	love.graphics.setColor(0,255,255)
    drawBlock(player.x,player.y)
    love.graphics.setColor(255,0,255)
    love.graphics.rectangle("fill",player.x*scale - camera.x,player.y*scale - camera.y,scale/2,scale/2)
	love.graphics.setColor(255,255,255)
	love.graphics.print("" .. framespast,100,300)

	-- dirt
	love.graphics.draw(spriteCache.dirt,10,12,0,2,2)
	love.graphics.print("" .. player.inventory[1],34,10)

	-- mono
	love.graphics.draw(spriteCache.dirt,10,42,0,2,2)
	love.graphics.print("" .. player.inventory[20],34,40)

	-- kuro
	love.graphics.draw(spriteCache.dirt,10,72,0,2,2)
	love.graphics.print("" .. player.inventory[21],34,70)

	-- tabe
	love.graphics.draw(spriteCache.dirt,10,102,0,2,2)
	love.graphics.print("" .. player.inventory[22],34,100)

	-- bio
	love.graphics.draw(spriteCache.dirt,10,132,0,2,2)
	love.graphics.print("" .. player.inventory[5],34,130)

	-- graphicsDraw()

	loveframes.draw()

end

function drawLights(baseX,baseY)
	local px = math.floor(player.x)
	local py = math.floor(player.y)
	for i = 1,72 do
		local angle = i*5
		local currentX = baseX
		local currentY = baseY
		local light = 255
		for c = 1,20 do
			if c > 15 then
				light = light - 55
			end
			-- light = light - 17
			if light < baselight then
				light = baselight
			end
			if currentX > 2 and currentX < gridsize - 2 and currentY > 2 and currentY < gridsize - 2 then
				currentX = currentX + math.cos((math.pi / 180) * angle)/2
				currentY = currentY + math.sin((math.pi / 180) * angle)/2
				grid[math.floor(currentX)][math.floor(currentY)].playerlight = light
				if grid[math.floor(currentX)+1][math.floor(currentY)].playerlight == 0 then
					grid[math.floor(currentX)+1][math.floor(currentY)].playerlight = light/2
				end
				if grid[math.floor(currentX)-1][math.floor(currentY)].playerlight == 0 then
					grid[math.floor(currentX)-1][math.floor(currentY)].playerlight = light/2
				end
				if grid[math.floor(currentX)][math.floor(currentY)+1].playerlight == 0 then
					grid[math.floor(currentX)][math.floor(currentY)+1].playerlight = light/2
				end
				if grid[math.floor(currentX)][math.floor(currentY)+1].playerlight == 0 then
					grid[math.floor(currentX)][math.floor(currentY)+1].playerlight = light/2
				end
				if pointCollide(px,py,currentX,currentY,0,0) then
					break
				end
			else
				break
			end
		end
		-- love.graphics.setColor(255,255,255)
		-- love.graphics.line(baseX*scale - camera.x,baseY*scale - camera.y,currentX*scale - camera.x,currentY*scale - camera.y)
	end
end

function pointCollide(px,py,sx,sy,offsetx,offsety)
	for y = py - 13, py + 13 do
	    for x = px - 13, px + 13 do
	    	if y > 1 and y < gridsize -1 and x > 1 and x < gridsize - 1 then
		    	if blockAt(x,y) then
			    	if CheckCollision(sx + offsetx - 0.05,sy + offsety - 0.05,0.1,0.1,x,y,1,1) then
			    		return true
			    	end
			    end
			else
				return true
			end
	    end
	end
	return false
end


function drawBlock(x,y)
	love.graphics.rectangle("fill",x*scale - camera.x,y*scale - camera.y,scale,scale)
end

function drawImage(image,x,y)
	love.graphics.draw(image,x*scale - camera.x,y*scale - camera.y,0,2,2)
end
