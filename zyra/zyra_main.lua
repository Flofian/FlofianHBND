local menu = module.load(header.id, 'zyra/zyra_menu')
local common = module.load(header.id, 'common')
local evade = module.seek("evade")
local orb = module.internal('orb')
local pred = module.internal("pred");
local TS = module.internal("TS")
local circle_quality = 64
local bool_to_number = { [true] = 1, [false] = 0 }


local SeedName = "ZyraSeed"
local RangedPlantName = "ZyraThornPlant"
local MeleePlantName = "ZyraGraspingPlant"

local function drawSeedPlantLoop(obj)
    if menu.draws.drawSeeds:get() then
        if obj.charName == SeedName then
            graphics.draw_circle(obj.pos, 20, 5, menu.draws.colors.colorSeeds:get(), circle_quality)
        end
    end
    if menu.draws.drawPlants:get() then
        if obj.charName == RangedPlantName then
            graphics.draw_circle(obj.pos, 575, 3, menu.draws.colors.colorRangedPlants:get(), circle_quality)
        end
        if obj.charName == MeleePlantName then
            graphics.draw_circle(obj.pos, 400, 3, menu.draws.colors.colorMeleePlants:get(), circle_quality)
        end
    end
end

local function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ',\n'
        end
        return s .. '} '
    else
        return tostring(o)
    end
end


local function drawRanges()
    if (menu.draws.drawOnlyAlive:get() and player.isDead) or not graphics.get_draw() then
        return
    end
    objManager.loop(drawSeedPlantLoop)
    if menu.draws.drawQ:get() and (not menu.draws.drawOnlyReady:get() or player:spellSlot(0).state == 0) then
        graphics.draw_circle(player.pos, 800, 3, menu.draws.colors.colorQ:get(), circle_quality)
    end
    if menu.draws.drawW:get() and (not menu.draws.drawOnlyReady:get() or player:spellSlot(1).state == 0) then
        graphics.draw_circle(player.pos, 850, 3, menu.draws.colors.colorW:get(), circle_quality)
    end
    if menu.draws.drawE:get() and (not menu.draws.drawOnlyReady:get() or player:spellSlot(2).state == 0) then
        graphics.draw_circle(player.pos, 1100, 3, menu.draws.colors.colorE:get(),
            circle_quality)
    end
    if menu.draws.drawR:get() and (not menu.draws.drawOnlyReady:get() or player:spellSlot(3).state == 0) then
        graphics.draw_circle(player.pos, 700, 3, menu.draws.colors.colorR:get(), circle_quality)
    end
end
cb.add(cb.draw, drawRanges)



print('Flofian Zyra Loaded!')
chat.print('Flofian Zyra Loaded!')
