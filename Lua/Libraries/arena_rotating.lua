-- This library was made by Shift' (Me). 
spawntimer = 0
arena_rotating = false
override_arena = false

-- Put this when you want to start the Rotating Arena
-- ActiveRotatingArena
function ActiveRotatingArena()
    fake_arena = CreateSprite("fake_arena","BelowPlayer")
    fake_arena.x = 320
    fake_arena.y = 280
    Player.SetControlOverride(true)
    SetGlobal("truex",Player.absx-320)
    SetGlobal("truey",Player.absy-240)
    arena_rotating = true
end

function OverrideMovingArena(bool)
    override_arena = bool
end

-- Put this in the wave Update() function
-- RotateArenaUpdate()
function RotateArenaUpdate()
    if arena_rotating then
        AdjustSprite(Player.sprite)
        fake_arena.rotation = math.sin(spawntimer/36+math.pi/2)*5
        fake_arena.x = fake_arena.x - math.cos(spawntimer/36+math.pi/2)
        spawntimer = spawntimer + 1
    end
    
    MovePlayer()
end

-- put this on the wave Update() function for each sprites.
-- DON'T PUT PROJECTILES !
-- AdjustSprite(bulletname.sprite) or AdjustSprite(spritename)
function AdjustSprite(sprite)
    if sprite.GetVar("startrotation") == nil then
        sprite.SetVar("startrotation",sprite.rotation)
    end 
    sprite.rotation = sprite.GetVar("startrotation") + fake_arena.rotation
end

-- DON'T USE THIS ANYWHERE
function MovePlayer()

    
    local movex = 0
    local movey = 0

    if not override_arena then
        if Input.Up >= 1 then 
            if Input.Down >= 1 then
                movey = 0
            else
                movey = Input.Up
            end
        elseif Input.Down >= 1 then
            movey = -Input.Down
        else
            movey = 0
        end

        if Input.Left >= 1 then 
            if Input.Right >= 1 then
                movex = 0
            else
                movex = -Input.Left
            end
        elseif Input.Right >= 1 then
            movex = Input.Right
        else
            movex = 0
        end
    end
    
    if arena_rotating then


        local truex = GetGlobal("truex")
        local truey = GetGlobal("truey")
    
        truex = truex + movex
        if truex > 116 then truex = 116 end
        if truex < -116 then truex = -116 end
        truey = truey + movey
        if truey > 187 then truey = 187 end
        if truey < -187 then truey = -187 end
        local angle = fake_arena.rotation * math.pi / 180
        dist = math.sqrt(truex * truex + truey * truey)
        local next_x = 0
        local next_y = 0
        local truexangle = 0 
        local trueyangle = 0
        if dist != 0 then
            if truex >= 0 and truey >= 0 then
                truexangle = math.acos(truex/dist) + angle
                trueyangle = math.asin(truey/dist) + angle
                next_x = math.cos(truexangle) * dist
                next_y = math.sin(trueyangle) * dist
            end
            if truex < 0 and truey < 0 then
                truexangle = math.pi - math.acos(-truex/dist) - angle
                trueyangle = - math.asin(-truey/dist) - angle
                next_x = math.cos(truexangle) * dist
                next_y = math.sin(trueyangle) * dist
            end
            if truex < 0 and truey >= 0 then
                truexangle = math.pi - math.acos(-truex/dist) + angle
                trueyangle = - math.asin(-truey/dist) - angle
                next_x = math.cos(truexangle) * dist
                next_y = math.sin(trueyangle) * dist
            end
            if truex >= 0 and truey < 0 then
                truexangle = math.acos(truex/dist) - angle
                trueyangle = - math.asin(-truey/dist) + angle
                next_x = math.cos(truexangle) * dist
                next_y = math.sin(trueyangle) * dist
            end

        end
        next_x = math.cos(truexangle) * dist
        next_y = math.sin(trueyangle) * dist
        Player.MoveToAbs(next_x + fake_arena.x, next_y + fake_arena.y, true)
        SetGlobal("truex", truex)
        SetGlobal("truey", truey)
    else
        next_x = Player.absx + movex
        next_y = Player.absy + movey
        Player.MoveToAbs(next_x, next_y,false)
        SetGlobal("truex",Player.absx-320)
        SetGlobal("truey",Player.absy-240)
    end
end

-- This function is for moving the Player, like teleporting him for some sorts of soul coulours
-- ForceMovePlayer(1,0)
function ForceMovePlayer(x,y)
    SetGlobal("truex", GetGlobal("truex") + x)
    SetGlobal("truey", GetGlobal("truey") + y)
end

function GetTrueX()
    return GetGlobal("truex")
end

function GetTrueY()
    return GetGlobal("truey")
end

function RemoveArena()
    fake_arena.remove()
end

function RotateSprite(sprite,r)
    if sprite.GetVar("startrotation") == nil then
        sprite.SetVar("startrotation",r)
    else
        sprite.SetVar("startrotation",sprite.GetVar("startrotation")+r)
    end
