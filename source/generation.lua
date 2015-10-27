function generationInit()

	print("make grid")

	for x = 1, gridsize do
	    grid[x] = {}
	    for y = 1, gridsize do
	    	grid[x][y] = {}
	    	grid[x][y].kind = 0
	    	grid[x][y].light = baselight
	    	grid[x][y].playerlight = 0
	    	grid[x][y].biome = 0
	    	grid[x][y].changed = false
	    	grid[x][y].red = 100
	    	grid[x][y].blue = 100
	    	grid[x][y].green = 100
	    end
	end

	for x = 1, gridsize do
	    collisionGrid[x] = {}
	    for y = 1, gridsize do
	    	collisionGrid[x][y] = {}
	    end
	end

	print("make noise")
	generationAll(function(localgrid,x,y)
		if love.math.noise(x/(gridsize/20),y/(gridsize/20),seed) > 0.5 then
			localgrid[x][y] = copyBlock(x,y,grid)
	        localgrid[x][y].kind = 1 -- Fill the values here
	    else
	    	localgrid[x][y] = copyBlock(x,y,grid)
	    	localgrid[x][y].kind = 0
	    end
    end)





	print("make edge")
    generationAll(function(localgrid,x,y)
    	local border = 10
		if x <= border or x > gridsize - border or y <= border or y > gridsize - border then
			if y > 100 then
				localgrid[x][y] = copyBlock(x,y,grid)
		        localgrid[x][y].kind = 1 -- Fill the values here
		    end
	    end
    end)

    print("smooth")
    for i = 0, 3 do
		-- smooth out depending on # of neighbors
	    generationAll(function(localgrid,x,y)
	    	local neighbors = helperNeighbors(x,y,1,true)


			if neighbors <= 4 then
				localgrid[x][y] = copyBlock(x,y,grid)
				localgrid[x][y].kind = 0
			elseif neighbors > 6 then
				localgrid[x][y] = copyBlock(x,y,grid)
				localgrid[x][y].kind = 1
			else
				-- localgrid[x][y] = 1
			end
	    end)

	end

	print("crust")
    generationAll(function(localgrid,x,y)
		if y < 100 then
			localgrid[x][y] = copyBlock(x,y,grid)
			localgrid[x][y].kind = 0
		elseif y < 125 then
			localgrid[x][y] = copyBlock(x,y,grid)
			localgrid[x][y].kind = 1
		end
		if y < 105 and y >= 100 then
    		localgrid[x][y] = copyBlock(x,y,grid)
			localgrid[x][y].kind = 6
		end
    end)

	print("biome origin")
	local i = 1
	while i < 40 do
		local x = math.floor(math.random()*(gridsize - 2) + 1)
		local y = math.floor(math.random()*(gridsize - 2 - 100) + 1 + 100)
		if grid[x][y].kind == 0 then
			grid[x][y].biome = (i % 5) + 1
			grid[x][y].r = math.random()*255
			grid[x][y].g = math.random()*255
			grid[x][y].b = math.random()*255
			i = i + 1
		end
	end

	print("biome loop")
	-- make biomes
	for i = 0,200 do
		for x = 1, gridsize do
		    for y = 1, gridsize do
				local b = grid[x][y].biome
				if not blockAt(x,y) then
					if b ~= 0 then
						if helperNeighborsBiome(x,y,0) >= 1 and helperNeighbors(x,y,0) >= 1 then
							if y < gridsize-1 then
								if grid[x][y+1].biome == 0 then
									grid[x][y+1] = copyBlock(x,y+1,grid)
									grid[x][y+1].biome = b
									editColor(x,y+1,grid[x][y].red,grid[x][y].blue,grid[x][y].green)
								end
							end
							if y > 2 then
								if grid[x][y-1].biome == 0 then
									grid[x][y-1] = copyBlock(x,y-1,grid)
									grid[x][y-1].biome = b
									editColor(x,y-1,grid[x][y].red,grid[x][y].blue,grid[x][y].green)
								end
							end
							if x < gridsize - 1 then
								if grid[x+1][y].biome == 0 then
									grid[x+1][y] = copyBlock(x+1,y,grid)
									grid[x+1][y].biome = b
									editColor(x+1,y,grid[x][y].red,grid[x][y].blue,grid[x][y].green)
								end
							end
							if x > 2 then
								if grid[x-1][y].biome == 0 then
									grid[x-1][y] = copyBlock(x-1,y,grid)
									grid[x-1][y].biome = b
									editColor(x-1,y,grid[x][y].red,grid[x][y].blue,grid[x][y].green)
								end
							end
						end
					end
				end
			end
		end
	end

	print("biome loop walls")

	-- make biomes free
	for i = 0,100 do
		for x = 1, gridsize do
		    for y = 1, gridsize do
				local b = grid[x][y].biome
				if true then
					if b ~= 0 then
						if helperNeighborsBiome(x,y,0) >= 1 then
							if y < gridsize-1 then
								if grid[x][y+1].biome == 0 then
									grid[x][y+1] = copyBlock(x,y+1,grid)
									grid[x][y+1].biome = b
									editColor(x,y+1,grid[x][y].red,grid[x][y].blue,grid[x][y].green)
								end
							end
							if y > 2 then
								if grid[x][y-1].biome == 0 then
									grid[x][y-1] = copyBlock(x,y-1,grid)
									grid[x][y-1].biome = b
									editColor(x,y-1,grid[x][y].red,grid[x][y].blue,grid[x][y].green)
								end
							end
							if x < gridsize - 1 then
								if grid[x+1][y].biome == 0 then
									grid[x+1][y] = copyBlock(x+1,y,grid)
									grid[x+1][y].biome = b
									editColor(x+1,y,grid[x][y].red,grid[x][y].blue,grid[x][y].green)
								end
							end
							if x > 2 then
								if grid[x-1][y].biome == 0 then
									grid[x-1][y] = copyBlock(x-1,y,grid)
									grid[x-1][y].biome = b
									editColor(x-1,y,grid[x][y].red,grid[x][y].blue,grid[x][y].green)
								end
							end
						end
					end
				end
			end
		end
	end

	for x = 3, gridsize - 3 do
	    for y = 3, gridsize - 3 do
	    	avgColor(x,y,x+1,y)
	    	avgColor(x,y,x-1,y)
	    	avgColor(x,y,x,y+1)
	    	avgColor(x,y,x,y-1)
	    end
	end

	-- makes water sources
	generationAll(function(localgrid,x,y)
		if grid[x][y].kind == 1 and y > 100 then
			local airNeighbors = helperNeighbors(x,y,0)
			if airNeighbors >= 2 then
				local maketree = false
				if math.random() < 0.01 then
					maketree = true
				end
				if grid[x][y].biome == 5 and math.random() < 0.05 then
					maketree = true
				end
				if maketree then
					localgrid[x][y] = copyBlock(x,y,grid)
					localgrid[x][y].kind = 2
					localgrid[x][y].waterDensity = 255
				end
			end
		end
	end)



	-- create tree
	generationAll(function(localgrid,x,y)
		if grid[x][y].kind == 1 then
			if y > 6 then
				if grid[x][y-1].kind == 0 and grid[x][y-2].kind == 0 and grid[x][y-3].kind == 0 then
					local maketree = false
					if grid[x][y].biome == 4 and x % 2 == 0 then
						maketree = true
					elseif math.random() < 0.02 then
						maketree = true
					end
					if maketree then
						localgrid[x][y-1] = copyBlock(x,y-1,grid)
						localgrid[x][y-1].kind = 5
						localgrid[x][y-2] = copyBlock(x,y-2,grid)
						localgrid[x][y-2].kind = 5
						localgrid[x][y-3] = copyBlock(x,y-3,grid)
						localgrid[x][y-3].kind = 5

						if grid[x][y].biome == 4 and grid[x][y-4].kind == 0 then
							if math.random() < 0.5 then
								localgrid[x][y-4] = copyBlock(x,y-4,grid)
								localgrid[x][y-4].kind = 5
								if math.random() < 0.5 and grid[x][y-5].kind == 0 then
									localgrid[x][y-5] = copyBlock(x,y-5,grid)
									localgrid[x][y-5].kind = 5
								end
							end
						end
					end

				end
			end
		end
	end)

	-- create ores
	generationAll(function(localgrid,x,y)
		if grid[x][y].kind == 1 then
			-- ore 1
			if love.math.noise(x/(gridsize/20),y/(gridsize/20),seed+30) < 0.1 then
				localgrid[x][y] = copyBlock(x,y,grid)
		        localgrid[x][y].kind = 20
		    end
		    -- ore 2
		    if love.math.noise(x/(gridsize/20),y/(gridsize/20),seed+33) < 0.1 then
				localgrid[x][y] = copyBlock(x,y,grid)
		        localgrid[x][y].kind = 21
		    end
		    -- ore 3
		    if love.math.noise(x/(gridsize/20),y/(gridsize/20),seed+36) < 0.1 then
				localgrid[x][y] = copyBlock(x,y,grid)
		        localgrid[x][y].kind = 22
		    end
		end
    end)

 --    for x = 1, gridsize do
	--     for y = 1, gridsize do
	--     	if grid[x][y].kind == 1 then
	--     		grid[x][y].light = 10
	--     	end
	--     end
	-- end

		-- create light sources
	generationAll(function(localgrid,x,y)
		if grid[x][y].kind == 0 and y > 100 then
			local airNeighbors = helperNeighbors(x,y,1)
			if airNeighbors == 1 then
				if math.random() < 0.01 then
					localgrid[x][y] = copyBlock(x,y,grid)
					localgrid[x][y].kind = 4
					localgrid[x][y].light = 255
					helperLights(localgrid,x,y)
				end
			end
		end
	end)


	-- WE NEED TO BUILD A WALL
    for x = 290, 310 do
	    for y = 50, 400 do
	    	if y < 300 then
		    	grid[x][y].kind = 10
	    	elseif grid[x][y-1].kind == 10 then
	    		if math.random() < 0.9 then
	    			grid[x][y].kind = 10
	    		end
	    	end
	    end
	end

	print("automation ")
	for i = 0,200 do
		automationTick()
	end

    -- make bot
    for i = 2,gridsize do
    	if grid[100][i].kind == 1 and grid[100][i-1].kind == 0 then
    		grid[100][i-1].kind = 7
    		-- local bot = aiInit()
    		-- bot.x = 100
    		-- bot.y = i-1
    		-- table.insert(npc,bot)
    		playerInit(100,i - 2)
    		break
    	end
    end
