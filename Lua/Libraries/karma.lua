--[[
    This library was created by Shift' (Me)
    This is a WIP library, you can help me improve it
    Don't forget the require "karma"
]]--

posx_start = 277.5

-- Change the values if you want to change the colours of the UI
yellow = {255, 255, 0}
purple = {213, 53 ,217}
red = {255, 0, 0}
white = {255, 255, 255}

-- Put this function in the EncounterStarting() function.
function ResetBar()
    SetRealGlobal("hurtcount", 0)
    SetRealGlobal("karmatimer", 0)
    SetRealGlobal("yellow_hp", 92)
    SetRealGlobal("purple_hp", 0)

    local start = posx_start
    local kbar = {}

    for i=1, 92 do
        local mesure = CreateSprite("karma/mesure", "BelowArena")
        mesure.x = start
        mesure.y = 70
        mesure.color32 = {255, 185, 0}
        table.insert(kbar,mesure)
        start = start + 110/92
    end
    
    hidder = CreateSprite("karma/hidder", "BelowArena")
    hidder.x = 500
    hidder.y = 70

    kr = CreateSprite("karma/UI/kr", "BelowArena")
    kr.x = 415
    kr.y = 70

    slash = CreateSprite("karma/UI/slash", "BelowArena")
    slash.x = 485
    slash.y = 70

    first = CreateSprite("karma/UI/9", "BelowArena")
    first.x = 450
    first.y = 70

    second = CreateSprite("karma/UI/2", "BelowArena")
    second.x = 465
    second.y = 70

    nine = CreateSprite("karma/UI/9", "BelowArena")
    nine.x = 505
    nine.y = 70

    two = CreateSprite("karma/UI/2", "BelowArena")
    two.x = 520
    two.y = 70

    SetRealGlobal("karmabar",kbar)
end

-- This function goes in the encounter Update() function
function UpdateBar()
    local karmatimer = GetRealGlobal("karmatimer") + 1
    local kbar = GetRealGlobal("karmabar")
    local purple_hp = GetRealGlobal("purple_hp")
    local yellow_hp = GetRealGlobal("yellow_hp")
    for i=1, yellow_hp do
        kbar[i].color32 = yellow
    end
    for i=yellow_hp + 1, yellow_hp + purple_hp do
        kbar[i].color32 = purple
    end
    for i=yellow_hp + purple_hp + 1, 92 do
        kbar[i].color32 = red
    end
    if karmatimer == 25 then
        if purple_hp > 0 then
            purple_hp = purple_hp - 1
        end
        karmatimer = 0
    end

    local total_hp = purple_hp + GetRealGlobal("yellow_hp")
    
    first.set("karma/UI/"..(total_hp-total_hp%10)/10)
    second.set("karma/UI/"..total_hp%10)

    if purple_hp > 0 then
        slash.color32 = purple
        first.color32 = purple
        second.color32 = purple
        nine.color32 = purple
        two.color32 = purple
    else
        slash.color32 = white
        first.color32 = white
        second.color32 = white
        nine.color32 = white
        two.color32 = white
    end

    SetRealGlobal("karmatimer", karmatimer)
    SetRealGlobal("purple_hp", purple_hp)
end

-- It's evident, isn't it ?
function HealKarma(amount)
    local yellow_hp = GetRealGlobal("yellow_hp")
    local purple_hp = GetRealGlobal("purple_hp")

    yellow_hp = yellow_hp + amount
    if yellow_hp > 92 then yellow_hp = 92 end
    purple_hp = purple_hp - amount
    if purple_hp < 0 then purple_hp = 0 end

    Audio.PlaySound("healsound")
    
    SetRealGlobal("purple_hp", purple_hp)
    SetRealGlobal("yellow_hp", yellow_hp)
end

-- Use this as a "Player.hp"
function GetYellowHP()
    return GetRealGlobal("yellow_hp")
end

-- Use this function in the wave OnHit(bullet) function
function KarmaHurt()
    Audio.PlaySound("hurtsound")

    local hurtcount = GetRealGlobal("hurtcount")
    local purple_hp = GetRealGlobal("purple_hp")
    local yellow_hp = GetRealGlobal("yellow_hp")

    if yellow_hp > 1 then
        yellow_hp = yellow_hp - 1
        purple_hp = purple_hp + 1
        hurtcount = hurtcount + 1
        if hurtcount == 5 then
            purple_hp = purple_hp - 1
            hurtcount = 0
        end
    elseif purple_hp > 0 then
        purple_hp = purple_hp - 1
    else
        Player.hp = 0
    end

    SetRealGlobal("purple_hp", purple_hp)
    SetRealGlobal("yellow_hp", yellow_hp)
    SetRealGlobal("hurtcount", hurtcount)
end