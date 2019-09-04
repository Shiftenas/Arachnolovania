require "purple_soul"
require "cupcake_purple_soul"
Encounter['wavetimer'] = 30.0
spawnwavetimer = 0
-- spawnwavetimer = 299
spiders_phase_1 = {}
spiders_phase_2 = {}

ActivePurple(90, 45)
ActiveHorizontal()

function Update()
    PurpleUpdate()
    spawnwavetimer = spawnwavetimer + 1
    if spawnwavetimer < 10 then
        Arena.Move(-15, 0)
    end
    if spawnwavetimer > 1 and spawnwavetimer < 11 then
        MoveHWebs(-15, 0)
    end
    if spawnwavetimer >= 10 and spawnwavetimer < 250 then
        Arena.Move(15/24, math.sin((spawnwavetimer - 10)/22.5*math.pi) * 3)
        MoveHWebs(15/24, math.sin((spawnwavetimer - 10)/22.5*math.pi) * 3)
        if spawnwavetimer%9 == 0 then
            local posx = 250
            local posy = math.random(-1, 1) * 45
            local spider = CreateProjectile("spider", posx, posy)
            spider.SetVar("hurt", true)
            table.insert(spiders_phase_1, spider)
        end
    elseif spawnwavetimer == 250 then
        Arena.Resize(340, 130)
        Arena.Move(60, 0, false)
        cupcake = CreateSprite("cupcake/cupcake_appear1", "BelowBullet")
        cupcake.x = Arena.x + Arena.width / 2 - 58
        cupcake.y = Arena.y + 69
        SetGlobal("cupcakex", cupcake.x)
        SetGlobal("cupcakey", cupcake.y)
    end
    if spawnwavetimer == 290 then
        cupcake.set("cupcake/cupcake_appear2")
    end
    if spawnwavetimer > 250 and spawnwavetimer < 330 then
        cupcake.x = GetGlobal("cupcakex") + math.random(-1, 1)
        cupcake.y = GetGlobal("cupcakey") + math.random(-1, 1)
    end
    if spawnwavetimer == 330 then
        Arena.Resize(220, 130)
        Arena.Move(-60, 0, false)
        cupcake.remove()
    end
    if spawnwavetimer == 340 then
        Arena.Resize(250, 380)
    end
    if spawnwavetimer >= 340 and spawnwavetimer < 350 then
        MoveHWebs(0, 10)
        Player.Move(0, 10)
    end
    if spawnwavetimer == 350 then
        RemoveHorizontal()
        ReleaseCupcake()
        Arena.ResizeImmediate(20, 20)
    end
    if spawnwavetimer >= 350 then
        UpdateCupcake()
        if spawnwavetimer % 15 == 0 then
            local spider = CreateProjectile("spider", math.random(-130, 130), GetTopY())
            spider.SetVar("hurt", true)
            if math.random() > .5 then
                spider.SetVar("velx", 1)
            else
                spider.SetVar("velx", -1)
            end
            table.insert(spiders_phase_2, spider)
        end
    end
    for i=1, #spiders_phase_1 do
        local velx = -5
        local vely = 0
        if spawnwavetimer >= 10 and spawnwavetimer < 250 then
            velx = velx + 15/14
            vely = vely + math.sin((spawnwavetimer - 10)/22.5*math.pi) * 3
        end
        spiders_phase_1[i].Move(velx, vely)
    end
    for i=1, #spiders_phase_2 do
        MoveProjectile(spiders_phase_2[i], spiders_phase_2[i].GetVar("velx")*2, -1)
        if spiders_phase_2[i].GetVar("truex") >= 116 then
            spiders_phase_2[i].SetVar("velx", -1)
        end
        if spiders_phase_2[i].GetVar("truex") <= - 116 then
            spiders_phase_2[i].SetVar("velx", 1)
        end
    end
    if spawnwavetimer == 750 then
        RemoveHorizontal()
        Player.sprite.color32 = {213, 53, 217}
        RemoveCupcake()
        EndWave()
    end
end

function OnHit(bullet)
    CupcakeOnHit(bullet)
end