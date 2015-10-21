grid = {}
newgrid = {}
collisionGrid = {}
cronjobs = {}
npc = {}
valuetrain = {
	mousex = 0,
	mousey = 0
}

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