-- A basic encounter script skeleton you can copy and modify for your own creations.

require "karma"
require "announcement"
require "covering"

music = "arachnolovania" --Either OGG or WAV. Extension is added automatically. Uncomment for custom music.
encountertext = "[color:ffffff]You feel spiders crawling on\ryour back." --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"start_attack"}
wavetimer = 100.0
actualhp = 20
signs = {"spider"}
arenasize = {575, 130}
fleesuccess = false
final_fight = false
final_state = false
final_timer = 0
final_flash = CreateSprite("flash", "Top")
final_flash.x = 320
final_flash.y = 240
final_flash.alpha = 0
said = false
enemies = {
"muffet"
}

enemypositions = {
{0, 10}
}

-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.

function EncounterStarting()
    if Misc.FileExists("Others/name.txt") then
        namefile = Misc.OpenFile("Others/name.txt")
        Player.name = namefile.ReadLine(1)
    else
        Player.name = "Rhenao"
    end
    Inventory.AddCustomItems({"G.Flower", "Steak", "I.Noodles", "Tea", "Donut", "Pie"}, {0, 0, 0, 0, 0, 0})
    Inventory.SetInventory({"G.Flower", "I.Noodles", "Steak", "Tea", "Tea", "Donut", "Donut", "Pie"})
    Player.lv = 19
    Player.hp = 92
    actualhp = 92
    ResetBar()
    State("ENEMYDIALOGUE")
    Audio.Stop()
end

function Update()
    if final_fight and Input.GetKey("Z") == 1 then
        ActiveFinalState()
    else
        UpdateFinalState()
        UpdateBar()
        UpdateSign()
    end
end

function EnemyDialogueStarting()
    enemies[1].Call("EnemyDialogueStarting")
end

function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    -- nextwaves = { possible_attacks[math.random(#possible_attacks)] }
end

function DefenseEnding() --This built-in function fires after the defense round ends.
    encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.
end

function StopMusic()
    Audio.Stop()
end

function SadMusic()
    Audio.LoadFile("fallen_down")
    Audio.Play()
end

function HandleSpare()
    State("ENEMYDIALOGUE")
end

function MettatonVoice(text)
    local skip = false
    local newtext = ""
    for i=1, #text do
        local letter = text:sub(i, i)
        if letter == "[" then skip = true end
        if not skip then
            local rand = math.random(1, 9)
            local add = "[voice:mettaton_voice"..rand.."]"..letter 
            newtext = newtext..add
        else
            newtext = newtext..letter
        end
        if letter == "]" then skip = false end
    end
    return newtext
end

function CallHidders()
    SetHidders()
end

function HandleItem(ItemID)
    if ItemID == "G.FLOWER" then
        BattleDialog({
            "[noskip]You ate the Golden Flower.\nYou remember the one that\ryou killed to get it.",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]You don't regret this, do you ?[w:3]\nWhy would we be there\rotherwise ?",
            "[noskip]Anyways, you are [func:HealKarma, 92]healed up."
        })
    end

    if ItemID == "I.NOODLES" then
        BattleDialog({
            "[noskip]They're better dry.\nYou're [func:HealKarma, 92]healed up.",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]Alphys was a great help. I'm\ralmost sad for her.",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]I insist on \"almost\"."
        })
    end

    if ItemID == "STEAK" then
        local first_text = "[noskip]You ate the Mettaton-shaped\rSteak.\n"
        if GetYellowHP() >= 32 then
            first_text = first_text .. "You're [func:HealKarma, 60]healed up."
        else
            first_text = first_text .. "You get [func:HealKarma, 60]60 HP."
        end
        BattleDialog({
            first_text,
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]This robot was pathetic.[w:3] At\rleast he made great food."
        })
    end

    if ItemID == "TEA" then
        local first_text = "[noskip]You drank the Spider Tea.\n"
        if GetYellowHP() > 52 then
            first_text = first_text .. "You're [func:HealKarma, 40]healed up."
        else
            first_text = first_text .. "You get [func:HealKarma, 40]40 HP."
        end
        local text = {first_text}
        if not said then
            table.insert(text, "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]Ironic,[w:3] isn't it ?")
            said = true
        end
        BattleDialog(text)
    end
    
    if ItemID == "DONUT" then
        local first_text = "[noskip]You ate the Spider Donut.\n"
        if GetYellowHP() > 52 then
            first_text = first_text .. "You're [func:HealKarma, 30]healed up."
        else
            first_text = first_text .. "You get [func:HealKarma, 30]30 HP."
        end
        local text = {first_text}
        if not said then
            table.insert(text, "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]Ironic,[w:3] isn't it ?")
            said = true
        end
        BattleDialog(text)
    end

    if ItemID == "PIE" then
        text = {
            "[noskip]You ate Toriel's Pie.\nYou're hea[func:StopMusic][w:5].[w:5].[w:5].",
            "[noskip]You start to remember\rsomething...",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]What are you doing ?",
            "[noskip][func:SadMusic]The warm of the Pie makes you\rremember of her...",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]Don't waste our time !",
            "[voice:monsterfont][noskip]I remember her...",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]"..Player.name.." ! Stop it !",
            "[voice:monsterfont][noskip]I... I can't...",
            "[voice:toriel_voice][noskip]It's not too late, my child...",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]They're dead ! You don't need\rthem !",
            "[voice:monsterfont][noskip]I'm sorry...",
            "[voice:v_papyrus][noskip]IT'S OKAY HUMAN ! WE FORGIVE\rYOU !",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]JUST KILL HER !",
            "[voice:v_sans][noskip]you know what you have to do,[w:3]\rkiddo.",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]DON'T HEAR THEM ! KILL HER !\rWE ARE TOO CLOSE !",
            "[voice:v_fluffybuns][noskip]You can give up, it's ok.",
            "[voice:alphys_voice][noskip]M-mettaton, c-calm down...[w:3] B-but\ryes, we...[w:3] We trust you...",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]DON'T ! HEAR ! THEM !",
            "[voice:undyne_voice][noskip]Come again punk,[w:3] Toriel misses\ryou.",
            "[voice:v_fluffybuns][noskip]All of us miss you.",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000]WE ARE ON THE VERGE OF\rGREATNESS !",
            "[voice:v_asriel][noskip]We miss you "..Player.name.."... A lot...",
            "[voice:monsterfont][noskip]My friends...",
            "[voice:creepy_voice][noskip][color:ff0000][starcolor:ff0000][func:StopMusic]You killed them ALL ! They\rAREN'T your friends ANYMORE !",
            "[voice:monsterfont][noskip][waitall:3]See you soon[w:5].[w:5].[w:5].[w:8]",
            "[noskip]You feel a hole in your heart.\nYou hate this sensation, it's\rworse than loneliness.",
            "[noskip]Something cold go through your\rbody.[w:9][func:KillPlayer]"
        }
        nexttext = "[noskip]Knock em down darling~"
        nexttext = MettatonVoice(nexttext)
        table.insert(text, 17, nexttext)
        --text = {"DED[func:KillPlayer]"}
        BattleDialog(text)
        
        deathtext = {
            "[voice:v_asriel]You can rest...",
            "[voice:v_asriel]But don't forget...",
            "[voice:v_asriel]We miss you..."
        }
    end
