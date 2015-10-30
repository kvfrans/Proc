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
building = require "source.building"
loveframes = require "frames"
inventory = require "source.inventory"
toolSource = require "source.tools"


function love.load()
	collider = HC(100,on_collide,collision_stop)
	generationInit()
	collisionBlockUpdate()
	automationStart()
	graphicsInit()
	keyInit()
	loveframes.update(dt)
	love.keyboard.setKeyRepeat(true)
	inventoryInit()
end

function love.update(dt)
	for i = 1, #cronjobs do
		cronjobs[i]:update(dt)
	end
	-- automationTick()
	cameraUpdate(dt)
	playerMove(dt)
	buildingUpdate(false)
	loveframes.update(dt)
	for i = 1, #items do
		if itemUpdate(items[i],dt) then
			table.remove(items,i)
			break
		end
	end
	keyUpdate(dt)
end

function love.draw()
	graphicsDrawPOV()
end

function love.mousepressed(x, y, button)
    loveframes.mousepressed(x, y, button)
    buildingUpdate(true)

    -- if button == "l" then
    -- 	buildRemove(x,y)
    -- end
    -- print("asd")
end

function love.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
end

function love.textinput(text)
	loveframes.textinput(text)
end

-- function love.keypressed(key, unicode)
--     loveframes.keypressed(key, unicode)
-- end

-- function love.keyreleased(key)
--     loveframes.keyreleased(key)
-- end