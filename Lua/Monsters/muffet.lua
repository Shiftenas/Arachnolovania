--[[ 
    Muffet, created by Shift', from Modified!Tale
    I'm not the one who has made the music or the sprites
    I didn't create CYF or Undertale, they belongs to their owners
]]
comments = {"Smells like spider webs.", "The music is intense.", "[color:ff0000]Determination.","You feel spiders crawling on\ryour back."}
commands = {"Check",  "Give Up"}
randomdialogue = {"Random\nDialogue\n1.", "Random\nDialogue\n2.", "Random\nDialogue\n3."}

sprite = "muffet" --Always PNG. Extension is added automatically.
name = "Muffet"
hp = 1e9
atk = 1
def = 20
check = "Don't worry about that :3"
dialogbubble = "rightwide" -- See documentation for what bubbles you have available.
canspare = false
cancheck = false
gave_up = false
dialogue = 0
dialogue = 17
musictimer = 0 
secondphase = false

-- Happens after the slash animation but before 
function HandleAttack(attackstatus)
    if attackstatus == -1 then
        -- player pressed fight but didn't press Z afterwards
    else
        if dialogue == 8.5 then
            Audio.Stop()
            dialogue = 9
        end
    end
end
 
-- This handles the commands; all-caps versions of the commands list you have above.
function HandleCustomCommand(command)
    if command == "CHECK" then
        if secondphase then 
            BattleDialog({"MUFFET - 1 ATK 20 DEF\nShe isn't here for laughing\ranymore."})
        else 
            BattleDialog({"MUFFET - 1 ATK 20 DEF\nShe wants to stop you."})
        end
    elseif command == "GIVE UP" then
        BattleDialog({"You tell Muffet that you can't\rhandle it anymore..."})
        gave_up = true
    end
end

function StartChoice()
    Audio.LoadFile("choice")
    Audio.Play()
end

function ContinueMusic()
    Audio.LoadFile("arachnolovania")
    Audio.Play()
    Audio.playtime = musictimer
end

function MuffetLaugh()
    Audio.PlaySound("muffet_laugh")
end

function ChangeSprite()
    SetSprite("angry_muffet")
end

function FirstSprite()
    SetSprite("muffet")
end

