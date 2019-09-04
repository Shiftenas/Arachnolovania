updating = false
hidetimer = 0

function SetHidders()
    up_hidder = CreateSprite("h_hidder", "BelowPlayer")
    up_hidder.x = 320
    up_hidder.y = 227
    up_hidder.color = {0, 0, 0}

    down_hidder = CreateSprite("h_hidder", "BelowPlayer")
    down_hidder.x = 320
    down_hidder.y = 92
    down_hidder.color = {0, 0, 0}

    left_hidder = CreateSprite("v_hidder", "BelowPlayer")
    left_hidder.x = 32
    left_hidder.y = 160
    left_hidder.color = {0, 0, 0}

    right_hidder = CreateSprite("v_hidder", "BelowPlayer")
    right_hidder.x = 607
    right_hidder.y = 160
    right_hidder.color = {0, 0, 0}
end

function ByeHidders()
    up_hidder.remove()
    left_hidder.remove()
    down_hidder.remove()
    right_hidder.remove()
end
