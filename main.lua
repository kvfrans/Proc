cron = require "cron"
HC = require "HardonCollider"
graphics = require "source.graphics"
globals = require "source.globalvars"
generation = require "source.generation"
automation = require "source.automation"
collisionSource = require "source.collision"
aiSource = require "source.ai"


function love.load()
	collider = HC(100,on_collide,collision_stop)
	generationInit()
	collisionBlockUpdate()
	automationStart()
	graphicsInit()
	love.keyboard.setKeyRepeat(true)
end

function love.update(dt)
	for i = 1, #cronjobs do
		cronjobs[i]:update(dt)
	end
	automationTick()
end

function love.draw()
	graphicsDraw()
end