function EnemyDialogueStarting()
    BindToArena(false, true)
    if not gave_up then
        if dialogue == 0 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none]You know why I'm \nhere, didn't you ?",
                "[noskip][voice:muffet_voice][effect:none]You just murdered\neveryone of them.",
                "[noskip][voice:muffet_voice][effect:none]And...",
                "[noskip][voice:muffet_voice][effect:none]It makes you smile.",
                "[noskip][voice:muffet_voice][effect:none]I just didn't\nunderstand...",
                "[noskip][voice:muffet_voice][effect:none]But I want to know...",
                "[noskip][voice:muffet_voice][effect:none]It just please you,\ndidn't it ?",
                "[noskip][voice:muffet_voice][effect:rotate,4.0][func:MuffetLaugh]Ahuhuhuhu~",
                "[noskip][voice:muffet_voice][effect:none][waitall:4][color:d535d9]Now[novoice] [voice:muffet_voice]my[novoice] [voice:muffet_voice]turn."
            } 
            dialogue = 1
        elseif dialogue == 1 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none]That was so cute\nseeing you moving\nthat way."
            }
            dialogue = 2
        elseif dialogue == 2 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none]He teach me how\nto be a great\nopponent."
            }
            dialogue = 3
            Encounter["signs"] = {"croissant", "spider"}
            Encounter["nextwaves"] = {"following_blaster"}
        elseif dialogue == 3 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none]And how to use\nall of my power."
            }
            dialogue = 4
            Encounter["signs"] = {"donut", "spider"}
            Encounter["nextwaves"] = {"colored_spider"}
        elseif dialogue == 4 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none]And when I was\nready,[w:3] he gave me\nthis shirt.",
                "[noskip][voice:muffet_voice][effect:none]He surely wanted me\nto be like him,[w:3] but\nI can barely make\nwith his puns."
            }
            dialogue = 5
            Encounter["signs"] = {"croissant", "donut", "spider"}
            Encounter["nextwaves"] = {"bouncy_bouncy"}
        elseif dialogue == 5 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none]I was the one\nthat he chose,[w:3]\neven his brother\nwasn't \"worthy\".",
                "[noskip][voice:muffet_voice][effect:none]Yes,[w:3] it's surely\nbecause he's too\nkind."
            }
            dialogue = 6
            Encounter["signs"] = {"croissant", "donut"}
            Encounter["nextwaves"] = {"all_for_one"}
        elseif dialogue == 6 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none]And we trained...",
                "[noskip][voice:muffet_voice][effect:none]Days,[w:3] weeks,[w:3]\nmonths...",
                "[noskip][voice:muffet_voice][effect:none]Perhaps years ?"
            }
            dialogue = 7
            Encounter["signs"] = {"cupcake"}
            Encounter["nextwaves"] = {"bouncy_boomerang"}
        elseif dialogue == 7 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none]He even let me\nkeep my lovely pet."
            }
            Encounter["signs"] = {"question_mark"}
            Encounter["nextwaves"] = {"cupcake"}
            dialogue = 8
        elseif dialogue == 8 then
            musictimer = Audio.playtime
            Audio.Stop()
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none]You're not going\nto stop,[w:3] are you ?",
                "[noskip][voice:muffet_voice][effect:none]...",
                "[noskip][voice:muffet_voice][effect:none]So listen...",
                "[noskip][voice:muffet_voice][effect:none][func:StartChoice]I know somewhere,[w:3]\nperhaps in your\nheart...",
                "[noskip][voice:muffet_voice][effect:none]There is a great\nperson.",
                "[noskip][voice:muffet_voice][effect:none]A great person,[w:3] who\njust want his\nfriend's hapiness.",
                "[noskip][voice:muffet_voice][effect:none]So,[w:3] put this weapon\ndown,[w:3] and...",
                "[noskip][voice:muffet_voice][effect:none]And I'll let you\nrestart everything.",
                "[noskip][voice:muffet_voice][effect:none]Because I'm sure\nthat you can make\nit better for\neveryone."
            }
            comments = {"Muffet lets you a chance."}
            dialogue = 8.5
        elseif dialogue == 8.5 then
            currentdialogue = {"[noskip][voice:muffet_voice][effect:none]..."}
        elseif dialogue == 9 then
            omments = {"Smells like spider webs.", "The music is intense.", "[color:ff0000]Determination.","You feel spiders crawling on\ryour back."}
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none]So,[w:3] it's like that,[w:3]\nhuh ?",
                "[noskip][voice:muffet_voice][effect:none]Well,[w:3] [func:ChangeSprite][color:d535d9]you asked for\nit."
            }
            secondphase = true
            Encounter["signs"] = {"spider", "spider"}
            Encounter["nextwaves"] = {"switch_attack"}
            dialogue = 10
        elseif dialogue == 10 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]I hoped that I don't\narrive to this point,[w:3]\nbut...",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]You leaved me no\nchoice."
            }
            Encounter["signs"] = {"donut", "spider", "donut"}
            Encounter["nextwaves"] = {"following_blaster2"}
            dialogue = 11
        elseif dialogue == 11 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]If you want me to\nstop,[w:3] you can\nalways try to give\nup.",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]But I'm not sure\nto let you go."
            }
            Encounter["signs"] = {"croissant", "spider", "croissant"}
            Encounter["nextwaves"] = {"bouncy_bouncy2"}
            dialogue = 12
        elseif dialogue == 12 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]All I wanted was to\nstop you.",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]Perhaps fighting\nisn't the right thing\nto do ?",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]But it's the only one\nthat YOU do."
            }
            Encounter["signs"] = {"croissant", "spider", "donut"}
            Encounter["nextwaves"] = {"colored_spider2"}
            dialogue = 13
        elseif dialogue == 13 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]And I thought, that\na [color:ff0000]special attack\n[color:d535d9]would be efficient\nagainst you.",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]Just saying."
            }
            Encounter["signs"] = {"croissant", "donut"}
            Encounter["nextwaves"] = {"one_for_all"}
            dialogue = 14
        elseif dialogue == 14 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]It seems like the\n[color:ff0000]\"special attack\" [color:d535d9]\nis enough to\nscare you.",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]Again, just saying."
            }
            Encounter["signs"] = {"cupcake"}
            Encounter["nextwaves"] = {"bouncy_boomerang2"}
            dialogue = 15
        elseif dialogue == 15 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]Still alive ?",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]Well, if you survive\nthis one, you'll see\nmy [color:ff0000]special attack[color:d535d9]."
            }
            Encounter["signs"] = {"question_mark"}
            Encounter["nextwaves"] = {"cupcake2"}
            dialogue = 16
        elseif dialogue == 16 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]Not bad.[w:3] Not bad\nat all.",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]But, be aware of\nmy [color:ff0000]special attack[color:d535d9].",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]...",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9][func:FirstSprite]That sounds better\nwhen he says it."
            }
            dialogue = 17
            comments = {"What's happenning ?"}
            Encounter["signs"] = {"spider", "cupcake", "croissant"}
            Encounter["nextwaves"] = {"destroy_arena"}
        elseif dialogue == 17 then
            currentdialogue = {
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]You didn't expect\nthis, did you ?",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]In fact, I don't\nknow what you could\nexpect.",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]Maybe you expected\nit, because you\nalready killed\nme ?",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]Just kidding.",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9].....",
                "[noskip][voice:muffet_voice][effect:none][color:d535d9]Unless ?"
            }
            currentdialogue = {
                "F"
            }
            Encounter["nextwaves"] = {"final_attack"}
        end
    else 
        Audio.Stop()
        currentdialogue = {
            "[noskip][voice:muffet_voice][effect:none]You stop ?",
            "[noskip][voice:muffet_voice][effect:none]It's too\ndifficult ?",
            "[noskip][voice:muffet_voice][effect:none]...",
            "[noskip][voice:muffet_voice][effect:none][func:FirstSprite]It's too bad...",
            "[noskip][voice:muffet_voice][effect:none]You should\nhave stop from\nthe very\nbeginning...",
            "[noskip][voice:muffet_voice][effect:none][color:ff0000]But my pet is\ngoing to enjoy his\nmeal."
        }
        Encounter["nextwaves"] = {"death"}
        Encounter["wavetimer"] = 10000.0
    end
end