end
-- Put this on non moving objects
-- THIS FUNCTION DON'T USE SPRITES !
-- AdjustPosition(bulletname)
function AdjustPosition(thing)
    if thing.GetVar("truex") == nil then
        thing.SetVar("truex",thing.x)
        thing.SetVar("truey",thing.y)
    end

    AdjustSprite(thing.sprite)

    local truex = thing.GetVar("truex")
    local truey = thing.GetVar("truey")
    local angle = fake_arena.rotation * math.pi / 180

    local dist = math.sqrt(truex * truex + truey * truey)
    local next_x = 0
    local next_y = 0

    if dist != 0 then
        local truexangle = 0 
        local trueyangle = 0
        if truex >= 0 and truey >= 0 then
            truexangle = math.acos(truex/dist) + angle
            trueyangle = math.asin(truey/dist) + angle
            next_x = math.cos(truexangle) * dist
            next_y = math.sin(trueyangle) * dist
        end
        if truex < 0 and truey < 0 then
            truexangle = math.pi - math.acos(-truex/dist) - angle
            trueyangle = - math.asin(-truey/dist) - angle
            next_x = math.cos(truexangle) * dist
            next_y = math.sin(trueyangle) * dist
        end
        if truex < 0 and truey >= 0 then
            truexangle = math.pi - math.acos(-truex/dist) + angle
            trueyangle = - math.asin(-truey/dist) - angle
            next_x = math.cos(truexangle) * dist
            next_y = math.sin(trueyangle) * dist
        end
        if truex >= 0 and truey < 0 then
            truexangle = math.acos(truex/dist) - angle
            trueyangle = - math.asin(-truey/dist) + angle
            next_x = math.cos(truexangle) * dist
            next_y = math.sin(trueyangle) * dist
        end
        next_x = math.cos(truexangle) * dist
        next_y = math.sin(trueyangle) * dist
    end

    thing.MoveToAbs(fake_arena.x + next_x, fake_arena.y + next_y)
end


-- Put this on non moving objects
-- THIS FUNCTION DON'T USE SPRITES !
-- AdjustPosition(bulletname)
function AdjustSpritePosition(thing)
    if thing.GetVar("truex") == nil then
        thing.SetVar("truex",thing.x)
        thing.SetVar("truey",thing.y)
    end

    AdjustSprite(thing)

    local truex = thing.GetVar("truex")
    local truey = thing.GetVar("truey")
    local angle = fake_arena.rotation * math.pi / 180

    local dist = math.sqrt(truex * truex + truey * truey)
    local next_x = 0
    local next_y = 0

    if dist != 0 then
        local truexangle = 0 
        local trueyangle = 0
        if truex >= 0 and truey >= 0 then
            truexangle = math.acos(truex/dist) + angle
            trueyangle = math.asin(truey/dist) + angle
            next_x = math.cos(truexangle) * dist
            next_y = math.sin(trueyangle) * dist
        end
        if truex < 0 and truey < 0 then
            truexangle = math.pi - math.acos(-truex/dist) - angle
            trueyangle = - math.asin(-truey/dist) - angle
            next_x = math.cos(truexangle) * dist
            next_y = math.sin(trueyangle) * dist
        end
        if truex < 0 and truey >= 0 then
            truexangle = math.pi - math.acos(-truex/dist) + angle
            trueyangle = - math.asin(-truey/dist) - angle
            next_x = math.cos(truexangle) * dist
            next_y = math.sin(trueyangle) * dist
        end
        if truex >= 0 and truey < 0 then
            truexangle = math.acos(truex/dist) - angle
            trueyangle = - math.asin(-truey/dist) + angle
            next_x = math.cos(truexangle) * dist
            next_y = math.sin(trueyangle) * dist
        end
        next_x = math.cos(truexangle) * dist
        next_y = math.sin(trueyangle) * dist
    end

    thing.x = fake_arena.x + next_x
    thing.y = fake_arena.y + next_y
end

-- Use this function to move projectiles
-- THIS fUNCTION DON'T USE SPRITES !
-- MoveProjectile(bulletname,1,0) 
function MoveProjectile(bullet,x,y)
    if bullet.GetVar("truex") == nil then
        bullet.SetVar("truex",bullet.x)
        bullet.SetVar("truey",bullet.y)
    end

    bullet.SetVar("truex", x + bullet.GetVar("truex"))
    bullet.SetVar("truey", y + bullet.GetVar("truey"))

    AdjustPosition(bullet)
end

-- Use this function to move projectiles
-- THIS fUNCTION DON'T USE SPRITES !
-- MoveProjectile(bulletname,1,0) 
function MoveSprite(bullet,x,y)
    if bullet.GetVar("truex") == nil then
        bullet.SetVar("truex",bullet.x + 320)
        bullet.SetVar("truey",bullet.y + 280)
    end

    bullet.SetVar("truex", x + bullet.GetVar("truex"))
    bullet.SetVar("truey", y + bullet.GetVar("truey"))

    AdjustSpritePosition(bullet)
end
    
    