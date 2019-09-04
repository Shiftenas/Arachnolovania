require "karma"

Player.SetControlOverride(true)
Arena.ResizeImmediate(16, 16)
final_hidder = CreateSprite("arena_final_hidder", "BelowPlayer")
final_hidder.x = Arena.x
final_hidder.y = Arena.y + Arena.height/2

cute_spiders = {}
l_croissants = {}
r_croissants = {}
blasters = {}
lasers = {}

spawntimer = 0
blastertimer = 0
blaster_y = 0
blaster_x = 0
blaster = nil
active_blaster = false

flash = CreateSprite("flash", "Top")
flash.x = 320
flash.y = 240
flash.alpha = 0

function Update()
    UpdatePlayer()
    UpdateBlaster()
    UpdateCreatedBlasters()
    if Player.absy > 400 and spawntimer < 390 then
        active_blaster = true
    end
    spawntimer = spawntimer + 1
    if spawntimer == 1 then
        warn = CreateProjectileAbs("warn_1", 600, 60)
    end
    if spawntimer < 40 and spawntimer % 2 == 0 then
        warn.sprite.Set("warn_"..(spawntimer/2+1)%2+1)
        Audio.PlaySound("warning")
    end
    if spawntimer == 40 then
        warn.remove()
    end
    if spawntimer > 40 and spawntimer < 350 and spawntimer % 20 == 0 then
        local c_spider = CreateProjectileAbs("cute_spider1", 600, 55)
        c_spider.sprite.Scale(2, 2)
        c_spider.SetVar("hurt", true)
        c_spider.SetVar("actual", 1)
        c_spider.SetVar("sprite_timer", 0)
        c_spider.SetVar("vely", 0)
        c_spider.SetVar("jumping", false)
        table.insert(cute_spiders, c_spider)
    end

    if spawntimer >= 180 and spawntimer < 350 and spawntimer % 60 == 0 then
        local croissant = CreateProjectileAbs("croissant", 0, math.random(150, 350))
        croissant.SetVar("rotation", 10)
        croissant.SetVar("velx", 15)
        croissant.SetVar("vely", 8)
        croissant.SetVar("hurt", true)
        table.insert(l_croissants, croissant)
    end

    if spawntimer > 180 and spawntimer < 350 and spawntimer % 60 == 30 then
        local croissant = CreateProjectileAbs("croissant", 640, math.random(150, 350))
        croissant.SetVar("rotation", -10)
        croissant.SetVar("velx", -15)
        croissant.SetVar("vely", 8)
        croissant.SetVar("hurt", true)
        table.insert(r_croissants, croissant)
    end

    if spawntimer > 400 and spawntimer < 640 and spawntimer%30 == 0 then
        SpawnBlaster()
    end

    if spawntimer == 640 then
        cupcake = CreateProjectileAbs("cupcake/cupcake1", 10, 240)
        cupcake.ppcollision = true
        cupcake.sprite.Scale(2, 2)
        cupcake.sprite.rotation = -90
        cupcake.SetVar("iscupcake", true)
        local x = 660
        local starty = 8
        spiders = CreateProjectileAbs("spider_wall", 1000, 240)
        spiders.SetVar("hurt", true)
    end

    if spawntimer > 640 and spawntimer < 1240 then
        spiders.Move(-1, 0)
        if spawntimer % 80 == 0 then
            cupcake.sprite.Set("cupcake/cupcake1")
        elseif spawntimer % 80 == 20 then
            cupcake.sprite.Set("cupcake/cupcake2")
        elseif spawntimer % 80 == 40 then
            cupcake.sprite.Set("cupcake/cupcake3")
        elseif spawntimer % 80 == 60 then
            cupcake.sprite.Set("cupcake/cupcake4")
        end
    end

    for i=1, #cute_spiders do
        local spider = cute_spiders[i]
        local timer = spider.GetVar("sprite_timer")
        if spider.isactive then
            if timer % 5 == 0 then
                spider.SetVar("actual", spider.GetVar("actual") % 2 + 1)
                spider.sprite.Set("cute_spider"..spider.GetVar("actual"))
            end
            if spider.absx <= 550 and spider.absx > 500 and not spider.GetVar("jumping") then
                spider.SetVar("vely", 5)
                spider.SetVar("jumping", true)
            end
            if spider.absx <= Player.absx + 50 and spider.absx > Player.absx and not spider.GetVar("jumping") then
                spider.SetVar("vely", math.random(4, 50)/4)
                spider.SetVar("jumping", true)
            end
            spider.Move(-2, spider.GetVar("vely"))
            if spider.GetVar("jumping") then
                spider.SetVar("vely", spider.GetVar("vely") - 0.25)
            end
            if spider.absy <= 105 and spider.GetVar("jumping") and spider.GetVar("vely") < 0 then
                spider.SetVar("vely", 0)
                spider.MoveToAbs(spider.absx, 105)
                spider.SetVar("jumping", false)
            end
            if spider.absx < -10 then spider.remove() end
        end
    end

    for i=1, #l_croissants do
        local croissant = l_croissants[i]
        local velx = croissant.GetVar("velx")
        local vely = croissant.GetVar("vely")
        croissant.Move(velx, vely)
        croissant.sprite.rotation = croissant.sprite.rotation + croissant.GetVar("rotation")
        croissant.SetVar("velx", velx - 0.25)
        croissant.SetVar("vely", vely - 0.2)
    end

    for i=1, #r_croissants do
        local croissant = r_croissants[i]
        local velx = croissant.GetVar("velx")
        local vely = croissant.GetVar("vely")
        croissant.Move(velx, vely)
        croissant.sprite.rotation = croissant.sprite.rotation + croissant.GetVar("rotation")
        croissant.SetVar("velx", velx + 0.25)
        croissant.SetVar("vely", vely - 0.2)
    end

    if spawntimer == 1250 then
        Arena.ResizeImmediate(575, 130)
        final_hidder.remove()
        Encounter.Call("DoSetHidders")
        EndWave()
    end
