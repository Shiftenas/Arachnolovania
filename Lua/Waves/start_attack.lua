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
    if spawnwavetimer == 5 then
        Audio.PlaySound("charging_blaster")
        blaster = CreateProjectile("blasters/0", 410, 80)
        blaster.sprite.rotation = 180
    end
    if spawnwavetimer > 5 and spawnwavetimer <= 50 then
        local relation = (spawnwavetimer-5) * math.pi / 90
        blaster.sprite.rotation = blaster.sprite.rotation + 2
        blaster.MoveTo(410-160*math.sin(relation), math.cos(relation)*80)
    end
    if spawnwavetimer == 50 then
        blaster.sprite.set("blasters/1")
    end
    if spawnwavetimer == 55 then
        blaster.sprite.set("blasters/2")
    end
    if spawnwavetimer == 60 then
        blaster.sprite.set("blasters/3")
        laser = CreateProjectile("laser/0", -420, 0)
        laser.SetVar("hurt", true)
        laser.sprite.Scale(1, 0.8)
        flash = CreateSprite("flash", "Top")
        Audio.PlaySound("echo")
        flash.x = 320
        flash.y = 240
        flash.alpha = .5
    end
    if spawnwavetimer == 62 then
        flash.alpha = 1
    end
    if spawnwavetimer > 62 and spawnwavetimer <= 70 then
        flash.alpha = flash.alpha - 0.125
    end
    if spawnwavetimer == 61 then 
        laser.sprite.set("laser/1")
    end
    if spawnwavetimer == 62 then 
        laser.sprite.set("laser/2")
    end
    if spawnwavetimer == 63 then 
        laser.sprite.set("laser/3")
    end
    if spawnwavetimer == 64 then 
        laser.sprite.set("laser/4")
    end
    if spawnwavetimer == 68 then 
        laser.sprite.set("laser/5")
    end
    if spawnwavetimer == 72 then 
        laser.sprite.set("laser/6")
    end
    if spawnwavetimer == 76 then 
        laser.sprite.set("laser/7")
    end
    if spawnwavetimer == 80 then 
        laser.sprite.set("laser/8")
        laser.SetVar("hurt", false)
    end
    if spawnwavetimer == 84 then 
        laser.sprite.set("laser/9")
    end
    if spawnwavetimer == 88 then
        laser.remove()
        blaster.remove()
    end
    if spawnwavetimer == 100 then
        bullet_hidder = CreateSprite("bullet_hidder", "Top")
        bullet_hidder2 = CreateSprite("bullet_hidder", "Top")
        bullet_hidder.y = Arena.y + 70
        bullet_hidder2.x = Arena.x - (110 + Arena.width / 2)
        bullet_hidder2.y = Arena.y + 70
        bullet_hidder2.rotation = 180
    end
    if spawnwavetimer > 100 and spawnwavetimer < 250 then
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
        bullet_hidder.remove()
        bullet_hidder2.remove()
    end
    if spawnwavetimer > 100 and spawnwavetimer < 330 then
        bullet_hidder.x = Arena.x + 110 + Arena.width / 2
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
        SetFallSpeed(1.5)
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
        spiders_phase_1[i].Move(-7, 0)
    end
    for i=1, #spiders_phase_2 do
        MoveProjectile(spiders_phase_2[i], spiders_phase_2[i].GetVar("velx")*2, -1.5)
        if spiders_phase_2[i].GetVar("truex") >= 116 then
            spiders_phase_2[i].SetVar("velx", -1)
        end
        if spiders_phase_2[i].GetVar("truex") <= - 116 then
            spiders_phase_2[i].SetVar("velx", 1)
        end
    end
    if spawnwavetimer == 460 then
        Audio.PlaySound("charging_blaster")
        blasterr = CreateProjectileAbs("blasters/0", 440, GetTrueY() + 105)
        blasterr.sprite.rotation = 180
    end
    if spawnwavetimer > 460 and spawnwavetimer <= 505 then
        local relation = (spawnwavetimer-460) * math.pi / 90
        RotateSprite(blasterr.sprite, -2)
        MoveProjectile(blasterr, math.sin(relation), math.cos(relation))
    end
    if spawnwavetimer == 505 then
        blasterr.sprite.Set("blasters/1")
    end
    if spawnwavetimer == 510 then
        blasterr.sprite.Set("blasters/2")
    end
    if spawnwavetimer == 515 then
        blasterr.sprite.Set("blasters/3")
        laserr = CreateProjectileAbs("laser/0", -140, blasterr.GetVar("truey") + 105)
        laserr.sprite.Scale(1, 0.8)
        laserr.SetVar("hurt", true)
        Audio.PlaySound("echo")
        AdjustPosition(laserr)
        flash.alpha = 0.5
    end
    if spawnwavetimer == 517 then
        flash.alpha = 1
    end
    if spawnwavetimer > 517 and spawnwavetimer <= 525 then
        flash.alpha = flash.alpha - 0.125
    end
    if spawnwavetimer == 516 then 
        laserr.sprite.set("laser/1")
    end
    if spawnwavetimer == 517 then 
        laserr.sprite.set("laser/2")
    end
    if spawnwavetimer == 518 then 
        laserr.sprite.set("laser/3")
    end
    if spawnwavetimer == 519 then 
        laserr.sprite.set("laser/4")
    end
    if spawnwavetimer == 523 then 
        laserr.sprite.set("laser/5")
    end
    if spawnwavetimer == 527 then 
        laserr.sprite.set("laser/6")
    end
    if spawnwavetimer == 531 then 
        laserr.sprite.set("laser/7")
    end
    if spawnwavetimer == 535 then 
        laserr.sprite.set("laser/8")
        laserr.SetVar("hurt", false)
    end
    if spawnwavetimer == 539 then 
        laserr.sprite.set("laser/9")
    end
    if spawnwavetimer == 543 then
        laserr.remove()
        blasterr.remove()
    end
    if spawnwavetimer > 460 and spawnwavetimer < 543 then
        MoveProjectile(blasterr, 0, -1.5)
        if spawnwavetimer > 515 then
            MoveProjectile(laserr, 0, -1.5)
        end
    end
    if spawnwavetimer == 543 then
        blasterr.remove()
        laserr.remove()
    end
    if spawnwavetimer == 550 then
        Audio.PlaySound("charging_blaster")
        blasterlu = CreateProjectileAbs("blasters/0", 180, GetTrueY() + 155)
        blasterlu.sprite.rotation = 180
        blasterld = CreateProjectileAbs("blasters/0", 180, GetTrueY() + 55)
    end
    if spawnwavetimer > 550 and spawnwavetimer <= 595 then
        local relation = (spawnwavetimer-460) * math.pi / 90
        RotateSprite(blasterld.sprite, 2)
        AdjustPosition(blasterld)
        RotateSprite(blasterlu.sprite, 2)
        AdjustPosition(blasterlu)
    end
    if spawnwavetimer == 595 then
        blasterlu.sprite.Set("blasters/1")
        blasterld.sprite.Set("blasters/1")
    end
    if spawnwavetimer == 600 then
        blasterlu.sprite.Set("blasters/2")
        blasterld.sprite.Set("blasters/2")
    end
    if spawnwavetimer == 605 then
        blasterlu.sprite.Set("blasters/3")
        blasterld.sprite.Set("blasters/3")
        laserlu = CreateProjectileAbs("laser/0", 780, blasterlu.GetVar("truey") + 105)
        laserlu.sprite.Scale(1, 0.8)
        laserlu.SetVar("hurt", true)
        AdjustPosition(laserlu)
        laserld = CreateProjectileAbs("laser/0", 780, blasterld.GetVar("truey") + 105)
        laserld.sprite.Scale(1, 0.8)
        laserld.SetVar("hurt", true)
        AdjustPosition(laserld)
        Audio.PlaySound("echo")
        flash.alpha = 0.5
    end
    if spawnwavetimer == 607 then
        flash.alpha = 1
    end
    if spawnwavetimer > 607 and spawnwavetimer <= 615 then
        flash.alpha = flash.alpha - 0.125
    end
    if spawnwavetimer == 606 then 
        laserlu.sprite.set("laser/1")
        laserld.sprite.set("laser/1")
    end
    if spawnwavetimer == 607 then 
        laserlu.sprite.set("laser/2")
        laserld.sprite.set("laser/2")
    end
    if spawnwavetimer == 608 then 
        laserlu.sprite.set("laser/3")
        laserld.sprite.set("laser/3")
    end
    if spawnwavetimer == 609 then 
        laserlu.sprite.set("laser/4")
        laserld.sprite.set("laser/4")
    end
    if spawnwavetimer == 613 then 
        laserlu.sprite.set("laser/5")
        laserld.sprite.set("laser/5")
    end
    if spawnwavetimer == 617 then 
        laserlu.sprite.set("laser/6")
        laserld.sprite.set("laser/6")
    end
    if spawnwavetimer == 621 then 
        laserlu.sprite.set("laser/7")
        laserld.sprite.set("laser/7")
    end
    if spawnwavetimer == 625 then 
        laserlu.sprite.set("laser/8")
        laserlu.SetVar("hurt", false)
        laserld.sprite.set("laser/8")
        laserld.SetVar("hurt", false)
    end
    if spawnwavetimer == 629 then 
        laserlu.sprite.set("laser/9")
        laserld.sprite.set("laser/9")
    end
    if spawnwavetimer == 633 then
        laserlu.remove()
        laserld.remove()
        blasterlu.remove()
        blasterld.remove()
    end
    if spawnwavetimer > 550 and spawnwavetimer < 633 then
        AdjustPosition(blasterlu)
        AdjustPosition(blasterld)
        if spawnwavetimer > 605 then
            AdjustPosition(laserlu)
            AdjustPosition(laserld)
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