end

function avgColor(x1,y1,x2,y2)
	local first = grid[x1][y1]
	local second = grid[x2][y2]

	if math.abs(first.red - second.red) > 100 then
		first.red = first.red - (first.red - second.red)/3
		second.red = second.red - (second.red - first.red)/3
	end
	if math.abs(first.blue - second.blue) > 100 then
		first.blue = first.blue - (first.blue - second.blue)/3
		second.blue = second.blue - (second.blue - first.blue)/3
	end
	if math.abs(first.green - second.green) > 100 then
		first.green = first.green - (first.green - second.green)/3
		second.green = second.green - (second.green - first.green)/3
	end
end

function editColor(x,y,red,blue,green)
	local mathr = math.random()
	local dist = 20
	local newred = red
	local newblue = blue
	local newgreen = green
	if mathr < 0.3 then
		newred = red + math.floor(math.random()*dist - dist/2)
		newblue = blue + math.floor(math.random()*dist - dist/2)
		newgreen = green + math.floor(math.random()*dist - dist/2)
	end
	if newred < 0 then
		newred = 1
	end
	if newblue < 0 then
		newblue = 1
	end
	if newgreen < 0 then
		newgreen = 1
	end
	if newred > 255 then
		newred = 254
	end
	if newblue > 255 then
		newblue = 254
	end
	if newgreen > 255 then
		newgreen = 254
	end
	-- print(" " .. red .. " " .. newred .. " " .. blue .. " " .. newblue .. " " .. green .. " " .. newgreen)
	grid[x][y].red = newred
	grid[x][y].blue = newblue
	grid[x][y].green = newgreen
