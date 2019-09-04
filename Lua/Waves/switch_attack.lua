require "purple_soul"
require "karma"

hidder = CreateSprite("flash", "Top")
hidder.x = 320
hidder.y = 240
hidder.color = {0, 0, 0, 0}

ActivePurple(90, 45)
ActiveHorizontal()

spiders = {}
donuts = {}
left_croissants = {}
right_croissants = {}
dir = -1

spawntimer = 0

function Update()
    PurpleUpdate()
    spawntimer = spawntimer + 1
    if spawntimer == 1 then 
        hidder.alpha = 1
        Audio.Pause()
        Audio.PlaySound("switch")
    end

    if spawntimer == 11 then
        Audio.Play()
        hidder.alpha = 0
        Audio.PlaySound("switch")
        spider = CreateProjectile("spider", 250, 0)
        spider.SetVar("hurt", true)
        spider2 = CreateProjectile("spider", -250, 0)
        spider2.SetVar("hurt", true)
        local startx = -90
        for i=1, 7 do
            local spider = CreateProjectile("spider", startx, -45)
            spider.SetVar("hurt", true)
            table.insert(spiders, spider)

            local spider = CreateProjectile("spider", startx, 45)
            spider.SetVar("hurt", true)
            table.insert(spiders, spider)

            startx = startx + 30
        end
    end

    if spawntimer >= 11 and spawntimer < 26 then
        spider.Move(-15, 0)
        spider2.Move(15, 0)
    end

    if spawntimer == 26 then
        Audio.Pause()
        hidder.alpha = 1
        Audio.PlaySound("switch")

        spider.remove()
        spider2.remove()

        for i=1, 14 do
            spiders[i].remove()
        end
    end

    if spawntimer == 36 then
        RemoveHorizontal()
        Audio.Play()
        hidder.alpha = 0
        Audio.PlaySound("switch")
        local random = math.random(1,6)
        
        if random != 1 then
            local croissant = CreateProjectile("croissant", -250, 45)
            croissant.SetVar("velx", 9)
            croissant.SetVar("rotation", 10)
            croissant.SetVar("hurt", true)
            table.insert(left_croissants, croissant)
        end
        
        if random != 2 then
            local croissant = CreateProjectile("croissant", -250, 0)
            croissant.SetVar("velx", 9)
            croissant.SetVar("rotation", 10)
            croissant.SetVar("hurt", true)
            table.insert(left_croissants, croissant)
        end
        
        if random != 3 then
            local croissant = CreateProjectile("croissant", -250, -45)
            croissant.SetVar("velx", 9)
            croissant.SetVar("rotation", 10)
            croissant.SetVar("hurt", true)
            table.insert(left_croissants, croissant)
        end
        
        if random != 4 then
            local croissant = CreateProjectile("croissant", 250, 45)
            croissant.SetVar("velx", -9)
            croissant.SetVar("rotation", -10)
            croissant.SetVar("hurt", true)
            table.insert(right_croissants, croissant)
        end
        
        if random != 5 then
            local croissant = CreateProjectile("croissant", 250, 0)
            croissant.SetVar("velx", -9)
            croissant.SetVar("rotation", -10)
            croissant.SetVar("hurt", true)
            table.insert(right_croissants, croissant)
        end
        
        if random != 6 then
            local croissant = CreateProjectile("croissant", 250, -45)
            croissant.SetVar("velx", -9)
            croissant.SetVar("rotation", -10)
            croissant.SetVar("hurt", true)
            table.insert(right_croissants, croissant)
        end
    end

    if spawntimer == 90 then
        Audio.Pause()
        hidder.alpha = 1
        Audio.PlaySound("switch")

        for i=1, #left_croissants do
            left_croissants[i].remove()
        end

        for i=1, #right_croissants do
            right_croissants[i].remove()
        end
    end

    if spawntimer == 100 then
        ActivePurple(90, 45)
        ActiveHorizontal()
        Audio.Play()
        hidder.alpha = 0
        Audio.PlaySound("switch")
    end

    if spawntimer >= 100 and spawntimer < 130 then
        if spawntimer % 3 == 0 then
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
    end

    if spawntimer == 180 then
        Audio.Pause()
        hidder.alpha = 1
        Audio.PlaySound("switch")

        for i=1, #donuts do
            donuts[i].remove()
        end
    end

    if spawntimer == 190 then
        Audio.Play()
        Audio.PlaySound("switch")
        hidder.remove()
        EndWave()
    end


    for i=1, #right_croissants do
        local croissant = right_croissants[i]
        local velx = croissant.GetVar("velx")
        if croissant.isactive then
            croissant.Move(velx, 0)
            croissant.sprite.rotation = croissant.sprite.rotation + croissant.GetVar("rotation")
            croissant.SetVar("velx", velx + 0.15)
        end
    end

    for i=1, #left_croissants do
        local croissant = left_croissants[i]
        local velx = croissant.GetVar("velx")
        if croissant.isactive then
            croissant.Move(velx, 0)
            croissant.sprite.rotation = croissant.sprite.rotation + croissant.GetVar("rotation")
            croissant.SetVar("velx", velx - 0.15)
        end
    end

    
    for i=1, #donuts do
        local donut = donuts[i]
        local velx = donut.GetVar("velx")
        local vely = donut.GetVar("vely")
        if donut.isactive then
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
    end
end

function OnHit(bullet)
    if bullet.GetVar("hurt") then
        KarmaHurt()
    end
end