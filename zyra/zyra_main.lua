local menu = module.load(header.id, 'zyra/zyra_menu')
local common = module.load(header.id, 'common')
local evade = module.seek("evade")
local orb = module.internal('orb')
local pred = module.internal("pred");
local TS = module.internal("TS")
local clip = module.internal('clipper')
local polygon = clip.polygon
local polygons = clip.polygons
local clipper = clip.clipper()
local clipper_enum = clip.enum
local circle_quality = 64
local clipperCircleCount = 32
local bool_to_number = { [true] = 1, [false] = 0 }


local SeedName = "ZyraSeed"
local RangedPlantName = "ZyraThornPlant"
local MeleePlantName = "ZyraGraspingPlant"
RangedPlantsPolygons = polygons()
MeleePlantsPolygons = polygons()

local Qp = {width = 1200, length = 600}

local function planttopolygon(obj, range)
    local pos = obj.pos2D
    local p = polygon()
    for i = 0, circle_quality do
        p:Add(vec2(pos.x + range * math.cos(i * 2 * math.pi / clipperCircleCount),
            pos.y + range * math.sin(i * 2 * math.pi / clipperCircleCount)))
    end
    return p
end

local function drawSeedPlantLoop(obj)
    if menu.draws.drawSeeds:get() then
        if obj.charName == SeedName then
            graphics.draw_circle(obj.pos, 20, 5, menu.draws.colors.colorSeeds:get(), circle_quality)
        end
    end
    if menu.draws.drawPlants:get() and not menu.draws.combinePlants:get() then
        if obj.charName == RangedPlantName then
            graphics.draw_circle(obj.pos, 575, 1, menu.draws.colors.colorRangedPlants:get(), circle_quality)
        end
        if obj.charName == MeleePlantName then
            graphics.draw_circle(obj.pos, 400, 1, menu.draws.colors.colorMeleePlants:get(), circle_quality)
        end
    end
end

local function drawClipperPolygonWorld(p, width, color)
    local childcount = p:ChildCount()
    for i = 0, childcount - 1 do
        local v = p:Childs(i):toGame3D()
        local w = p:Childs((i + 1) % childcount):toGame3D()
        graphics.draw_line(v, w, width, color)
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
local function ts_filter_basic(res, object, dist)
    --copyd from DalandanAIO
    if object and common.isValidTarget(object) and common.isEnemy(object) then
        if (object.buff["rocketgrab"]) then return end
        res.object = object
        return true
    end
end

local function isGoodPlantSpot(range, pos)
    local target = TS.get_result(ts_filter_basic, nil, nil, true).object
    if target == nil then return false end
    if player.pos:dist(target.pos) > range+850 then return false end
    local enemyMinions = objManager.minions[TEAM_ENEMY]
    local targetbb = target.boundingRadius* bool_to_number[menu.passive.useBoundingRadius:get()]
    for i=0, enemyMinions.size-1 do
        local minion = enemyMinions[i]
        if pos:dist(minion.pos)*menu.passive.goodSpotInter:get()/100 < pos:dist(target.pos)+targetbb or pos:dist(target.pos) > range then
            return false
        end
    end
    local jungle = objManager.minions[TEAM_NEUTRAL]
    for i=0, jungle.size-1 do
        local junglem = jungle[i]
        if pos:dist(junglem.pos)*menu.passive.goodSpotInter:get()/100 < pos:dist(target.pos)+targetbb or pos:dist(target.pos) > range then
            return false
        end
    end
    return true
end

local function drawPlantSpot(pos)
    if navmesh.isWall(pos) then pos = player:getPassablePos(pos) end
    if isGoodPlantSpot(575, pos) then
        graphics.draw_circle(pos, 35, 3, menu.draws.colors.colorRangedPlants:get(), circle_quality)
    end
    if isGoodPlantSpot(400, pos) then
        graphics.draw_circle(pos, 30, 3, menu.draws.colors.colorMeleePlants:get(), circle_quality)
    end
end

local function drawRanges()
    if (menu.draws.drawOnlyAlive:get() and player.isDead) or not graphics.get_draw() then
        return
    end
    if menu.draws.combinePlants:get() then
        RangedPlantsPolygons = polygons()
        MeleePlantsPolygons = polygons()
        objManager.loop(function(obj)
            if obj.charName == RangedPlantName then
                RangedPlantsPolygons:Add(planttopolygon(obj, 575))
            
            elseif obj.charName == MeleePlantName then
                MeleePlantsPolygons:Add(planttopolygon(obj, 400))
            end
        end)
        if RangedPlantsPolygons:ChildCount() > 0 then
            clipper:Clear()
            clipper:AddPaths(RangedPlantsPolygons, clipper_enum.PolyType.Clip, true)
            local ps = clipper:Execute(clipper_enum.ClipType.Union, clipper_enum.PolyFillType.Positive,
                clipper_enum.PolyFillType.Positive)
            for i = 0, ps:ChildCount() - 1 do
                local p = ps:Childs(i)
                if menu.draws.useWorldHeight:get() then
                    drawClipperPolygonWorld(p, 5, menu.draws.colors.colorRangedPlants:get())
                else
                    p:Draw3D(player.pos.y, 5, menu.draws.colors.colorRangedPlants:get())
                end
            end
        end
        if MeleePlantsPolygons:ChildCount() > 0 then
            clipper:Clear()
            clipper:AddPaths(MeleePlantsPolygons, clipper_enum.PolyType.Clip, true)
            local ps = clipper:Execute(clipper_enum.ClipType.Union, clipper_enum.PolyFillType.Positive,
                clipper_enum.PolyFillType.Positive)
            for i = 0, ps:ChildCount() - 1 do
                local p = ps:Childs(i)
                if menu.draws.useWorldHeight:get() then
                    drawClipperPolygonWorld(p, 5, menu.draws.colors.colorMeleePlants:get())
                else
                    p:Draw3D(player.pos.y, 5, menu.draws.colors.colorMeleePlants:get())
                end
            end
        end
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
    if menu.draws.drawGoodSpot:get() then
        drawPlantSpot(game.mousePos)
        objManager.loop(function(obj)
            if obj.charName == SeedName then
                drawPlantSpot(obj.pos)
            end
        end)
    end
end
cb.add(cb.draw, drawRanges)




print('Flofian Zyra Loaded!')
chat.print('Flofian Zyra Loaded!')
