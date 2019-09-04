require "purple_soul"
require "karma"

up_croissants = {}
down_croissants = {}
r_spiders = {}
l_spiders = {}
spawntimer = 0
ActivePurple(90,45)
ActiveHorizontal()

function Update()
    PurpleUpdate()
    spawntimer = spawntimer + 1
    if spawntimer % 10 == 0 then
        local up_croissant = CreateProjectile("croissant", 250, 45)
        up_croissant.SetVar("rotation", -10)
        up_croissant.SetVar("velx", -10)
        up_croissant.SetVar("hurt", true)
        table.insert(up_croissants, up_croissant)

        local down_croissant = CreateProjectile("croissant", -250, -45)
        down_croissant.SetVar("rotation", 10)
        down_croissant.SetVar("velx", 10)
        down_croissant.SetVar("hurt", true)
        table.insert(down_croissants, down_croissant)
    end

    if spawntimer % 50 == 0 then
        spider = CreateProjectile("spider", 250, 0)
        spider.SetVar("hurt", false)
        if math.random() > 0.5 then
            spider.sprite.color32 = {252, 166, 0}
            spider.SetVar("orange", true)
            spider.SetVar("blue", false)
        else
            spider.sprite.color32 = {66, 252, 255}
            spider.SetVar("orange", false)
            spider.SetVar("blue", true)
        end
        table.insert(r_spiders, spider)
    end

    if spawntimer % 50 == 25 then  
        spider = CreateProjectile("spider", -250, 0)
        spider.SetVar("hurt", false)
        if math.random() > 0.5 then
            spider.sprite.color32 = {252, 166, 0}
            spider.SetVar("orange", true)
            spider.SetVar("blue", false)
        else
            spider.sprite.color32 = {66, 252, 255}
            spider.SetVar("orange", false)
            spider.SetVar("blue", true)
        end
        table.insert(l_spiders, spider)
    end


    for i=1, #up_croissants do
        local croissant = up_croissants[i]
        local velx = croissant.GetVar("velx")
        croissant.Move(velx, 0)
        croissant.sprite.rotation = croissant.sprite.rotation + croissant.GetVar("rotation")
        croissant.SetVar("velx", velx + 0.15)
    end

    for i=1, #r_spiders do
        local spider = r_spiders[i]
        spider.Move(-2, 0)
    end

    for i=1, #l_spiders do
        local spider = l_spiders[i]
        spider.Move(2, 0)
    end
    
    for i=1, #down_croissants do
        local croissant = down_croissants[i]
        local velx = croissant.GetVar("velx")
        croissant.Move(velx, 0)
        croissant.sprite.rotation = croissant.sprite.rotation + croissant.GetVar("rotation")
        croissant.SetVar("velx", velx - 0.15)
    end

    if spawntimer == 500 then
        EndWave()
    end
end

function OnHit(bullet)
    if bullet.GetVar("hurt") or (PurpleIsMoving() and bullet.GetVar("blue")) or (not PurpleIsMoving() and bullet.GetVar("orange")) then
        KarmaHurt()
    end
end