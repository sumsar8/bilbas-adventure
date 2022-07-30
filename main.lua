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
    bilba.x = 1000
    bilba.y = 1000
    bilba.speed = 200
    bilba.animations = {}
    bilba.animations.idle = anim8.newAnimation(bilba.grid('1-6', 1), 0.25)
    bilba.animations.running = anim8.newAnimation(bilba.grid('1-6', 2), 0.15)
    bilba.animations.swing = anim8.newAnimation(bilba.grid('1-4', 3), 0.15)
    bilba.anim = bilba.animations.idle

    bilba.imageFlipX = 1
    bilba.imageOffsetX = 0
    bilba.health = 100
    background = love.graphics.newImage('spritesheets/map.png')



    slime = {}
    slime.spriteSheet = love.graphics.newImage('spritesheets/slime.png')
    slime.grid = anim8.newGrid(32,32, slime.spriteSheet:getWidth(), slime.spriteSheet:getHeight())
    slime.width = slime.spriteSheet:getWidth() / 7
    slime.height = slime.spriteSheet:getHeight() / 5
    slime.x = 400
    slime.y = 400
    slime.speed = 100
    slime.aggro = false
    slime.animations = {}
    slime.animations.idle = anim8.newAnimation(slime.grid('1-4', 1), 0.15)
    slime.animations.running = anim8.newAnimation(slime.grid('1-7', 3), 0.15)
    slime.anim = slime.animations.idle
end
function love.draw()
    cam:attach()

        love.graphics.setColor(1,1,1)
        love.graphics.draw(background,0,0,0,5)
        bilba.anim:draw(bilba.spriteSheet, bilba.x,bilba.y,  nil, bilba.imageFlipX, 4, bilba.imageOffsetX)
        slime.anim:draw(slime.spriteSheet, slime.x,slime.y,  nil, 4)
        love.graphics.setColor(0,0,0)

        love.graphics.rectangle("line",bilba.x - 851,bilba.y - 351,202, 27)
        if bilba.health > 0 then
            if bilba.health < 30 then
                love.graphics.setColor(1,0,0)
                love.graphics.rectangle("fill",bilba.x - 850,bilba.y - 350, bilba.health * 2,25)
            else
                love.graphics.setColor(0.5,1,0)
                love.graphics.rectangle("fill",bilba.x - 850,bilba.y - 350, bilba.health * 2,25)
            end
        end

        --love.graphics.print(hyp,100,100)
    cam:detach()
end
function love.update(dt)
    bilba.anim:update(dt)
    slime.anim:update(dt)


    local dirx = bilba.x + bilba.width / 2 - slime.x
    local diry = bilba.y + bilba.height - slime.y
    local hyp = math.sqrt(dirx*dirx + diry*diry)

    dirx = dirx / hyp
    diry = diry / hyp
    if love.keyboard.isDown("escape") then
        love.event.quit( exitstatus )
    end
    bilba.anim = bilba.animations.idle
    slime.anim = slime.animations.idle

     if CheckDetection(bilba.x,bilba.y,bilba.width,bilba.height,slime.x,slime.y,slime.width,slime.height)then
        slime.anim = slime.animations.running
        if CheckCollision(bilba.x,bilba.y,bilba.width,bilba.height,slime.x,slime.y,slime.width,slime.height)then
            bilba.health = bilba.health - 0.5
        end
        slime.x = slime.x + (dirx * slime.speed * dt)
        slime.y = slime.y + (diry * slime.speed * dt)
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
        bilba.imageOffsetX = bilba.width

    else
        bilba.imageFlipX = 4
        bilba.imageOffsetX = 0

    end
    if love.mouse.isDown(1) then
        bilba.anim = bilba.animations.swing
    end
    cam:lookAt(bilba.x + 95,bilba.y + 150)

end

function CheckDetection(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 + 150 and
           x2 < x1+w1 + 150 and
           y1 < y2+h2 + 150 and
           y2 < y1+h1 + 150
  end
  function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
  end