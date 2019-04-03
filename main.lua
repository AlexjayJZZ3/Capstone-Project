function love.load()
	whale = love.graphics.newImage("asteroid-icon.png")
	whale1 = love.graphics.newImage("win.png")
	arenaWidth = 800
    arenaHeight = 600
    bulletRadius = 5
    shipRadius = 30
    game_over = false
    asteroidStages = {
        {
            speed = 120,
            radius = 15,
            xsize = 0.125,
            ysize = 0.125
        },
        {
            speed = 70,
            radius = 30,
            xsize = 0.25,
            ysize = 0.25
        },
        {
            speed = 50,
            radius = 50,
            xsize = 0.5,
            ysize = 0.5
        },
        {
            speed = 20,
            radius = 80,
            xsize = 1,
            ysize = 1
        }
    }
	function reset()

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
	for asteroidIndex, asteroid in ipairs(asteroids) do
        asteroid.x = (asteroid.x + math.cos(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % arenaWidth
        asteroid.y = (asteroid.y + math.sin(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % arenaHeight

        if areCirclesIntersecting(shipX, shipY, shipRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then
            reset()
            break
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
	if #asteroids == 0 then
		game_over = true
		love.timer.sleep(3)
        reset()
    end
end

function love.draw()
	if game_over == true then
		love.graphics.draw(whale1,0,0)
    end
	for y = -1, 1 do
        for x = -1, 1 do
            love.graphics.origin()
            love.graphics.translate(x * arenaWidth, y * arenaHeight)
    love.graphics.setColor(0, 0, 1)
    love.graphics.circle('fill', shipX, shipY, shipRadius)

    love.graphics.setColor(0, 1, 1)
    --local shipCircleDistance = 20
    love.graphics.circle('fill', shipX + math.cos(shipAngle) * 20, shipY + math.sin(shipAngle) * 20, 5)

            -- etc.

            for bulletIndex, bullet in ipairs(bullets) do
                love.graphics.setColor(0, 1, 0)
                love.graphics.circle('fill', bullet.x, bullet.y, bulletRadius)
            end   
            for asteroidIndex, asteroid in ipairs(asteroids) do
            	love.graphics.draw(whale, asteroid.x, asteroid.y, 0, asteroidStages[asteroid.stage].xsize, asteroidStages[asteroid.stage].ysize)   
            	--love.graphics.draw(whale, asteroid.x, asteroid.y, 0,50, 50) 
                love.graphics.setColor(1, 1, 1)
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