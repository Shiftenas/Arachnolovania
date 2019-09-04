require "purple_soul"
require "karma"

ActivePurple(90,45)
ActiveHorizontal()
spawnwavetimer = 0
spiders = {}
Encounter["wavetimer"] = 1000.0


blaster_right = CreateProjectile("blasters/0",150,200)
blaster_left = CreateProjectile("blasters/0",-150,200)

function Update()
    spawnwavetimer = spawnwavetimer + 1

    PurpleUpdate()

    for i=1,#spiders do
        local spider = spiders[i]
        local angle = spider.GetVar("angle")
        local velx = math.cos(angle)
        local vely = math.sin(angle)
        spider.Move(-velx,-vely)
    end

    left_x = -150 - Player.x
    right_x = 150 - Player.x
    both_y = 200 - Player.y

    right_dist = math.sqrt(right_x * right_x + both_y * both_y)
    right_angle = math.asin(both_y/right_dist) / math.pi * 180
    blaster_right.sprite.rotation = right_angle - 90

    left_dist = math.sqrt(left_x * left_x + both_y * both_y)
    left_angle = math.asin(both_y/left_dist) / math.pi * 180
    blaster_left.sprite.rotation = - (left_angle - 90)
    
    if spawnwavetimer % 60 == 5 then
        blaster_right.sprite.Set("blasters/1")
        blaster_left.sprite.Set("blasters/1")
    end

    if spawnwavetimer % 60 == 10 then
        blaster_right.sprite.Set("blasters/2")
        blaster_left.sprite.Set("blasters/2")
    end

    if spawnwavetimer % 60 == 15 then
        blaster_right.sprite.Set("blasters/3")
        blaster_left.sprite.Set("blasters/3")

        local angle = (blaster_left.sprite.rotation + 90) / 180 * math.pi
        local velx = math.cos(angle)
        local vely = math.sin(angle)
        spider_left = CreateProjectile("spider", -150 - 50 * velx, 200 - 50 * vely)
        spider_left.sprite.rotation = blaster_left.sprite.rotation
        spider_left.SetVar("hurt", true)
        spider_left.SetVar("angle", angle)
        
        local angle = (blaster_right.sprite.rotation + 90) / 180 * math.pi
        local velx = math.cos(angle)
        local vely = math.sin(angle)
        spider_right = CreateProjectile("spider", 150 - 50 * velx, 200 - 50 * vely)
        spider_right.sprite.rotation = blaster_right.sprite.rotation
        spider_right.SetVar("hurt", true)
        spider_right.SetVar("angle", angle)

        table.insert(spiders, spider_left)
        table.insert(spiders, spider_right)
    end
    
    if spawnwavetimer % 60 == 20 then
        blaster_right.sprite.Set("blasters/2")
        blaster_left.sprite.Set("blasters/2")
    end
    
    if spawnwavetimer % 60 == 25 then
        blaster_right.sprite.Set("blasters/1")
        blaster_left.sprite.Set("blasters/1")
    end

    if spawnwavetimer % 60 == 30 then
        blaster_right.sprite.Set("blasters/0")
        blaster_left.sprite.Set("blasters/0")
    end

    if spawnwavetimer == 600 then
        EndWave()
    end
end

function OnHit(bullet)
    if bullet.GetVar("hurt") then
        KarmaHurt()
    end
end