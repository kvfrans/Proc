function generationInit()
	for x = 1, gridsize do
	    grid[x] = {}
	    for y = 1, gridsize do
	    	grid[x][y] = {}
	    	grid[x][y].kind = 0
	    	grid[x][y].light = 100
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
		if love.math.noise(x/(gridsize/10),y/(gridsize/10),seed) > 0.5 then
	        localgrid[x][y].kind = 1 -- Fill the values here
	    else
	    	localgrid[x][y].kind = 0
	    end
    end)

	-- make edges
    generationAll(function(localgrid,x,y)
    	local border = 10
		if x <= border or x > gridsize - border or y <= border or y > gridsize - border then
	        localgrid[x][y].kind = 1 -- Fill the values here
	    end
    end)

    for i = 0, 3 do
		-- smooth out depending on # of neighbors
	    generationAll(function(localgrid,x,y)
	    	local neighbors = helperNeighbors(x,y,1,true)


			if neighbors <= 4 then
				localgrid[x][y].kind = 0
			elseif neighbors > 6 then
				localgrid[x][y].kind = 1
			else
				-- localgrid[x][y] = 1
			end
	    end)

	end

	-- makes water sources
	generationAll(function(localgrid,x,y)
		if grid[x][y].kind == 1 then
			local airNeighbors = helperNeighbors(x,y,0)
			if airNeighbors >= 2 then
				if math.random() < 0.01 then
					localgrid[x][y].kind = 2
					localgrid[x][y].waterDensity = 255
				end
			end
		end
	end)

	-- create light sources
	generationAll(function(localgrid,x,y)
		if grid[x][y].kind == 1 then
			local airNeighbors = helperNeighbors(x,y,0)
			if airNeighbors >= 2 then
				if math.random() < 0.01 then
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
					if math.random() < 0.02 then
						localgrid[x][y-1].kind = 5
						localgrid[x][y-2].kind = 5
						localgrid[x][y-3].kind = 5
					end
				end
			end
		end
	end)

	-- create mineral
	generationAll(function(localgrid,x,y)
		if grid[x][y].kind == 1 then
			if love.math.noise(x/(gridsize/10),y/(gridsize/10),seed+30) < 0.2 then
		        localgrid[x][y].kind = 6
		    end
		end
    end)

    for i = 2,gridsize do
    	if grid[100][i].kind == 1 and grid[100][i-1].kind == 0 then
    		grid[100][i-1].kind = 7
    		local bot = aiInit()
    		bot.x = 100
    		bot.y = i-1
    		table.insert(npc,bot)
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
					if light > localgrid[x][y].light then
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
	    	localgrid[x][y] = {}
	    	localgrid[x][y].kind = grid[x][y].kind
	    	localgrid[x][y].waterDensity = grid[x][y].waterDensity
	    	localgrid[x][y].light = grid[x][y].light
	    end
	end
	for y = 1, gridsize do
		for x = 1, gridsize do
			func(localgrid,x,y)
		end
	end
	grid = localgrid
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