end

function UpdateBlaster()
    if active_blaster then
        if blastertimer == 0 then
            blaster_y = Player.absy
            blaster_x = 520
            if Player.absx > 320 then
                blaster_x = 120
            end
        end
        if blastertimer == 8 then
            Audio.PlaySound("charging_blaster")
            blaster = CreateProjectileAbs("blasters/0", blaster_x, blaster_y)
            if blaster_x == 120 then
                blaster.sprite.rotation = 90
            else 
                blaster.sprite.rotation = -90
            end
        end
        if blastertimer == 12 then
            blaster.sprite.Set("blasters/1")
        end
        if blastertimer == 16 then
            blaster.sprite.Set("blasters/2")
        end
        if blastertimer > 18 and blastertimer <= 20 then
            flash.alpha = flash.alpha + 0.5
        end
        if blastertimer == 20 then
            blaster.sprite.Set("blasters/3")
            local laser_x = -170
            if blaster_x == 120 then
                laser_x = 810
            end
            Audio.PlaySound("echo")
            laser = CreateProjectileAbs("laser/0", laser_x, blaster_y)
            laser.SetVar("hurt", true)
        end
        if blastertimer > 20 and blastertimer <= 30 then
            flash.alpha = flash.alpha - 0.1
        end
        if blastertimer > 20 and blastertimer < 50 and (blastertimer-20)%3 == 0 then
            laser.sprite.Set("laser/"..(blastertimer-20)/3)
        end
        if blastertimer > 20 and blastertimer < 40 then
            local velx = 10
            if blaster_x == 120 then 
                velx = -10
            end
            blaster.Move(velx, 0)
            laser.Move(velx, 0)
        end
        if blastertimer == 50 then 
            laser.remove()
            blaster.remove()
        end
        blastertimer = blastertimer + 1
        if blastertimer == 100 then
            blastertimer = 0
            active_blaster = false
        end
    end
end