end


function helperLights(localgrid,basex,basey)
	for i = 1,72 do
		local angle = i*5
		local currentX = basex
		local currentY = basey
		local light = 255
		for c = 1,20 do
			if c > 15 then
				light = light - 55
			end
			-- light = light - 17
			if light < baselight then
				light = baselight
			end
			currentX = currentX + math.cos((math.pi / 180) * angle)/2
			currentY = currentY + math.sin((math.pi / 180) * angle)/2
			-- love.graphics.setColor(0,255,255)
			-- love.graphics.rectangle("fill",currentX*scale - camera.x,currentY*scale - camera.y,3,3)

			if grid[math.floor(currentX)][math.floor(currentY)].light < light then
				grid[math.floor(currentX)][math.floor(currentY)].light = light
			end
			if light/2 > baselight then
				if grid[math.floor(currentX)+1][math.floor(currentY)].light == baselight then
					grid[math.floor(currentX)+1][math.floor(currentY)].light = light/2
				end
				if grid[math.floor(currentX)-1][math.floor(currentY)].light == baselight then
					grid[math.floor(currentX)-1][math.floor(currentY)].light = light/2
				end
				if grid[math.floor(currentX)][math.floor(currentY)+1].light == baselight then
					grid[math.floor(currentX)][math.floor(currentY)+1].light = light/2
				end
				if grid[math.floor(currentX)][math.floor(currentY)+1].light == baselight then
					grid[math.floor(currentX)][math.floor(currentY)+1].light = light/2
				end
			end
			if pointCollide(basex,basey,currentX,currentY,0.5,0.5) then
				break
			end
		end
	end
