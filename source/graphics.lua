framespast = 0

function graphicsDraw()


	-- love.graphics.rectangle("fill",0,0,gridsize*scale,gridsize*scale)
	framespast = framespast + 1

	love.graphics.draw(canvas)

	for y = 1, gridsize do
	    for x = 1, gridsize do
	        local current = grid[x][y]
	        if current.kind == 2 then
	        	love.graphics.setColor(117,74,25)
	        	drawBlock(x,y)
	        	love.graphics.setColor(64,140,255,current.waterDensity)
	        	drawBlock(x,y)
	        end
	        if current.kind == 3 then
	        	love.graphics.setColor(117,74,25)
	        	drawBlock(x,y)
	        	love.graphics.setColor(64,140,255,current.waterDensity)
	        	drawBlock(x,y)
	        end
	        if current.kind == 7 then
	        	love.graphics.setColor(255,0,0)
	        	drawBlock(x,y)
	        end
	    end
	end

	love.graphics.setColor(255,255,255)
	love.graphics.draw(shadowcanvas)

	love.graphics.setColor(255,255,255,20)
	love.graphics.draw(biomecanvas)



	for i, bot in ipairs(npc) do
		love.graphics.setColor(255,0,0)
    	love.graphics.rectangle("fill",bot.x*scale,bot.y*scale,scale,scale)
	end

	love.graphics.setColor(255,255,255)
	love.graphics.print("" .. framespast,100,300)
end

function graphicsInit()
	canvas = love.graphics.newCanvas(800, 600)
	love.graphics.setCanvas(canvas)
		canvas:clear()
		love.graphics.setBlendMode('alpha')
		for y = 1, gridsize do
		    for x = 1, gridsize do
		        local current = grid[x][y]
		        if current.kind == 0 then
		        	if y > 100 then
			        	love.graphics.setColor(117,74,25)
			        	drawBlock(x,y)
			        else
			        	love.graphics.setColor(150,150,255)
			        	drawBlock(x,y)
			        end
		        end
		        if current.kind == 1 then
		        	love.graphics.setColor(255,0,0)
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
		        if current.kind == 20 then
		        	love.graphics.setColor(100,20,100)
		        	drawBlock(x,y)
		        end
		        if current.kind == 10 then
		        	love.graphics.setColor(200,100,100)
		        	drawBlock(x,y)
		        end
		    end
		end
	love.graphics.setCanvas()

	shadowcanvas = love.graphics.newCanvas(800, 600)
	love.graphics.setCanvas(shadowcanvas)
		shadowcanvas:clear()
		love.graphics.setBlendMode('alpha')
		for y = 1, gridsize do
		    for x = 1, gridsize do
		        local current = grid[x][y]
		        if current.kind ~= 1 then
			        love.graphics.setColor(0,0,0,255 - current.light)
			        drawBlock(x,y)
			    else
			    	love.graphics.setColor(0,0,0,255)
			        drawBlock(x,y)
			    end
		    end
		end
	love.graphics.setCanvas()


	biomecanvas = love.graphics.newCanvas(800, 600)
	love.graphics.setCanvas(biomecanvas)
		biomecanvas:clear()
		love.graphics.setBlendMode('alpha')
		for y = 1, gridsize do
		    for x = 1, gridsize do
		        local current = grid[x][y]
		        -- red
		        if current.biome == 1 then
			        love.graphics.setColor(255,0,0)
			        drawBlock(x,y)
			    end
			    -- red/green
			    if current.biome == 2 then
			        love.graphics.setColor(255,255,0)
			        drawBlock(x,y)
			    end
			    -- purple
			    if current.biome == 3 then
			        love.graphics.setColor(255,0,255)
			        drawBlock(x,y)
			    end
			    -- green
			    if current.biome == 4 then
			        love.graphics.setColor(0,255,0)
			        drawBlock(x,y)
			    end
			    -- blue
			    if current.biome == 5 then
			        love.graphics.setColor(0,0,255)
			        drawBlock(x,y)
			    end
		    end
		end
	love.graphics.setCanvas()
end



function graphicsDrawPOV()

	scale = 16
	framespast = framespast + 1

	for y = 1, gridsize do
	    for x = 1, gridsize do
	    	if (x + 1) * scale > camera.x and (y + 1) * scale > camera.y and (x - 1) * scale < camera.x + winW and (y - 1) * scale < camera.y + winH then
		        local current = grid[x][y]
		        if current.kind == 0 then
		        	if y > 100 then
			        	love.graphics.setColor(117,74,25)
			        	drawBlock(x,y)
			        else
			        	love.graphics.setColor(150,150,255)
			        	drawBlock(x,y)
			        end
		        end
		        if current.kind == 1 then
		        	love.graphics.setColor(255,0,0)
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
		        if current.kind == 20 then
		        	love.graphics.setColor(100,20,100)
		        	drawBlock(x,y)
		        end
		        if current.kind == 10 then
		        	love.graphics.setColor(200,100,100)
		        	drawBlock(x,y)
		        end
		        if current.kind == 2 then
		        	love.graphics.setColor(117,74,25)
		        	drawBlock(x,y)
		        	love.graphics.setColor(64,140,255,current.waterDensity)
		        	drawBlock(x,y)
		        end
		        if current.kind == 3 then
		        	love.graphics.setColor(117,74,25)
		        	drawBlock(x,y)
		        	love.graphics.setColor(64,140,255,current.waterDensity)
		        	drawBlock(x,y)
		        end
		        if current.kind == 7 then
		        	love.graphics.setColor(255,0,0)
		        	drawBlock(x,y)
		        end

		        if current.kind ~= 1 then
			        love.graphics.setColor(0,0,0,255 - current.light)
			        drawBlock(x,y)
			    else
			    	love.graphics.setColor(0,0,0,255)
			        drawBlock(x,y)
			    end

			    -- BIOMES
			    if current.biome == 1 then
			        love.graphics.setColor(255,0,0,20)
			        drawBlock(x,y)
			    end
			    -- red/green
			    if current.biome == 2 then
			        love.graphics.setColor(255,255,0,20)
			        drawBlock(x,y)
			    end
			    -- purple
			    if current.biome == 3 then
			        love.graphics.setColor(255,0,255,20)
			        drawBlock(x,y)
			    end
			    -- green
			    if current.biome == 4 then
			        love.graphics.setColor(0,255,0,20)
			        drawBlock(x,y)
			    end
			    -- blue
			    if current.biome == 5 then
			        love.graphics.setColor(0,0,255,20)
			        drawBlock(x,y)
			    end
			end
	    end
	end

	-- player = {
	-- 	x = 0,
	-- 	y = 0
	-- }

	love.graphics.setColor(0,255,255)
    drawBlock(player.x,player.y)
    love.graphics.setColor(255,0,255)
    love.graphics.rectangle("fill",player.x*scale - camera.x,player.y*scale - camera.y,scale/2,scale/2)

	love.graphics.setColor(255,255,255)
	love.graphics.print("" .. framespast,100,300)
end


function drawBlock(x,y)
	love.graphics.rectangle("fill",x*scale - camera.x,y*scale - camera.y,scale,scale)
end