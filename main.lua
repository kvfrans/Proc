cron = require "cron"
HC = require "HardonCollider"
graphics = require "source.graphics"
globals = require "source.globalvars"
generation = require "source.generation"
automation = require "source.automation"
collisionSource = require "source.collision"
aiSource = require "source.ai"
cameraSource = require "source.camera"
player = require "source.player"
KeyMap = require "modules.keymap"
keySource = require "source.keymaphandle"


function love.load()
	collider = HC(100,on_collide,collision_stop)
	generationInit()
	collisionBlockUpdate()
	automationStart()
	graphicsInit()
	keyInit()
	love.keyboard.setKeyRepeat(true)
end

function love.update(dt)
	for i = 1, #cronjobs do
		cronjobs[i]:update(dt)
	end
	automationTick()
	cameraUpdate(dt)
	playerMove(dt)
	keyUpdate(dt)
end

function love.draw()
	graphicsDrawPOV()
end