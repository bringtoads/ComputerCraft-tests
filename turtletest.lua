-- Home coordinates
local homeX, homeY, homeZ = 93, 38, 73

-- Boundaries
local maxX, maxY, maxZ = 500, 500, 500

-- Direction: 0 = North, 1 = East, 2 = South, 3 = West
local x, y, z = homeX, homeY, homeZ -- Start at home coordinates
local direction = 0 -- 0 = North, 1 = East, 2 = South, 3 = West

-- Target depth
local targetDepth = -53

-- Function to initialize the Turtle
local function init()
    print("Turtle initialization started.")

    -- Refuel if the turtle is low on fuel
    if turtle.getFuelLevel() < 100 then
        print("Low fuel. Please refuel the turtle.")
        return false -- Abort initialization
    end

    print("Turtle initialized with enough fuel.")
    return true -- Initialization successful
end

-- Function to move the turtle forward and update coordinates
local function moveForward()
    if turtle.forward() then
        if direction == 0 then z = z + 1
        elseif direction == 1 then x = x + 1
        elseif direction == 2 then z = z - 1
        elseif direction == 3 then x = x - 1
        end
        return true
    else
        print("Failed to move forward.")
        return false
    end
end

-- Function to dig straight down
local function digDown()
    while turtle.detectDown() do
        turtle.digDown()
    end
end

-- Function to dig down to the target depth
local function digToDepth()
    print("Diving down to depth " .. targetDepth .. "...")
    while y > targetDepth do
        digDown()
        if turtle.down() then
            y = y - 1
        else
            print("Cannot go down anymore.")
            return false -- Stop if we can't go down anymore
        end
    end
    print("Reached target depth: " .. targetDepth)
    return true
end

-- Function to check if inventory is full
local function isInventoryFull()
    for slot = 1, 16 do
        if turtle.getItemCount(slot) == 0 then
            return false
        end
    end
    return true
end

-- Function to mine for diamonds and strip mine
local function mineForDiamonds()
    if not digToDepth() then
        return
    end

    -- Strip mining in a 2D pattern
    local stripLength = 10 -- Length of each strip
    for i = 1, stripLength do
        -- Check if inventory is full
        if isInventoryFull() then
            print("Inventory full, returning to start.")
            returnHome()
            break
        end

        -- Dig forward
        digForward()
        if not moveForward() then
            print("Unable to move forward, stopping mining.")
            returnHome()  -- Turtle returns home if it can't move forward
            break
        end

        -- Check if the block in front contains diamonds
        local success, block = turtle.inspect()
        if success and block.name == "minecraft:diamond_ore" then
            print("Diamond ore found!")
            turtle.dig()
        end

        -- Check fuel level
        if turtle.getFuelLevel() < 100 then
            print("Low fuel, returning to start.")
            returnHome()  -- Turtle returns home if low on fuel
            break
        end

        -- Sleep to prevent rapid execution
        sleep(0.5)
    end

    -- Turn around to return home after strip mining
    turnToDirection(2) -- Face South
    for i = 1, stripLength do
        moveForward()
    end
    turnToDirection(3) -- Face West
end

-- Function to return home by retracing steps
local function returnHome()
    print("Returning to home base...")
    while z < homeZ do
        turnToDirection(0) -- Face North
        moveForward()
        z = z + 1
    end
    while x < homeX do
        turnToDirection(1) -- Face East
        moveForward()
        x = x + 1
    end
    print("Turtle returned home.")
end

-- Function to turn to a specific direction
local function turnToDirection(targetDirection)
    while direction ~= targetDirection do
        turnRight()
    end
end

-- Main execution
if init() then
    print("Starting mining operation for diamonds...")
    mineForDiamonds()
else
    print("Initialization failed.")
end
