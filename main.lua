function love.load()
	whale = love.graphics.newImage("asteroid-icon.png")
	whale1 = love.graphics.newImage("win.png")
	whale2 = love.graphics.newImage("over.png")
	arenaWidth = 800
    arenaHeight = 600
    bulletRadius = 5
    shipRadius = 30
    game_over = false
    game_lose = false
    gameOverWaitTime = 100
    asteroidStages = {
        {
            speed = 120,
            radius = 20,
            xsize = 0.2,
            ysize = 0.2
        },
        {
            speed = 70,
            radius = 40,
            xsize = 0.4,
            ysize = 0.4
        },
        {
            speed = 50,
            radius = 80,
            xsize = 0.6,
            ysize = 0.6
        },
        {
            speed = 20,
            radius = 100,
            xsize = 0.7,
            ysize = 0.7
        }
    }
	function reset()
		--[[if game_over then
        	gameOverWaitTime = gameOverWaitTime - 1
    	end
   	 	if gameOverWaitTime == 0 then
        	gameOverWaitTime = 100
        	game_over = false
    	end
    	if game_lose then
        	gameOverWaitTime = gameOverWaitTime - 1
   	 	end
    	if gameOverWaitTime == 0 then
        	gameOverWaitTime = 100
        	game_lose = false
    	end]]
    	shipX = arenaWidth / 2
    	shipY = arenaHeight / 2

    	shipAngle = 0
    	shipSpeedX = 0
    	shipSpeedY = 0
    	score = 0
    	bullets = {}
    
    	bulletTimer = 0
    	asteroids = {
        	{
            	x = 100,
            	y = 100,
        	},
        	{
            	x = arenaWidth - 100,
            	y = 100,
        	},
        	{
            	x = arenaWidth / 2,
            	y = arenaHeight - 100,
        	}
    	}
    

    	for asteroidIndex, asteroid in ipairs(asteroids) do
        	asteroid.angle = love.math.random() * (2 * math.pi)
        	asteroid.stage = #asteroidStages
        end	
    end
    reset()
end

