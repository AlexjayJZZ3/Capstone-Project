function love.load()
whale = love.graphics.newImage("fuma.jpg")
end
--[[function fumasong()
--sound = love.audio.newSource("stage.mp3", "static")
--love.audio.play(sound)
end]]
player = {
  x = 150,
  y = 150,
  xvel = 0,
  yvel = 0,
  rotation = 0
}

local ANGACCEL      = 4
local ACCELERATION  = 400

function body()
love.graphics.setColor(255, 255, 255)           -- white
love.graphics.line(40, 90, 35, 120)             -- left foot
love.graphics.line(60, 90, 65, 120)  
love.graphics.setColor(0, 255, 0)               -- green
love.graphics.rectangle("fill", x, y, 40, 60) -- body

love.graphics.setColor(255, 0, 0)               -- red
love.graphics.circle("fill", 50, 20, 15)  
end
function message()
love.graphics.print("Hello World", 400, 300)	
end           
function four()
x = {100,1100,100,1100}
y = {120,120,20,20}
for index=1,4 do
	love.graphics.circle("fill", x[index], y[index], 15)
end		
end
	-- body


function love.update(dt) 
  x, y = love.mouse.getPosition()
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
end -- 

function love.draw()	
  love.graphics.setColor(255, 255, 255) 
  love.graphics.draw(whale, player.x, player.y)
  body()
  message()
  four()
  love.graphics.circle("line", 100, 120, 15)
end