function generationInit()
	for x = 1, gridsize do
	    grid[x] = {}
	    for y = 1, gridsize do
	    	grid[x][y] = 0
	    end
	end

	-- make noise to seed the generation
	generationAll(function(localgrid,x,y)
		if love.math.noise(x/(gridsize/10),y/(gridsize/10),seed) > 0.5 then
	        localgrid[x][y] = 1 -- Fill the values here
	    else
	    	localgrid[x][y] = 0
	    end
    end)

	-- make edges
    generationAll(function(localgrid,x,y)
		if x == 1 or x == gridsize or y == 1 or y == gridsize then
	        localgrid[x][y] = 1 -- Fill the values here
	    end
    end)

    for i = 0, 3 do
		-- smooth out depending on # of neighbors
	    generationAll(function(localgrid,x,y)
	    	local neighbors = helperNeighbors(x,y,1)


			if neighbors <= 4 then
				localgrid[x][y] = 0
			elseif neighbors > 6 then
				localgrid[x][y] = 1
			else
				-- localgrid[x][y] = 1
			end
	    end)

	end

	generationAll(function(localgrid,x,y)
		if grid[x][y] == 0 then

		end

	end)

end

function generationAll(func)
	local localgrid = {}
	for x = 1, gridsize do
	    localgrid[x] = {}
	    for y = 1, gridsize do
	    	localgrid[x][y] = grid[x][y]
	    end
	end
	for y = 1, gridsize do
		for x = 1, gridsize do
			func(localgrid,x,y)
		end
	end
	grid = localgrid
end


function helperNeighbors(x,y,tile)
	local neighbors = 0
	if x > 1 then
		if grid[x-1][y] == tile then
			neighbors = neighbors + 1
		end
		if y > 1 then
			if grid[x-1][y-1] == tile then
				neighbors = neighbors + 1
			end
		end
		if y < gridsize then
			if grid[x-1][y+1] == tile then
				neighbors = neighbors + 1
			end
		end
	end

	if x < gridsize then
		if grid[x+1][y] == tile then
			neighbors = neighbors + 1
		end
		if y > 1 then
			if grid[x+1][y-1] == tile then
				neighbors = neighbors + 1
			end
		end
		if y < gridsize then
			if grid[x+1][y+1] == tile then
				neighbors = neighbors + 1
			end
		end
	end

	if y > 1 then
		if grid[x][y-1] == tile then
			neighbors = neighbors + 1
		end
	end
	if y < gridsize then
		if grid[x][y+1] == tile then
			neighbors = neighbors + 1
		end
	end

	return neighbors
end