function love.update(dt)
    -- etc.
    if game_over then
        gameOverWaitTime = gameOverWaitTime - 1
    end
    if gameOverWaitTime == 0 then
        gameOverWaitTime = 100
        game_over = false
    end
    if game_lose then
        gameOverWaitTime = gameOverWaitTime - 1
    end
    if gameOverWaitTime == 0 then
        gameOverWaitTime = 100
        game_lose = false
    end
	local turnSpeed = 10
    if love.keyboard.isDown('right') then
         shipAngle = (shipAngle + turnSpeed * dt) % (2 * math.pi)
    end

    if love.keyboard.isDown('left') then
         shipAngle = (shipAngle - turnSpeed * dt) % (2 * math.pi)
    end
    if love.keyboard.isDown('up') then
        local shipSpeed = 100
        shipSpeedX = shipSpeedX + math.cos(shipAngle) * shipSpeed * dt
        shipSpeedY = shipSpeedY + math.sin(shipAngle) * shipSpeed * dt
    end
    if love.keyboard.isDown('down') then
    	local shipSpeed = 200
    	shipSpeedX = shipSpeedX - math.cos(shipAngle) * shipSpeed * dt
        shipSpeedY = shipSpeedY - math.sin(shipAngle) * shipSpeed * dt
    end	
    shipX = (shipX + shipSpeedX * dt) % arenaWidth
    shipY = (shipY + shipSpeedY * dt) % arenaHeight

    local function areCirclesIntersecting(aX, aY, aRadius, bX, bY, bRadius)
        return (aX - bX)^2 + (aY - bY)^2 <= (aRadius + bRadius)^2
    end

	for bulletIndex = #bullets, 1, -1 do
        local bullet = bullets[bulletIndex]

        bullet.timeLeft = bullet.timeLeft - dt
        if bullet.timeLeft <= 0 then
            table.remove(bullets, bulletIndex)
        else
        	local bulletSpeed = 500
        	bullet.x = (bullet.x + math.cos(bullet.angle) * bulletSpeed * dt) % arenaWidth
        	bullet.y = (bullet.y + math.sin(bullet.angle) * bulletSpeed * dt) % arenaHeight
        	bulletTimer = bulletTimer + dt
        end    

    	for asteroidIndex = #asteroids, 1, -1 do
        	local asteroid = asteroids[asteroidIndex]

        	if areCirclesIntersecting(bullet.x, bullet.y, bulletRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then
            	table.remove(bullets, bulletIndex)
            	if asteroid.stage > 1 then
            		local angle1 = love.math.random() * (2 * math.pi)
                	local angle2 = (angle1 - math.pi) % (2 * math.pi)
                	score = score + 250

                	table.insert(asteroids, {
                    	x = asteroid.x,
                   		y = asteroid.y,
                    	angle = angle1,
                    	stage = asteroid.stage - 1,

                	})
                	table.insert(asteroids, {
                   		x = asteroid.x,
                    	y = asteroid.y,
                    	angle = angle2,
                    	stage = asteroid.stage - 1,
                	})
                else
                	score = score + 1000	
                end
                table.remove(asteroids, asteroidIndex)
            	break
            end	
        end
	end   
 	bulletTimer = bulletTimer + dt
    if love.keyboard.isDown('s') then
        if bulletTimer >= 0.5 then
            bulletTimer = 0

            table.insert(bullets, {
                x = shipX + math.cos(shipAngle) * shipRadius,
                y = shipY + math.sin(shipAngle) * shipRadius,
                angle = shipAngle,
                timeLeft = 4,
            })
        end
    end	
	for asteroidIndex, asteroid in ipairs(asteroids) do
        asteroid.x = (asteroid.x + math.cos(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % arenaWidth
        asteroid.y = (asteroid.y + math.sin(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % arenaHeight

        if areCirclesIntersecting(shipX, shipY, shipRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then
        --if areCirclesIntersecting(shipX, shipY, shipRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then	
        	game_lose = true
            reset()
            break
        end
    end

   
	if #asteroids == 0 then
		game_over = true
        reset()
    end
end

function love.draw()
	if game_over == true then
		--love.graphics.draw(whale1,800,600)
		love.graphics.draw(whale1, 100,100,0, love.graphics.getWidth()/love.graphics.getWidth(), love.graphics.getHeight()/love.graphics.getHeight())
		--[[for i = 0, love.graphics.getWidth() / whale1:getWidth() do
        	for j = 0, love.graphics.getHeight() / whale1:getHeight() do
            	love.graphics.draw(whale1, i * whale1:getWidth(), j * whale1:getHeight())
        	end
    	end]]
    end
    if game_lose == true then
		--love.graphics.draw(whale1,800,600)
		love.graphics.draw(whale2, 175,120,0, love.graphics.getWidth()/love.graphics.getWidth(), love.graphics.getHeight()/love.graphics.getHeight())
	end	
	for y = -1, 1 do
        for x = -1, 1 do
            love.graphics.origin()
            love.graphics.translate(x * arenaWidth, y * arenaHeight)
    		love.graphics.setColor(0, 0, 1)
    		love.graphics.circle('fill', shipX, shipY, shipRadius)

    		love.graphics.setColor(0, 1, 1)
    		local shipCircleDistance = 20
    		love.graphics.circle('fill', 
    			shipX + math.cos(shipAngle) * shipCircleDistance,
  				shipY + math.sin(shipAngle) * shipCircleDistance, 
  				5
  			)

            -- etc.

            for bulletIndex, bullet in ipairs(bullets) do
                love.graphics.setColor(0, 1, 0)
                love.graphics.circle('fill', bullet.x, bullet.y, bulletRadius)
            end   
            for asteroidIndex, asteroid in ipairs(asteroids) do
                love.graphics.setColor(1, 1, 1)
            	love.graphics.draw(whale, asteroid.x, asteroid.y, 0, asteroidStages[asteroid.stage].xsize, asteroidStages[asteroid.stage].ysize) 
            	--love.graphics.circle('fill', asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius)            
            end
        end
    end



    -- Temporary
    love.graphics.origin()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(table.concat({
        'shipAngle: '..shipAngle,
        'shipX: '..shipX,
        'shipY: '..shipY,
        'shipSpeedX: '..shipSpeedX,
        'shipSpeedY: '..shipSpeedY,
        'score: '..score,
    }, '\n'))
end
--[[function love.keypressed(key)
    if key == 's' then
        table.insert(
            bullets, {
                x = shipX + math.cos(shipAngle) * shipRadius,
                y = shipY + math.sin(shipAngle) * shipRadius,
                angle = shipAngle,
                timeLeft = 4,
            }
        )
    end
end]]