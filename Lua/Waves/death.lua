spawnwavetimer = 0
Arena.ResizeImmediate(16,16)
Arena.Move(0,100)

function Update()
    spawnwavetimer = spawnwavetimer + 1
    if spawnwavetimer == 5 then
        cupcake = CreateProjectile("cupcake/cupcake1", 0, -100)
        cupcake.sprite.Scale(3, 3)
        cupcake.ppcollision = true
    end
    if spawnwavetimer > 10 then
        Arena.Move(0,-0.5)
    end
    if spawnwavetimer == 450 then
        cupcake.sprite.Set("cupcake/cupcake2")
    end
    if spawnwavetimer == 500 then
        cupcake.sprite.Set("cupcake/cupcake3")
    end
    DEBUG(spawnwavetimer)
end

function OnHit(bullet)
    Player.hp = 0
end