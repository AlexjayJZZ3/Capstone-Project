Enemy = {position_x= 0, position_y = 0}
function Enemy.update(dt)
end

Bullet = {position_x= 0, position_y = 0}
function Bullet.update(dt)
end  

Player = {
  x = 150,
  y = 150,
  xvel = 0,
  yvel = 0,
  rotation = 0
}
function Player.update(self, dt)
  keyboardControl(dt, self)
end

player1 = Player.new()

local ANGACCEL      = 4
local ACCELERATION  = 400
function keyboardControl(dt, player)
 if love.keyboard.isDown"right" then
    -- rotate clockwise
    player.rotation = player.rotation + ANGACCEL*dt
  end
  if love.keyboard.isDown"left" then
    -- rotate counter-clockwise
    player.rotation = player.rotation - ANGACCEL*dt
  end
  if love.keyboard.isDown"down" then
    -- decelerate / accelerate backwards
    player.xvel = player.xvel - ACCELERATION*dt * math.cos(player.rotation)
    player.yvel = player.yvel - ACCELERATION*dt * math.sin(player.rotation)
  end
  if love.keyboard.isDown"up" then
    -- accelerate
    player.xvel = player.xvel + ACCELERATION*dt * math.cos(player.rotation)
    player.yvel = player.yvel + ACCELERATION*dt * math.sin(player.rotation)
  end
  player.x = player.x + player.xvel*dt
  player.y = player.y + player.yvel*dt
  player.xvel = player.xvel * 0.99
  player.yvel = player.yvel * 0.99
end 
function Player.draw(self)
  love.graphics.circle("line", self.x, self.y, 15)
end
objects = {}
--[[for i=1,20 do
  table.insert(objects, Enemy.new())
end
for i=1,20 do
  table.insert(objects, Bullet.new())) -- let's pretend someone actually fired these
end]]
player = Player.new()

function love.draw()
  for _,o in ipairs(objects) do 
    o:draw()
  end
  player:draw()
end

function love.update(dt)
  for _,o in ipairs(objects) do
    o:update(dt)
  end
  player:update(dt)
end