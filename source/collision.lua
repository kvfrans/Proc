function collisionBlockUpdate()
	generationAll(function(localgrid,x,y)
		local current = grid[x][y]
		if current.kind == 1 then
			if helperNeighbors(x,y,0,false) > 0 then
				collisionGrid[x][y] = collider:addRectangle(x*scale,y*scale,scale,scale)
			end
		end
	end)
end