end

function generationAll(func)
	local localgrid = {}
	for x = 1, gridsize do
	    localgrid[x] = {}
	    for y = 1, gridsize do
	    	localgrid[x][y] = 0
	    end
	end
	for y = 1, gridsize do
		for x = 1, gridsize do
			func(localgrid,x,y)
		end
	end
	for x = 1, gridsize do
	    for y = 1, gridsize do
	    	if localgrid[x][y] ~= 0 then
	    		grid[x][y] = copyBlock(x,y,localgrid)
	    	end
	    end
	end
end


function helperNeighbors(x,y,tile,edge)
	local neighbors = 0
	if x > 1 then
		if grid[x-1][y].kind == tile then
			neighbors = neighbors + 1
		end
		if y > 1 then
			if grid[x-1][y-1].kind == tile then
				neighbors = neighbors + 1
			end
		elseif edge then
			neighbors = neighbors + 1
		end
		if y < gridsize then
			if grid[x-1][y+1].kind == tile then
				neighbors = neighbors + 1
			end
		elseif edge then
			neighbors = neighbors + 1
		end
	elseif edge then
		neighbors = neighbors + 1
	end

	if x < gridsize then
		if grid[x+1][y].kind == tile then
			neighbors = neighbors + 1
		end
		if y > 1 then
			if grid[x+1][y-1].kind == tile then
				neighbors = neighbors + 1
			end
		elseif edge then
			neighbors = neighbors + 1
		end
		if y < gridsize then
			if grid[x+1][y+1].kind == tile then
				neighbors = neighbors + 1
			end
		elseif edge then
			neighbors = neighbors + 1
		end
	elseif edge then
		neighbors = neighbors + 1
	end

	if y > 1 then
		if grid[x][y-1].kind == tile then
			neighbors = neighbors + 1
		end
	elseif edge then
		neighbors = neighbors + 1
	end
	if y < gridsize then
		if grid[x][y+1].kind == tile then
			neighbors = neighbors + 1
		end
	elseif edge then
		neighbors = neighbors + 1
	end

	return neighbors
end

function helperNeighborsBiome(x,y,tile,edge)
	local neighbors = 0
	if x > 1 then
		if grid[x-1][y].biome == tile then
			neighbors = neighbors + 1
		end
		if y > 1 then
			if grid[x-1][y-1].biome == tile then
				neighbors = neighbors + 1
			end
		elseif edge then
			neighbors = neighbors + 1
		end
		if y < gridsize then
			if grid[x-1][y+1].biome == tile then
				neighbors = neighbors + 1
			end
		elseif edge then
			neighbors = neighbors + 1
		end
	elseif edge then
		neighbors = neighbors + 1
	end

	if x < gridsize then
		if grid[x+1][y].biome == tile then
			neighbors = neighbors + 1
		end
		if y > 1 then
			if grid[x+1][y-1].biome == tile then
				neighbors = neighbors + 1
			end
		elseif edge then
			neighbors = neighbors + 1
		end
		if y < gridsize then
			if grid[x+1][y+1].biome == tile then
				neighbors = neighbors + 1
			end
		elseif edge then
			neighbors = neighbors + 1
		end
	elseif edge then
		neighbors = neighbors + 1
	end

	if y > 1 then
		if grid[x][y-1].biome == tile then
			neighbors = neighbors + 1
		end
	elseif edge then
		neighbors = neighbors + 1
	end
	if y < gridsize then
		if grid[x][y+1].biome == tile then
			neighbors = neighbors + 1
		end
	elseif edge then
		neighbors = neighbors + 1
	end

	return neighbors
end