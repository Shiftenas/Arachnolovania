require "purple_soul"
require "karma"

ActivePurple(90,45)
ActiveHorizontal()
spawnwavetimer = 0
spiders = {}
turn = 1
flash = CreateSprite("flash","Top")
flash.x = 320
flash.y = 240
flash.alpha = 0


blaster_right = CreateProjectile("blasters/0",150,200)
blaster_left = CreateProjectile("blasters/0",-150,200)

function Update()
    spawnwavetimer = spawnwavetimer + 1
    PurpleUpdate()

    for i=1,#spiders do
        local spider = spiders[i]
        local angle = spider.GetVar("angle")
        local velx = math.cos(angle)
        local vely = math.sin(angle)
        spider.Move(-velx*1.5,-vely*1.5)
    end

    left_x = -150 - Player.x
    right_x = 150 - Player.x
    both_y = 200 - Player.y

    right_dist = math.sqrt(right_x * right_x + both_y * both_y)
    right_angle = math.asin(both_y/right_dist) / math.pi * 180
    blaster_right.sprite.rotation = right_angle - 90

    left_dist = math.sqrt(left_x * left_x + both_y * both_y)
    left_angle = math.asin(both_y/left_dist) / math.pi * 180
    blaster_left.sprite.rotation = - (left_angle - 90)

    if spawnwavetimer % 100 == 0 then
        local h = math.random(-1,1)
        blaster = CreateProjectile("blasters/0", turn * 220, h * 45 + 500)
        blaster.SetVar("height",h)
        Audio.PlaySound("charging_blaster")
        turn = -turn
    end

    if spawnwavetimer % 100 <= 25 and spawnwavetimer > 100 then
        local var = -((spawnwavetimer % 100) / 25 * math.pi - math.pi/2)
        blaster.MoveTo(math.cos(var)*5 - turn * 220, math.sin(var) * 500 + 500 + 45 * blaster.GetVar("height"))
        blaster.sprite.rotation = turn * spawnwavetimer * 90 / 25
    end

    if spawnwavetimer % 100 == 27 and spawnwavetimer > 100 then
        blaster.sprite.Set("blasters/1")
    end

    if spawnwavetimer % 100 == 29 and spawnwavetimer > 100 then
        blaster.sprite.Set("blasters/2")
    end

    if spawnwavetimer % 100 == 30 and spawnwavetimer > 100 then
        flash.alpha = 0.5
    end

    if spawnwavetimer % 100 == 31 and spawnwavetimer > 100 then
        blaster.sprite.Set("blasters/3")
        flash.alpha = 1
        Audio.PlaySound("echo")
        laser = CreateProjectile("laser/0", turn * 450, blaster.y)
        laser.SetVar("hurt", true)
    end

    if spawnwavetimer % 100 <= 50 and spawnwavetimer > 100 and spawnwavetimer%100 > 41 then
        blaster.Move(-turn * (1.5^(spawnwavetimer%100 - 41)), 0)
        laser.Move(-turn * (1.5^(spawnwavetimer%100 - 41)), 0)
        flash.alpha = flash.alpha - 1/9
    end

    if spawnwavetimer % 100 <= 60 and spawnwavetimer > 100 and spawnwavetimer%100 > 51 then
        laser.sprite.Set("laser/"..spawnwavetimer%100 - 51)
    end

    if spawnwavetimer%100 == 50 and spawnwavetimer > 100 then
        blaster.remove()
        laser.remove()
    end
    
    if spawnwavetimer % 40 == 5 then
        blaster_right.sprite.Set("blasters/1")
        blaster_left.sprite.Set("blasters/1")
    end

    if spawnwavetimer % 40 == 10 then
        blaster_right.sprite.Set("blasters/2")
        blaster_left.sprite.Set("blasters/2")
    end

    if spawnwavetimer % 40 == 15 then
        blaster_right.sprite.Set("blasters/3")
        blaster_left.sprite.Set("blasters/3")

        local angle = (blaster_left.sprite.rotation + 90) / 180 * math.pi
        local velx = math.cos(angle)
        local vely = math.sin(angle)
        spider_left = CreateProjectile("spider", -150 - 50 * velx, 200 - 50 * vely)
        spider_left.sprite.rotation = blaster_left.sprite.rotation
        spider_left.SetVar("hurt", true)
        spider_left.SetVar("angle", angle)
        
        local angle = (blaster_right.sprite.rotation + 90) / 180 * math.pi
        local velx = math.cos(angle)
        local vely = math.sin(angle)
        spider_right = CreateProjectile("spider", 150 - 50 * velx, 200 - 50 * vely)
        spider_right.sprite.rotation = blaster_right.sprite.rotation
        spider_right.SetVar("hurt", true)
        spider_right.SetVar("angle", angle)

        table.insert(spiders, spider_left)
        table.insert(spiders, spider_right)
    end
    
    if spawnwavetimer % 40 == 20 then
        blaster_right.sprite.Set("blasters/2")
        blaster_left.sprite.Set("blasters/2")
    end
    
    if spawnwavetimer % 40 == 25 then
        blaster_right.sprite.Set("blasters/1")
        blaster_left.sprite.Set("blasters/1")
    end

    if spawnwavetimer % 40 == 30 then
        blaster_right.sprite.Set("blasters/0")
        blaster_left.sprite.Set("blasters/0")
    end

    if spawnwavetimer == 600 then
        RemoveHorizontal()
        EndWave()
    end
end

function OnHit(bullet)
    if bullet.GetVar("hurt") then
        KarmaHurt()
    end
end