webs = {}
file = "cupcake/"
require "arena_rotating"
require "karma"
cupcake = nil
cupcake_released = false
cupcaketimer = 0actual_h_web = nil
actual_v_web = nil
horizontal = false
vertical = false
SetGlobal("height",100)
SetGlobal("width",120)
upweb = {}
midhweb = {}
dwnweb = {}
lftweb = {}
midvweb = {}
rgtweb = {}
movex = 0
movey = 0
speed = 1

function ReleaseCupcake()
    cupcake = CreateProjectileAbs(file.."cupcake1",305,140)
    cupcake.ppcollision = true
    cupcake.sprite.Scale(3, 3)
    cupcake.SetVar("hurt",true)
    cupcake.SetVar("iscupcake",true)
    cupcake_released = true
    ActiveRotatingArena()
    CPurpleActive()
end

function GetTopY()
    return webs[#webs][1].GetVar("truey")
end

function SetFallSpeed(new_speed)
    speed = new_speed
end

function UpdateCupcake()
    RotateArenaUpdate()
    if cupcake_released then
        PlayerPurpleMove()
        cupcake.Move(math.sin(cupcaketimer/45*math.pi),math.cos(cupcaketimer/45*math.pi))
        cupcaketimer = cupcaketimer + 1
        if cupcaketimer == 22 then
            cupcake.sprite.set(file.."cupcake2")
        elseif cupcaketimer == 45 then
            cupcake.sprite.set(file.."cupcake3")
        elseif cupcaketimer == 67 then
            cupcake.sprite.set(file.."cupcake4")
        elseif cupcaketimer == 90 then
            cupcake.sprite.set(file.."cupcake1")
            cupcaketimer = 0
        end

        local removed = false
        if webs[#webs][1].GetVar("truey") != nil and webs[#webs][1].GetVar("truey") <= 185 then
            table.insert(webs,CreateHorizontalCWeb(235,100))
        end
        for i=1,#webs do
            for j=1,22 do
                if not removed then
                    MoveSprite(webs[i][j], 0, -speed)
                else
                    MoveSprite(webs[i-1][j], 0, -speed)
                end
            end
            if not removed then
                if webs[i][1].GetVar("truey") < - 200 then
                    for j=1,#webs[i] do
                        webs[i][1].remove()
                        table.remove(webs[i],1)
                    end
                    table.remove(webs,i)
                    removed = true
                end
            end
        end
    end


end

function CPurpleActive()
    Player.sprite.color32 = {213 ,53, 217}
    OverrideMovingArena(true)
    ForceMovePlayer(0, 35 - GetTrueY())
    table.insert(webs,CreateHorizontalCWeb(-65,100))
    table.insert(webs,CreateHorizontalCWeb(-15,100))
    table.insert(webs,CreateHorizontalCWeb(35,100))
    table.insert(webs,CreateHorizontalCWeb(85,100))
    table.insert(webs,CreateHorizontalCWeb(135,100))
    table.insert(webs,CreateHorizontalCWeb(185,100))
    table.insert(webs,CreateHorizontalCWeb(235,100))
end

function CupcakeOnHit(bullet)
    if bullet.GetVar("iscupcake") and GetTrueY() < 120 then
        Player.hp = 0
    elseif bullet.GetVar("hurt") then
        KarmaHurt()
    end
end

function RemoveCupcake()
    for i=1, #webs do
        for j=1, #webs[i] do
            webs[i][j].remove()
        end
    end
    cupcake.remove()
    RemoveArena()
end

function CreateHorizontalCWeb(hgt,wdt)
    fullweb = {}
    web_number = math.floor(wdt/5)
    start = -web_number*5-5 - 320
    for i=1,web_number+2 do
        local web = CreateSprite("purple_soul/hweb", "BelowBullet")
        web.x = start
        web.y = hgt - 280
        start = start + 10
        web.SetVar("hurt",false)
        table.insert(fullweb,web)
    end
    return fullweb
end

function PlayerPurpleMove()
    if Input.Up == 1 then 
        if Input.Down == 1 then
            movey = 0
        else
            movey = 1
        end
    elseif Input.Down == 1 then
        movey = -1
    else
        movey = 0
    end
    if Input.Left >= 1 then 
        if Input.Right >= 1 then
            movex = 0
        else
            movex = -1
        end
    elseif Input.Right >= 1 then
        movex = 1
    else
        movex = 0
    end
    if GetTrueY() + 50 > 187 then
        movey = 0
    end
    if GetTrueX() >= 110 and movex == 1 then movex = 0 end
    if GetTrueX() <= -110 and movex == -1 then movex = 0 end
    ForceMovePlayer(movex * 2, movey * 50 - speed)
end