file = "announcement/"
sign = nil

SetGlobal("symbols", {})
projectile_symbols = {}
SetGlobal("signactive", false)
SetGlobal("timer", 0)

function ApplySign(waves)
    SetGlobal("signactive", true)
    SetGlobal("timer", 0)
    SetGlobal("symbols", waves)
end

function HideSign()
    SetGlobal("signactive",false)
    SetGlobal("projectile_symbols", {})
    if GetGlobal("timer") > 87 then
        SetGlobal("timer", 87)
    end

    for i=1,#projectile_symbols do
        projectile_symbols[1].remove()
        table.remove(projectile_symbols, 1)
    end
end

function UpdateSign()
    local timer = GetGlobal("timer")
    local signactive = GetGlobal("signactive")
    local symbols = GetGlobal("symbols")

    if signactive then
        startx = 440 - (20 - 2.9 * (#symbols - 1)) * (#symbols - 1)
        if timer == 0 then 
            hold_spider = CreateProjectileAbs(file.."cute_spider1", 640, 240)
            hold_spider.sprite.Scale(2,2)
        end
        timer = timer + 1
        if timer > 5 and timer <= 55 then
            hold_spider.Move(-4,0)
            if timer%10 >= 5 then 
                hold_spider.sprite.set(file.."cute_spider1")
            else 
                hold_spider.sprite.set(file.."cute_spider2") 
            end
        elseif timer == 60 then
            sign = CreateProjectileAbs("announcement/sign1", 440, 292)
            sign.sprite.Scale(2,2)
        elseif timer == 65 then
            sign.sprite.set("announcement/sign2")
        elseif timer == 70 then 
            sign.sprite.set("announcement/sign3")
        elseif timer == 75 then
            sign.sprite.set("announcement/sign4")
        elseif timer == 80 then 
            sign.sprite.set("announcement/sign5")
        elseif timer == 85 then
            for i=1,#symbols do
                local actualsymbol = CreateProjectileAbs(file .. symbols[i], startx, 305)
                table.insert(projectile_symbols,actualsymbol)
                startx = startx + 40 - 4.8 * #symbols
            end
            upnext = CreateProjectileAbs(file.."up_next",440,330)
            table.insert(projectile_symbols, upnext)
        end
    elseif timer != nil and timer > 0 then
        timer = timer - 1
        if timer == 80 then    
            for i=1,#projectile_symbols do
                projectile_symbols[1].remove()
                table.remove(projectile_symbols, 1)
            end
            sign.sprite.set("announcement/sign4")
        elseif timer == 75 then
            sign.sprite.set("announcement/sign3")
        elseif timer == 70 then
            sign.sprite.set("announcement/sign2")
        elseif timer == 65 then
            sign.sprite.set("announcement/sign1")
        elseif timer == 59 then
            sign.remove()
        elseif timer > 5 and timer <= 55 then
            hold_spider.Move(4,0)
            if timer%10 >= 5 then 
                hold_spider.sprite.set(file.."cute_spider1")
            else 
                hold_spider.sprite.set(file.."cute_spider2") 
            end
        elseif timer == 0 then
            hold_spider.remove()
        end
    end

    SetGlobal("timer",timer)
end