function SpawnBlaster()
    local bx = math.random(120, 300)
    local by = math.random(100, 200)
    if math.random() > 0.5 then
        bx = 320 - bx
    else
        bx = 320 + bx
    end
    if math.random() > 0.5 then
        by = 240 - by
    else
        by = 240 + by
    end
    local dist = math.sqrt((Player.absx - bx)^2 + (Player.absy - by)^2)
    local x = Player.absx - bx
    local y = Player.absy - by
    local angle = 0
    if dist != 0 then
        dist = math.sqrt(x * x + y * y)
        angle = math.asin(y/dist)
    end

    local blaster = CreateProjectileAbs("blasters/0", bx + 900 * math.cos(angle), by + 900 * math.sin(angle))
    if x < 0 then
        blaster.sprite.rotation = -angle / math.pi * 180 - 90
    else
        blaster.sprite.rotation = angle / math.pi * 180 + 90
    end
    if x < 0 then
        blaster.SetVar("angle", -angle)
    else
        blaster.SetVar("angle", angle)
    end
    blaster.SetVar("bx", bx) 
    blaster.SetVar("localx", x)
    blaster.SetVar("by", by)
    blaster.SetVar("timer", 0)
    table.insert(blasters, blaster)
end

function UpdateCreatedBlasters()
    for i=1, #blasters do
        local blaster = blasters[i]
        local timer = blaster.GetVar("timer") + 1
        local x = blaster.GetVar("localx")
        local bx = blaster.GetVar("bx")
        local by = blaster.GetVar("by")
        local angle = blaster.GetVar("angle")
        if timer <= 45 then
            if x < 0 then
                blaster.MoveToAbs(
                    bx + (900 - 20*timer) * math.cos(angle),
                    by + (900 - 20*timer) * math.sin(angle)
                )
            else
                blaster.MoveToAbs(
                    bx - (900 - 20*timer) * math.cos(angle),
                    by - (900 - 20*timer) * math.sin(angle)
                )
            end
        elseif timer == 48 then
            blaster.sprite.Set("blasters/1")
        elseif timer == 51 then
            blaster.sprite.Set("blasters/2")
        elseif timer == 54 then
            blaster.sprite.Set("blasters/3")
            local multiplier = 690
            if x < 0 then
                multiplier = - 690
            end
            local laser = CreateProjectileAbs("laser/0", bx + multiplier * math.cos(angle), by + multiplier * math.sin(angle))
            laser.ppcollision = true
            laser.sprite.rotation = angle / math.pi * 180
            laser.SetVar("hurt", true)
            laser.SetVar("timer", 0)
            laser.SetVar("x", x)
            laser.SetVar("angle", angle)
            table.insert(lasers, laser)
        end
        if timer > 54 and timer < 62 then
            if x > 0 then
                blaster.Move(
                    -20 * math.cos(angle),
                    -20 * math.sin(angle)
                )
            else
                blaster.Move(
                    20 * math.cos(angle),
                    20 * math.sin(angle)
                )
            end
        elseif timer == 65 then
            blaster.remove()
        end
        blaster.SetVar("bx", bx)
        blaster.SetVar("by", by)
        blaster.SetVar("angle", angle)
        blaster.SetVar("timer", timer)
    end

    for i=1, #lasers do
        local laser = lasers[i]
        local timer = laser.GetVar("timer") + 1
        local angle = laser.GetVar("angle")
        local x = laser.GetVar("x")
        if laser.isactive then
            if timer % 4 == 0 then
                laser.sprite.Set("laser/"..timer/4)
            end
            if timer < 10 then
                if x > 0 then
                    laser.Move(
                        -20 * math.cos(angle),
                        -20 * math.sin(angle)
                    )
                else
                    laser.Move(
                        20 * math.cos(angle),
                        20 * math.sin(angle)
                    )
                end
            end
            if timer == 39 then
                laser.remove()
            end
        end
        laser.SetVar("timer", timer)
    end
end

function UpdatePlayer()
    moving = false
    if Input.Up >= 1 then 
        if Input.Down >= 1 then
            movey = 0
        else
            movey = Input.Up
        end
    elseif Input.Down >= 1 then
        movey = -Input.Down
    else
        movey = 0
    end
    if Input.Left >= 1 then 
        if Input.Right >= 1 then
            movex = 0
        else
            movex = -Input.Left
        end
    elseif Input.Right >= 1 then
        movex = Input.Right
    else
        movex = 0
    end
    if movex != 0 or movey != 0 then
        moving = true
    end
    Player.Move(movex, movey, true)
end

function OnHit(bullet)
    if bullet.GetVar("iscupcake") then
        Player.hp = 0
    elseif bullet.GetVar("hurt") then
        KarmaHurt()
    end
end