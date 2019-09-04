require "purple_soul"
require "karma"

spawntimer = 0
right_croissants = {}
left_croissants = {}
donuts = {}
dir = 1

ActivePurple(90, 45)
ActiveHorizontal()

function Update()
    PurpleUpdate()
    spawntimer = spawntimer + 1
    
    
    if spawntimer % 50 == 0 then
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

    if spawntimer % 100 == 0 then
        local croissant = CreateProjectile("croissant", -250, 45 * math.random(-1, 1))
        croissant.SetVar("rotation", 10)
        croissant.SetVar("velx", 10)
        croissant.SetVar("hurt", true)
        table.insert(left_croissants, croissant)
    end

    if spawntimer % 100 == 50 then
        local croissant = CreateProjectile("croissant", 250, 45 * math.random(-1, 1))
        croissant.SetVar("rotation", -10)
        croissant.SetVar("velx", -9)
        croissant.SetVar("hurt", true)
        table.insert(right_croissants, croissant)
        croissant = CreateProjectile("croissant", 250, 45 * math.random(-1, 1))
        croissant.SetVar("rotation", -10)
        croissant.SetVar("velx", -9)
        croissant.SetVar("hurt", true)
        table.insert(right_croissants, croissant)
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
            donut.Move(velx * 3, vely)
            donut.sprite.Scale(1, 0.8)
            donut.SetVar("vely", -vely)
            donut.SetVar("scaled", true)
        elseif donut.y >= Arena.height/2 - 12 and donut.GetVar("scaled") and not donut.GetVar("littled_up") then
            donut.Move(velx * 3, vely)
            donut.sprite.Scale(1, 1)
            donut.SetVar("littled_up", true)
            donut.SetVar("littled_down", false)
            donut.SetVar("scaled", false)
        elseif donut.y <= -Arena.height/2 + 12 and not donut.GetVar("littled_down") and not donut.GetVar("scaled") then
            donut.Move(velx * 3, vely)
            donut.sprite.Scale(1, 0.8)
            donut.SetVar("vely", -vely)
            donut.SetVar("scaled", true)
        elseif donut.y <= Arena.height/2 + 12 and donut.GetVar("scaled") and not donut.GetVar("littled_down") then
            donut.Move(velx * 3, vely)
            donut.sprite.Scale(1, 1)
            donut.SetVar("littled_up", false)
            donut.SetVar("littled_down", true)
            donut.SetVar("scaled", false)
        else
            donut.Move(velx * 3, vely * 3)
        end
    end

    if spawntimer == 500 then
        EndWave()
    end
end

function OnHit(bullet)
    if bullet.GetVar("hurt") then
        KarmaHurt()
    end
end