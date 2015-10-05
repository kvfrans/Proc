function graphicsDraw()
	for y = 1, gridsize do
	    for x = 1, gridsize do
	        local current = grid[x][y]
	        if current == 1 then
	        	love.graphics.setColor(255,0,0)
	        	love.graphics.rectangle("fill",x*scale,y*scale,scale,scale)
	        end
	    end
	end
end

function graphicsInit()
end