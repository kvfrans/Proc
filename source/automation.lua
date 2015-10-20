-- 0 - air
-- 1 - block
-- 2 - watersource
-- 3 - flowingwater
-- 4 - lightdirt
-- 5 - plant
-- 6 - snow
-- 7 - base

-- 10 - hardblock

-- 20 - some ore







-- BIOMES




function automationTick()
	-- generationAll(function(localgrid,x,y)
	for y = 1, gridsize do
		for x = 1, gridsize do
			if (x + 1) * scale > camera.x and (y + 1) * scale > camera.y and (x - 1) * scale < camera.x + winW and (y - 1) * scale < camera.y + winH then
				local current = grid[x][y]
				if current.kind == 2 or current.kind == 3 then
					if grid[x][y].waterDensity > 0 then
						if grid[x][y+1].kind == 0 then
							grid[x][y+1] = copyBlock(x,y+1,grid)
							grid[x][y+1].kind = 3
							grid[x][y+1].changed = true
							grid[x][y+1].waterDensity = grid[x][y].waterDensity
						elseif grid[x][y+1].kind ~= 0 and grid[x][y+1].kind ~= 3 then
							if grid[x+1][y].kind == 0 then
								grid[x+1][y] = copyBlock(x+1,y,grid)
								grid[x+1][y].kind = 3
								grid[x+1][y].changed = true
								grid[x+1][y].waterDensity = grid[x][y].waterDensity - 17
							end
							if grid[x-1][y].kind == 0 then
								grid[x-1][y] = copyBlock(x-1,y,grid)
								grid[x-1][y].kind = 3
								grid[x-1][y].changed = true
								grid[x-1][y].waterDensity = grid[x][y].waterDensity - 17
							end
						elseif grid[x][y+1].kind == 3 and grid[x][y].waterDensity > grid[x][y+1].waterDensity then
							grid[x][y+1] = copyBlock(x,y+1,grid)
							grid[x][y+1].changed = true
							grid[x][y+1].waterDensity = grid[x][y].waterDensity
						end
					end
				end
			end
		end
	end

	-- for i, bot in ipairs(npc) do
	-- 	aiTick(bot)
	-- end
end

function copyBlock(x,y,origin)
	local copy = {}
	copy.kind = origin[x][y].kind
	copy.waterDensity = origin[x][y].waterDensity
	copy.light = origin[x][y].light
	copy.biome = origin[x][y].biome
	copy.changed = origin[x][y].changed
	return copy
end

function automationStart()
	local tick = cron.every(0.5, function()
		automationTick()
	end)
	table.insert(cronjobs,tick)
end