function keyInit()
	KeyMap:addMapping({"up","down","left","right","inventory","slowattack","focus","debug"})
	KeyMap:bind( "up" , {"key", "w", "up"} )
	KeyMap:bind( "up" , {"joy" , "dpup" , "up" } )
	KeyMap:bind( "down" , {"key", "s", "down"} )
	KeyMap:bind( "down" , {"joy" , "dpdown" , "down" } )
	KeyMap:bind( "left" , {"key", "a", "left"} )
	KeyMap:bind( "left" , {"joy" , "dpleft" , "left" } )
	KeyMap:bind( "right" , {"key", "d", "right"} )
	KeyMap:bind( "right" , {"joy" , "dpright" , "right" } )
	KeyMap:bind( "inventory" , {"key", "e"} )
	KeyMap:bind( "inventory" , {"joy" , "e" } )
	KeyMap:bind( "slowattack" , {"key", "x"} )
	KeyMap:bind( "slowattack" , {"joy" , "a" } )
	KeyMap:bind( "focus" , {"key", "lshift"} )
	KeyMap:bind( "focus" , {"joy" , "b" } )
	KeyMap:bind( "debug" , {"key", "c"} )

end

function keyUpdate(dt)
	KeyMap:update(dt)
end

function keyDown(string)
	return KeyMap:isDown(string)
end

function keyPressed(string)
	return KeyMap:isPushed(string)
end