grid = {}
newgrid = {}
collisionGrid = {}
cronjobs = {}
npc = {}
items = {}
valuetrain = {
	mousex = 0,
	mousey = 0
}

baselight = 75

spriteCache = {}
dirtBatch = {}

player = {
	x = 0,
	y = 0
}

winH = love.graphics.getHeight()
winW = love.graphics.getWidth()

camera = {
	x = 800,
	y = 800,
}

scale = 1
-- camerascale = 10

gridsize = 600

math.randomseed(os.time())
seed = math.random()
print(seed)

function gridAt(x,y)
	return grid[x][y]
end

function printGUI(string)
	local frame = loveframes.Create("frame")
	frame:SetName(string)
end