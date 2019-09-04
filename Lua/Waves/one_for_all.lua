require "karma"
require "purple_soul"

donuts = {}
spiders = {}
right_croissants = {}
left_croissants = {}
spawntimer = 0
place = -1
dir = -1
turn = 1

flash = CreateSprite("flash","Top")
flash.x = 320
flash.y = 240
flash.alpha = 0

ActivePurple(90, 45)
ActiveHorizontal()

function Update()
    PurpleUpdate()
    spawntimer = spawntimer + 1
    
    if spawntimer % 35 == 0 then
        spider = CreateProjectile("spider", 250 * place, 45 * math.random(-1, 1))
        place = -place
        spider.SetVar("velx", place * 4)
        spider.SetVar("hurt", true)
        table.insert(spiders, spider)
    end

    if spawntimer % 100 == 0 then
        local w = math.random(-4,4)
        blaster = CreateProjectile("blasters/0", 1000, 100 * turn)
        blaster.SetVar("width",w)
        Audio.PlaySound("charging_blaster")
        turn = -turn
    end

    if spawntimer % 100 <= 25 and spawntimer > 100 then
        local var = -((spawntimer % 100) / 25 * math.pi - math.pi/2)
        blaster.MoveToAbs(math.sin(var) * 500 + 500 + 45 * blaster.GetVar("width") + 320, 160 - turn * 150)
        blaster.sprite.rotation = turn * spawntimer * 90 / 25 + 90
    end

    if spawntimer % 100 == 27 and spawntimer > 100 then
        blaster.sprite.Set("blasters/1")
    end

    if spawntimer % 100 == 29 and spawntimer > 100 then
        blaster.sprite.Set("blasters/2")
    end

    if spawntimer % 100 == 30 and spawntimer > 100 then
        flash.alpha = 0.5
    end

    if spawntimer % 100 == 31 and spawntimer > 100 then
        blaster.sprite.Set("blasters/3")
        flash.alpha = 1
        Audio.PlaySound("echo")
        laser = CreateProjectile("laser/0", blaster.x, turn * 510)
        laser.sprite.rotation = 90
        laser.SetVar("hurt", true)
    end

    if spawntimer % 100 <= 55 and spawntimer > 100 and spawntimer%100 > 41 then
        blaster.Move(0, -turn * (1.5^(spawntimer%100 - 41)))
        laser.Move(0, -turn * (1.5^(spawntimer%100 - 41)))
        flash.alpha = flash.alpha - 1/9
    end

    if spawntimer % 100 <= 55 and spawntimer > 100 and spawntimer%100 > 46 then
        laser.sprite.Set("laser/"..spawntimer%100 - 46)
    end

    if spawntimer%100 == 55 and spawntimer > 100 then
        blaster.remove()
        laser.remove()
    end
    
    if spawntimer % 75 == 32 then
        local donut = CreateProjectile("donut", dir * (200 + math.random(-1, 1) * 30), 0)
        dir = -dir
        donut.SetVar("velx", dir)
        donut.SetVar("littled_up", false)
        donut.SetVar("littled_down", false)
        donut.SetVar("scaled", false)
        donut.SetVar("hurt", true)
        if math.random() > 0.5 then
            donut.SetVar("vely", 1)
        else
            donut.SetVar("vely", -1)
        end
        table.insert(donuts, donut)
    end

    if spawntimer % 150 == 0 then
        local croissant = CreateProjectile("croissant", -250, 45 * math.random(-1, 1))
        croissant.SetVar("rotation", 10)
        croissant.SetVar("velx", 9)
        croissant.SetVar("hurt", true)
        table.insert(left_croissants, croissant)
    end

    if spawntimer % 150 == 75 then
        local croissant = CreateProjectile("croissant", 250, 45 * math.random(-1, 1))
        croissant.SetVar("rotation", -10)
        croissant.SetVar("velx", -9)
        croissant.SetVar("hurt", true)
        table.insert(right_croissants, croissant)
    end



    for i=1, #spiders do
        local spider = spiders[i]
        local velx = spider.GetVar("velx")
        spider.Move(velx, 0)
    end

    for i=1, #right_croissants do
        local croissant = right_croissants[i]
        local velx = croissant.GetVar("velx")
        croissant.Move(velx, 0)
        croissant.sprite.rotation = croissant.sprite.rotation + croissant.GetVar("rotation")
        croissant.SetVar("velx", velx + 0.15)
    end

    for i=1, #left_croissants do
        local croissant = left_croissants[i]
        local velx = croissant.GetVar("velx")
        croissant.Move(velx, 0)
        croissant.sprite.rotation = croissant.sprite.rotation + croissant.GetVar("rotation")
        croissant.SetVar("velx", velx - 0.15)
    end

    
    for i=1, #donuts do
        local donut = donuts[i]
        local velx = donut.GetVar("velx")
        local vely = donut.GetVar("vely")
        
        if donut.y >= Arena.height/2 - 12 and not donut.GetVar("littled_up") and not donut.GetVar("scaled") then
            donut.Move(velx * 5, vely)
            donut.sprite.Scale(1, 0.8)
            donut.SetVar("vely", -vely)
            donut.SetVar("scaled", true)
        elseif donut.y >= Arena.height/2 - 12 and donut.GetVar("scaled") and not donut.GetVar("littled_up") then
            donut.Move(velx * 5, vely)
            donut.sprite.Scale(1, 1)
            donut.SetVar("littled_up", true)
            donut.SetVar("littled_down", false)
            donut.SetVar("scaled", false)
        elseif donut.y <= -Arena.height/2 + 12 and not donut.GetVar("littled_down") and not donut.GetVar("scaled") then
            donut.Move(velx * 5, vely)
            donut.sprite.Scale(1, 0.8)
            donut.SetVar("vely", -vely)
            donut.SetVar("scaled", true)
        elseif donut.y <= Arena.height/2 + 12 and donut.GetVar("scaled") and not donut.GetVar("littled_down") then
            donut.Move(velx * 5, vely)
            donut.sprite.Scale(1, 1)
            donut.SetVar("littled_up", false)
            donut.SetVar("littled_down", true)
            donut.SetVar("scaled", false)
        else
            donut.Move(velx * 5, vely * 3)
        end
    end

    if spawntimer == 600 then
        EndWave()
    end
end

function OnHit(bullet)
    if bullet.GetVar("hurt") then 
        KarmaHurt()
    end
end