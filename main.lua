function love.load()
    camera = require 'libraries.camera'
    cam = camera()
    anim8 = require 'libraries.anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setFullscreen(true)

    windowwidth = love.graphics.getWidth()

    bilba = {}
    bilba.spriteSheet = love.graphics.newImage('spritesheets/bilba.png')
    bilba.grid = anim8.newGrid(48, 48, bilba.spriteSheet:getWidth(), bilba.spriteSheet:getHeight())
    bilba.width = bilba.spriteSheet:getWidth() / 6
    bilba.height = bilba.spriteSheet:getHeight() / 6
    bilba.x = 100
    bilba.y = 100
    bilba.speed = 200
    bilba.animations = {}
    bilba.animations.idle = anim8.newAnimation(bilba.grid('1-6', 1), 0.25)
    bilba.animations.running = anim8.newAnimation(bilba.grid('1-6', 2), 0.15)

    bilba.anim = bilba.animations.idle

    bilba.imageFlipX = 1
    bilba.imageOffsetX = 0
    background = love.graphics.newImage('spritesheets/map.png')



    slime = {}
    slime.spriteSheet = love.graphics.newImage('spritesheets/slime.png')
    slime.grid = anim8.newGrid(32,32, slime.spriteSheet:getWidth(), slime.spriteSheet:getHeight())
    slime.width = slime.spriteSheet:getWidth() / 7
    slime.height = slime.spriteSheet:getHeight() / 5
    slime.x = 100
    slime.y = 100
    slime.speed = 100
    slime.animations = {}
    slime.animations.idle = anim8.newAnimation(slime.grid('1-4', 1), 0.15)
    slime.animations.running = anim8.newAnimation(slime.grid('1-7', 3), 0.15)
    slime.anim = slime.animations.idle

end
function love.draw()
    cam:attach()

        love.graphics.setColor(1,1,1)
        love.graphics.draw(background,0,0,0,2)
        bilba.anim:draw(bilba.spriteSheet, bilba.x,bilba.y,  nil, bilba.imageFlipX, 4, bilba.imageOffsetX)
        slime.anim:draw(slime.spriteSheet, slime.x,slime.y,  nil, 4)

    cam:detach()
end
function love.update(dt)
    bilba.anim:update(dt)
    slime.anim:update(dt)



    if love.keyboard.isDown("escape") then
        love.event.quit( exitstatus )
    end
    bilba.anim = bilba.animations.idle
    slime.anim = slime.animations.idle

    if CheckCollision(bilba.x,bilba.y,bilba.width,bilba.height,slime.x,slime.y,slime.width,slime.height)then
        slime.anim = slime.animations.running
        if bilba.x > slime.x then
        slime.x = slime.x + (slime.speed * dt)
        else
            slime.x = slime.x - (slime.speed * dt)
        end
        if bilba.y > slime.y then
            slime.y = slime.y + (slime.speed * dt)
            else
                slime.y = slime.y - (slime.speed * dt)
            end
    end

    local x, y = love.mouse.getPosition()

    -- Movement
    if love.keyboard.isDown("d") then
        bilba.x = bilba.x + (bilba.speed * dt)
        bilba.anim = bilba.animations.running
      end
      if love.keyboard.isDown("a") then
        bilba.x = bilba.x - (bilba.speed * dt)
        bilba.anim = bilba.animations.running

      end
      if love.keyboard.isDown("s") then
        bilba.y = bilba.y + (bilba.speed * dt)
        bilba.anim = bilba.animations.running

      end
      if love.keyboard.isDown("w") then
        bilba.y = bilba.y - (bilba.speed * dt)
        bilba.anim = bilba.animations.running

    end
    if x < windowwidth / 2 then
        bilba.imageFlipX = -4
        bilba.imageOffsetX = bilba.width --image x axis has been flipped

    else
        bilba.imageFlipX = 4
        bilba.imageOffsetX = 0

    end

    cam:lookAt(bilba.x + 95,bilba.y + 150)

end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 + 150 and
           x2 < x1+w1 + 150 and
           y1 < y2+h2 + 150 and
           y2 < y1+h1 + 150
  end