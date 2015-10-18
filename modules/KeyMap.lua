-- @module keymap

local keymap = {}

local _keyCheck = false
local _keyCheckFor = false
local _keyLast = false
local _map = {}
local joystick = love.joystick.getJoysticks()[1]
local lastPushed = nil
love.keyboard.setKeyRepeat( true )

-- Add a new mapping to keymap
function keymap:addMapping( maps )
   for _ , m in pairs( maps ) do

      _map[m] = { held=false , pushed=false , keys={} , joy={} }

   end
end

-- Retreive mapping from id
function keymap:getMapping(id)
   if id then
      return _map[id]
   else
      local mapList = {}
      for i , m in pairs(_map) do
         mapList[i] = m
      end
      return mapList
   end
end

-- Retreive a mapping from key
local function findMap(keyType, key)

   for i , map in pairs(_map) do
      if keyType == "key" then
         for j , k in pairs(map.keys) do
            if k == key then
               return map
            end
         end
      else
         for j , k in pairs(map.joy) do
            if k == key then
               return map
            end
         end
      end
   end
end

-- Check if system is checking for keys to bind
function keymap:isBinding()
   return _keyCheck
end

-- Call this in your main code.
function keymap:update( dt )
   if _keyCheck then
      if _keyLast then
         self:bind(_keyCheckFor,_keyLast)
         _keyCheck = false
         _keyLast = nil
         _keyCheckFor = nil
      end
   else
      for i,m in pairs(_map) do
         if m.pushed then
            m.pushed = false
            m.held = true
         end
      end

   end
end

--Check if any key in the given mapping is either being pushed or held.
function keymap:isDown( map )
   if map ~= nil then
      return _map[map].held or _map[map].pushed
   end
end

-- Check if any key in the given mapping has been recently pushed
function keymap:isPushed( map )
   if map ~= nil then
      if _map[map].pushed then
         --_map[map].pushed = false
         return true
      end
      return false
   end
end


-- Check if key is being held down
function keymap:isHeld( map )
   return _map[map].held
end

-- Bind key pushed ("id") to mapping ("map")
function keymap:bind( map , id )
   if id[1] == "joy" then
      for i , m in pairs( id ) do
         if i > 1 then
            table.insert( _map[map].joy , id[i] )
         end
      end
   else
      for i , m in pairs( id ) do
         if i > 1 then
            table.insert( _map[map].keys , id[i] )
         end
      end
   end
end

-- Remove all Bindings from mapping
function keymap:unbind( map )
   _map[map].keys = {}
   _map[map].joy = {}
   _keyLast = false
   _keyCheck = false
   _keyCheckFor = false
end


-- Binds the next key pushed to given mapping
function keymap:addBind( map )
   _keyCheck = true
   _keyCheckFor = map
end




-- KEYBOARD SUPPORT --
function love.keypressed( key , isrepeat )
   if not _keyCheck then
      local k = findMap("key", key)
      if k then
         if not isrepeat then
            k.pushed = true
            k.held = false
         else
            k.pushed = false
            k.held = true
         end
         return
      end
   elseif key == "escape" then

      _keyCheck = false
      _keyLast = nil
      _keyCheckfor = nil

   else
      print("key")
      _keyLast = { "key" , key }
   end
end

function love.keyreleased( key )
   local k = findMap("key", key)
   if not _keyCheck and k then
         k.held = false
         k.pushed = false
   end
end


-- JOYSTICK SUPPORT --
function love.gamepadpressed( joystick, button )
   local k = findMap("joy", button)
   if not _keyCheck and k then
      k.held = true
      k.pushed = true
   else
      _keyLast = { "joy" , button }

   end
end

function love.gamepadreleased( joystick, button )
   local k = findMap("joy", button)
   if not _keyCheck and k then
      k.pressed = false
      k.held = false
   end
end

function love.joystickaxis( joystick, axis, value )
   if not _keyCheck then
      for i , m in pairs ( _map ) do
         for j , k in pairs( m.joy ) do
            if axis  == 1 then
               if k == "left" then
                  if value < -0.25 then
                     m.pushed = true
                     m.held = true
                  else
                     m.pushed = false
                     m.held = false
                  end
               end
               if k == "right" then
                  if value > 0.25 then
                     m.pushed = true
                     m.held = true
                  else
                     m.pushed = false
                     m.held = false
                  end
               end
            end

            if axis  == 2 then
               if k == "up" then
                  if value < -0.25 then
                     m.pushed = true
                     m.held = true
                  else
                     m.pushed = false
                     m.held = false
                  end
               end
               if k == "down" then
                  if value > 0.25 then
                     m.pushed = true
                     m.held = true
                  else
                     m.pushed = false
                     m.held = false
                  end
               end
            end

         end
      end

   else

      if axis == 1 then
         if value == -1 then
            _keyLast = { "joy" , "left" }
         elseif value < 1 then
            _keyLast = { "joy" , "right" }
         end
      end

      if axis == 2 then
         if value == -1 then
            _keyLast = { "joy" , "up" }
         elseif value == 1 then
            _keyLast = { "joy" , "down" }
         end
      end

   end
end

return keymap