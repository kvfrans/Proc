cron = require "cron"
graphics = require "source.graphics"
globals = require "source.globalvars"
generation = require "source.generation"



function love.load()
	generationInit()
	graphicsInit()
end

function love.update(dt)
	for i = 1, #cronjobs do
		cronjobs[i]:update(dt)
	end
end

function love.draw()
	graphicsDraw()
end


