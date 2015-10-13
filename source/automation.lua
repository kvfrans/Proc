-- 0 - air
-- 1 - block
-- 2 - watersource
-- 3 - flowingwater
-- 4 - lightdirt
-- 5 - plant
-- 6 - mineral
-- 7 - base
function automationTick()
	generationAll(function(localgrid,x,y)
		local current = grid[x][y]
		if current.kind == 2 or current.kind == 3 then
			if grid[x][y].waterDensity > 0 then
				if grid[x][y+1].kind == 0 then
					localgrid[x][y+1].kind = 3
					localgrid[x][y+1].waterDensity = grid[x][y].waterDensity
				elseif grid[x][y+1].kind ~= 0 and grid[x][y+1].kind ~= 3 then
					if grid[x+1][y].kind == 0 then
						localgrid[x+1][y].kind = 3
						localgrid[x+1][y].waterDensity = grid[x][y].waterDensity - 17
					end
					if grid[x-1][y].kind == 0 then
						localgrid[x-1][y].kind = 3
						localgrid[x-1][y].waterDensity = grid[x][y].waterDensity - 17
					end
				elseif grid[x][y+1].kind == 3 and grid[x][y].waterDensity > grid[x][y+1].waterDensity then
					localgrid[x][y+1].waterDensity = grid[x][y].waterDensity
				end
			end
		end
	end)

	for i, bot in ipairs(npc) do
		aiTick(bot)
	end
end

function automationStart()

end