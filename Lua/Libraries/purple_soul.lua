actual_h_web = nil
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
moving = false

function ActivePurple(wdt,hgt)
    Arena.resizeImmediate((wdt+20)*2,(hgt+20)*2)
    SetGlobal("height",hgt)
    SetGlobal("width",wdt)
    Player.sprite.color32 = {213 ,53, 217}
    Player.SetControlOverride(true)
end

function PurpleIsMoving()
    return moving
end

function RemovePurple()
    Player.sprite.color = {1,0,0}
    Player.SetControlOverride(false)
end

function ActiveHorizontal()
    local hgt = GetGlobal("height")
    local wdt = GetGlobal("width")
    horizontal = true
    upweb = CreateHorizontalWeb(hgt,wdt)
    midhweb = CreateHorizontalWeb(0,wdt)
    dwnweb = CreateHorizontalWeb(-hgt,wdt)
    Player.MoveTo(Player.x,0)
    actual_h_web = "mid"
end

function RemoveHorizontal()
    horizontal = false
    for i=1,#upweb do
        upweb[1].remove()
        table.remove(upweb,1)
        midhweb[1].remove()
        table.remove(midhweb,1)
        dwnweb[1].remove()
        table.remove(dwnweb,1)
    end
    if not vertical then RemovePurple() end
end

function ActiveVertical()
    local hgt = GetGlobal("height")
    local wdt = GetGlobal("width")
    vertical = true
    lftweb = CreateVerticalWeb(hgt,-wdt)
    midvweb = CreateVerticalWeb(hgt,0)
    rgtweb = CreateVerticalWeb(hgt,wdt)
    Player.MoveTo(0,Player.y)
    actual_v_web = "mid"
end

function RemoveVertical()
    vertical = false
    for i=1,#lftweb do
        lftweb[1].remove()
        table.remove(lftweb,1)
        midvweb[1].remove()
        table.remove(midvweb,1)
        rgtweb[1].remove()
        table.remove(rgtweb,1)
    end
    if not horizontal then RemovePurple() end
end

function PurpleUpdate()
    moving = false
    if horizontal or vertical then
        if Input.Up >= 1 then 
            if Input.Down >= 1 then
                movex = 0
            else
                movex = Input.Up
            end
        elseif Input.Down >= 1 then
            movex = -Input.Down
        else
            movex = 0
        end
        if horizontal then
            if movex == 1 then MoveUp() end
            if movex == -1 then MoveDown() end
        else   
            Player.Move(0, movex, false)
            if movex != 0 then
                moving = true
            end
        end
        if Input.Left >= 1 then 
            if Input.Right >= 1 then
                movey = 0
            else
                movey = -Input.Left
            end
        elseif Input.Right >= 1 then
            movey = Input.Right
        else
            movey = 0
        end
        if vertical then
            if movey == 1 then MoveRight() end
            if movey == -1 then MoveLeft() end
        else
            Player.Move(movey, 0, false)
            if movey != 0 then
                moving = true
            end
        end
    end
end

function MoveUp()
    local height = GetGlobal("height")
    if actual_h_web == "mid" then
        Player.MoveTo(Player.x,height,false)
        actual_h_web = "up"
    end
    if actual_h_web == "dwn" then
        Player.MoveTo(Player.x,0,false)
        actual_h_web = "mid"
    end
end

function MoveDown()
    local height = GetGlobal("height")
    if actual_h_web == "mid" then
        Player.MoveTo(Player.x,-height,false)
        actual_h_web = "dwn"
    end
    if actual_h_web == "up" then
        Player.MoveTo(Player.x,0,false)
        actual_h_web = "mid"
    end
end

function MoveLeft()
    local width = GetGlobal("width")
    if actual_v_web == "mid" then
        Player.MoveTo(-width,Player.y,false)
        actual_v_web = "lft"
    end
    if actual_v_web == "rgt" then
        Player.MoveTo(0,Player.y,false)
        actual_v_web = "mid"
    end
end

function MoveRight()
    local width = GetGlobal("width")
    if actual_v_web == "mid" then
        Player.MoveTo(width, Player.y, false)
        actual_v_web = "rgt"
    end
    if actual_v_web == "lft" then
        Player.MoveTo(0, Player.y,false)
        actual_v_web = "mid"
    end
end

function CreateHorizontalWeb(hgt,wdt)
    fullweb = {}
    web_number = math.floor(wdt/5)
    start = -web_number*5-5
    for i=1,web_number+2 do
        local web = CreateProjectile("purple_soul/hweb", start, hgt)
        start = start + 10
        table.insert(fullweb,web)
    end
    return fullweb
end

function MoveHWebs(x,y)
    for i=1,#upweb do
        upweb[i].x = upweb[i].x + x
        upweb[i].y = upweb[i].y + y
        midhweb[i].x = midhweb[i].x + x
        midhweb[i].y = midhweb[i].y + y
        dwnweb[i].x = dwnweb[i].x + x
        dwnweb[i].y = dwnweb[i].y + y
    end
end

function CreateVerticalWeb(hgt,wdt)
    fullweb = {}
    web_number = math.floor(hgt/5)
    start = -web_number*5-5
    for i=1,web_number+2 do
        local web = CreateProjectile("purple_soul/vweb",wdt,start)
        start = start + 10
        web.SetVar("hurt",false)
        table.insert(fullweb,web)
    end
    return fullweb
end