file = "special_attack/"
Encounter["arenasize"] = {575, 130}
Arena.ResizeImmediate(575, 130)

hidder = CreateSprite("flash", "Top")
hidder.x = 320
hidder.y = 240
hidder.color = {1, 1, 1, 0.5}

Player.SetControlOverride(true)
--Arena.Resize(120, 120)
Arena.Move(0, 500, false, true)

down_bar = CreateSprite(file.."bar", "BelowBullet")
down_bar.x = 320
down_bar.y = 92

left_bar = CreateSprite(file.."bar", "BelowBullet")
left_bar.rotation = 90
left_bar.x = 257.5
left_bar.y = 155

right_bar = CreateSprite(file.."bar", "BelowBullet")
right_bar.rotation = -90
right_bar.x = 382.5
right_bar.y = 155

up_left_bar = CreateSprite(file.."midbar", "BelowBullet")
up_left_bar.SetAnchor(1, 1)
up_left_bar.SetParent(left_bar)
up_left_bar.x = -2.5
up_left_bar.y = -32.5

up_right_bar = CreateSprite(file.."midbar", "BelowBullet")
up_right_bar.SetAnchor(1, 0)
up_right_bar.SetParent(right_bar)
up_right_bar.x = -2.5
up_right_bar.y = 32.5

arenatimer = 0

function Update()
    if arenatimer < 260 then
        UpdateArena()
    else
        Arena.Move(0, -500, false, true)
        EndWave()
    end
end


function UpdateArena()
    arenatimer = arenatimer + 1
    if arenatimer == 1 then
        Audio.PlaySound("echo")
        hidder.alpha = 1
    end

    if arenatimer > 1 and arenatimer <= 11 then
        hidder.alpha = hidder.alpha - 0.1
    end

    if arenatimer <= 90 then
        local var = math.pi / 2 - (arenatimer / 180 * math.pi)

        right_bar.x = 382.5 + 65 * math.cos(var)
        right_bar.y = 92 + 65 * math.sin(var)
        right_bar.rotation = 90 - arenatimer

        left_bar.x = 257.5 - 65 * math.cos(var)
        left_bar.y = 92 + 65 * math.sin(var)
        left_bar.rotation = 90 + arenatimer

        up_right_bar.x = 32.5 * math.cos(var) - 2.5
        up_right_bar.y = 30 * math.sin(var) + 2.5
        up_right_bar.rotation = - arenatimer * 2

        up_left_bar.x = 32.5 * math.cos(var) - 2.5
        up_left_bar.y = - 30 * math.sin(var) - 2.5
        up_left_bar.rotation = arenatimer * 2
    end
    if arenatimer > 90 and arenatimer <= 135 then
        local var = math.pi / 2 - (arenatimer / 180 * math.pi)

        up_right_bar.x = 32.5 * math.cos(var) - 2.5
        up_right_bar.y = 30 * math.sin(var) + 2.5 - (arenatimer - 90)^2 / 4
        up_right_bar.rotation = up_right_bar.rotation - 1
        
        up_left_bar.x = 32.5 * math.cos(var) - 2.5
        up_left_bar.y = - 30 * math.sin(var) - 2.5 + (arenatimer - 90)^2 / 4
        up_left_bar.rotation = up_left_bar.rotation + 1
    end

    if arenatimer == 135 then
        Audio.PlaySound("echo")
        hidder.alpha = 1
    end

    if arenatimer > 135 and arenatimer <= 146 then
        hidder.alpha = hidder.alpha - 0.1
    end

    if arenatimer > 135 and arenatimer <= 180 then
        local var = math.pi / 2 - (arenatimer / 180 * math.pi)
        local var2 = math.pi / 2 - ((arenatimer - 45) / 180 * math.pi)

        right_bar.x = 382.5 + 65 * math.cos(var2)
        right_bar.y = 92 + 65 * math.sin(var2)
        right_bar.rotation = right_bar.rotation - 1

        left_bar.x = 257.5 - 65 * math.cos(var2)
        left_bar.y = 92 + 65 * math.sin(var2)
        left_bar.rotation = left_bar.rotation + 1


        down_bar.x = 385 - math.cos(var2) * 65
        down_bar.y = 92 - math.sin(var2) * 65 - (arenatimer - 180)^2 / 50
        down_bar.rotation = arenatimer - 280
    end

    if arenatimer > 180 and arenatimer < 240 then
        local var = math.pi / 2 - ((arenatimer - 45) / 180 * math.pi)

        right_bar.x = 382.5 + 65 * math.cos(var)
        right_bar.y = 92 + 65 * math.sin(var) - (arenatimer - 180)^2 / 8
        right_bar.rotation = 90 - arenatimer + 45

        left_bar.x = 257.5 - 65 * math.cos(var)
        left_bar.y = 92 + 65 * math.sin(var) - (arenatimer - 180)^2 / 8
        left_bar.rotation = 90 + arenatimer - 45
        
        down_bar.x = 385 - math.cos(var) * 65
        down_bar.y = 92 - math.sin(var) * 65 - (arenatimer - 180)^2 / 8
        down_bar.rotation = arenatimer - 280
    end

end