end

function KillPlayer()
    Player.hp = 0
end

function DoSetHidders()
    SetHidders()
end

function EnteringState(newstate, oldstate)
    if (oldstate == "ITEMMENU" or oldstate == "ACTMENU" or oldstate == "MERCYMENU" or oldstate == "ENEMYSELECT") and newstate != "ACTIONSELECT" and newstate != "ENEMYSELECT" and newstate != "ACTMENU" then
        HideSign()
    end

    if oldstate == "ENEMYDIALOGUE" and enemies[1]["dialogue"] != 19 then
        State("DEFENDING")
    end

    if newstate == "ENEMYDIALOGUE" then
        HideSign()
    end

    if oldstate == "DEFENDING" and enemies[1]["dialogue"] == 1 then
        State("ENEMYDIALOGUE")
    end

    if oldstate == "ENEMYDIALOGUE" and enemies[1]["dialogue"] == 2 then
        State("ACTIONSELECT")
        Audio.Play()
        ApplySign(signs)
    end

    if oldstate == "ENEMYDIALOGUE" and enemies[1]["dialogue"] == 10 then
        enemies[1].Call("ContinueMusic")
    end

    if newstate == "ACTIONSELECT" and (oldstate == "DEFENDING" or oldstate == "ENEMYDIALOGUE") and enemies[1]["dialogue"] != 2 and enemies[1]["dialogue"] != 18 then
        ApplySign(signs)
    end

    if enemies[1]["dialogue"] == 1 then
        HideSign()
    end

    if newstate == "ENEMYDIALOGUE" then
        HideSign()
    end

    if oldstate == "ENEMYDIALOGUE" and enemies[1]["dialogue"] == 8.5 then
        State("ACTIONSELECT")
    end

    if oldstate == "ENEMYDIALOGUE" and enemies[1]["gave_up"] then
        State("DEFENDING")
        deathtext = {
            "[voice:muffet_voice]You have gone too far...",
            "[voice:muffet_voice]If you are true in your words...",
            "[voice:muffet_voice]You won't come back..."
        }
    end

    if oldstate == "ENEMYDIALOGUE" and enemies[1]["dialogue"] == 17 then
        SetHidders()
    end

    if oldstate == "ENEMYDIALOGUE" and enemies[1]["dialogue"] == 19 and not enemies[1]["gave_up"] then
        State("ACTIONSELECT")
    end

    if oldstate == "DEFENDING" and enemies[1]["dialogue"] == 18 then
        State("ENEMYDIALOGUE")
        SetHidders()
    end

    if newstate == "DEFENDING" and enemies[1]["dialogue"] == 19 then
        ByeHidders()
    end

    if oldstate == "ENEMYSELECT" and newstate == "ATTACKING" and enemies[1]["dialogue"] == 19 then
        final_fight = true
    end
end



function GiveUp()
    gave_up = true
end

function ActiveFinalState()
    final_state = true
end

function UpdateFinalState()
    if final_state then
        final_timer = final_timer + 1
        if final_timer <= 30 then
            final_flash.alpha = final_timer / 30
        elseif final_timer == 60 then
            Audio.PlaySound("hitsound")
            final_flash.alpha = 0
            local someone = CreateSprite("someone", "BelowBullet")
            someone.y = 340
            enemies[1].Call("SetSprite","grounded")
        elseif final_timer == 65 then
            final_flash.color = {0, 0, 0, 1}
        elseif final_timer == 100 then
            HideSign()
            State("DONE")
        end
    end
end