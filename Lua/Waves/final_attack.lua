require "karma"

Player.SetControlOverride(true)
Arena.Move(0, 500, false, true)

spiders = {}
cute_spiders = {}
l_croissants = {}
r_croissants = {}
spawntimer = 0
blastertimer = 0
blaster_y = 0
blaster = nil
active_blaster = false

function Update()
    UpdatePlayer()
    UpdateBlaster()
    if Player.absy > 400 then
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
end

function UpdateBlaster()
    if active_blaster then
        if blastertimer == 0 then
            blaster_y = Player.absy
        end
        local blaster_x = 520
        if Player.absx > 320 then
            blaster_x = 120
        end
        if blastertimer == 8 then
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
        if blastertimer == 20 then
            blaster.sprite.Set("blasters/3")
            local laser_x = -170
            if blaster_x == 120 then
                laser_x = 810
            end
            laser = CreateProjectileAbs("laser/0", laser_x, blaster_y)
            laser.SetVar("hurt", true)
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
    if bullet.GetVar("hurt") then
        KarmaHurt()
    end
end