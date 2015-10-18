function generationInit()
	for x = 1, gridsize do
	    grid[x] = {}
	    for y = 1, gridsize do
	    	grid[x][y] = {}
	    	grid[x][y].kind = 0
	    	grid[x][y].light = 100
	    	grid[x][y].biome = 0
	    end
	end

	for x = 1, gridsize do
	    collisionGrid[x] = {}
	    for y = 1, gridsize do
	    	collisionGrid[x][y] = {}
	    end
	end

	-- make noise to seed the generation
	generationAll(function(localgrid,x,y)
		if love.math.noise(x/(gridsize/20),y/(gridsize/20),seed) > 0.5 then
			localgrid[x][y] = copyBlock(x,y,grid)
	        localgrid[x][y].kind = 1 -- Fill the values here
	    else
	    	localgrid[x][y] = copyBlock(x,y,grid)
	    	localgrid[x][y].kind = 0
	    end
    end)





	-- make edges
    generationAll(function(localgrid,x,y)
    	local border = 10
		if x <= border or x > gridsize - border or y <= border or y > gridsize - border then
			if y > 100 then
				localgrid[x][y] = copyBlock(x,y,grid)
		        localgrid[x][y].kind = 1 -- Fill the values here
		    end
	    end
    end)

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

	-- make crust
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

	-- make biomes
	local i = 1
	while i < 20 do
		local x = math.floor(math.random()*(gridsize - 2) + 1)
		local y = math.floor(math.random()*(gridsize - 2 - 100) + 1 + 100)
		if grid[x][y].kind == 0 then
			grid[x][y].biome = (i % 5) + 1
			i = i + 1
		end
	end

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
								end
							end
							if y > 2 then
								if grid[x][y-1].biome == 0 then
									grid[x][y-1] = copyBlock(x,y-1,grid)
									grid[x][y-1].biome = b
								end
							end
							if x < gridsize - 1 then
								if grid[x+1][y].biome == 0 then
									grid[x+1][y] = copyBlock(x+1,y,grid)
									grid[x+1][y].biome = b
								end
							end
							if x > 2 then
								if grid[x-1][y].biome == 0 then
									grid[x-1][y] = copyBlock(x-1,y,grid)
									grid[x-1][y].biome = b
								end
							end
						end
					end
				end
			end
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

	-- create light sources
	generationAll(function(localgrid,x,y)
		if grid[x][y].kind == 1 and y > 100 then
			local airNeighbors = helperNeighbors(x,y,0)
			if airNeighbors >= 2 then
				if math.random() < 0.01 then
					localgrid[x][y] = copyBlock(x,y,grid)
					localgrid[x][y].kind = 4
					localgrid[x][y].light = 255
					helperLights(localgrid,x,y)
				end
			end
		end
	end)

	-- create tree
	generationAll(function(localgrid,x,y)
		if grid[x][y].kind == 1 then
			if y > 4 then
				if grid[x][y-1].kind == 0 and grid[x][y-2].kind == 0 and grid[x][y-3].kind == 0 then
					local maketree = false
					if math.random() < 0.02 then
						maketree = true
					end
					if grid[x][y].biome == 4 and math.random() < 0.1 then
						maketree = true
					end
					if maketree then
						localgrid[x][y-1] = copyBlock(x,y,grid)
						localgrid[x][y-1].kind = 5
						localgrid[x][y-2] = copyBlock(x,y,grid)
						localgrid[x][y-2].kind = 5
						localgrid[x][y-3] = copyBlock(x,y,grid)
						localgrid[x][y-3].kind = 5
					end

				end
			end
		end
	end)

	-- create ores
	generationAll(function(localgrid,x,y)
		if grid[x][y].kind == 1 then
			if love.math.noise(x/(gridsize/20),y/(gridsize/20),seed+30) < 0.2 then
				localgrid[x][y] = copyBlock(x,y,grid)
		        localgrid[x][y].kind = 20
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


function helperLights(localgrid,basex,basey)
	local radius = 20
	for x = basex-radius, basex+radius do
		for y = basey-radius, basey+radius do
			local light = 255 - math.sqrt((basex - x)*(basex - x) + (basey - y)*(basey - y))*10
			if x > 1 and x < gridsize then
				if y > 1 and y < gridsize then
					local changelight = true
					if localgrid[x][y] ~= 0 then
						if light <= localgrid[x][y].light then
							changelight = false
						end
					end
					if light < 100 then
						changelight = false
					end
					if changelight then
						localgrid[x][y] = copyBlock(x,y,grid)
						localgrid[x][y].light = light
					end
				end
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