local menu = module.load(header.id, 'nami/nami_menu')
local common = module.load(header.id, 'common')
local evade = module.seek("evade")
local orb = module.internal('orb')
local pred = module.internal("pred");
local TS = module.internal("TS")
local circle_quality = 64
local bool_to_number = { [true] = 1, [false] = 0 }
local spell_dir = { [0] = "Q", [1] = "W", [2] = "E", [3] = "R" }

local SpellQ = {
    delay = 1,
    radius = 100,
    range = 850,
    speed = math.huge,
    boundingRadiusMod = 0,
    collision = { hero = false, minion = false, wall = true }
}
local SpellW = {
    range = 725,
    bounceRange = 800,
    boundingRadiusMod = 0,
    missileSpeed = 1500, --? 2000? 2500?
}
local SpellE = {
    range = 800,
    boundingRadiusMod = 0
}
local SpellR = {
    range = 1000,
    speed = 850,
    width = 250,
    delay = 0.5,
    boundingRadiusMod = 1
}
local interruptableSpells = {
    ["fiddlesticks"] = {
        { menuslot = "R", slot = 3, spellname = "crowstorm", channelduration = 1.5, danger = 2 },
        { menuslot = "W", slot = 1, spellname = "drain",     channelduration = 5,   danger = 1 },
    },
    ["janna"] = {
        { menuslot = "R", slot = 3, spellname = "reapthewhirlwind", channelduration = 3, danger = 1 }
    },
    ["karthus"] = {
        { menuslot = "R", slot = 3, spellname = "karthusfallenone", channelduration = 3, danger = 2 }
    },
    ["katarina"] = {
        { menuslot = "R", slot = 3, spellname = "katarinar", channelduration = 2.5, danger = 2 }
    },
    ["malzahar"] = {
        { menuslot = "R", slot = 3, spellname = "malzaharr", channelduration = 2.5, danger = 2 }
    },
    ["masteryi"] = {
        { menuslot = "W", slot = 1, spellname = "meditate", channelduration = 4, danger = 1 }
    },
    ["missfortune"] = {
        { menuslot = "R", slot = 3, spellname = "missfortunebullettime", channelduration = 3, danger = 2 }
    },
    ["nunu"] = {
        { menuslot = "R", slot = 3, spellname = "absolutezero", channelduration = 3, danger = 2 }
    },
    ["pantheon"] = {
        { menuslot = "R", slot = 3, spellname = "pantheonrjump", channelduration = 2, danger = 1 }
    },
    ["shen"] = {
        { menuslot = "R", slot = 3, spellname = "shenr", channelduration = 3, danger = 1 }
    },
    ["twistedfate"] = {
        { menuslot = "R", slot = 3, spellname = "gate", channelduration = 1.5, danger = 1 }
    },
    ["varus"] = {
        { menuslot = "Q", slot = 0, spellname = "varusq", channelduration = 4, danger = 1 }
    },
    ["xerath"] = {
        { menuslot = "R", slot = 3, spellname = "xerathlocusofpower2", channelduration = 3, danger = 2 }
    }
}

local function spellSlotToLetter(spell)
    if spell.isBasicAttack then return "AA" end
    local s = spell.slot
    if s >= 0 and s <= 3 then
        return spell_dir[s]
    else
        return -1
    end
end

local function autoEOnSpell(spell)
    if menu.automatic.recall:get() and player.isRecalling then return end
    if menu.e.eCombo:get() and not orb.menu.combat.key:get() then return end
    if player:spellSlot(2).state ~= 0 then return end
    if player.mana < player.manaCost2 then return end
    if spell.owner.type ~= TYPE_HERO or spell.owner.team ~= TEAM_ALLY then return end
    if spell.owner.pos:dist(player.pos) > 800 then return end
    --chat.print(spell.name)
    --chat.print(spell.owner.charName .. " " .. spell.slot)
    if not menu.e[spell.owner.charName] then return end -- this should fix new champs during game like soraka bot in nexus blitz
    if not menu.e.eOnSpells:get() then return end
    if not menu.e[spell.owner.charName].use:get() then return end
    if menu.e.eSpellTargetOverwrite:get() and not spell.hasTarget then return end
    if menu.e.eSpellAAOverwrite:get() and not spell.isBasicAttack then return end
    local spellSlot = spellSlotToLetter(spell)
    if spellSlot == -1 then return end
    if spell.hasTarget and not (spell.target.type == TYPE_HERO and spell.target.team == TEAM_ENEMY) then
        --chat.print("Not using on targeted " .. spell.owner.charName .. " " .. spellSlot)
        return
    end
    local allowed = menu.e[spell.owner.charName][spellSlot]:get()
    if allowed then
        --chat.print("Using on " .. spell.owner.charName .. " " .. spellSlot)
        local target = spell.owner
        player:castSpell("obj", 2, target)
        if menu.info.debug:get() then
            chat.print("Using E on " .. spell.owner.charName .. " " .. spellSlot)
        end
    else
        --chat.print("Not using on " .. spell.owner.charName .. " " .. spellSlot)
    end
end
cb.add(cb.spell, autoEOnSpell)

local function autoWHeal()
    if not menu.automatic.autoWHeal:get() then return end
    if player.mana / player.maxMana < menu.automatic.autoWHealMana:get() / 100 then return end
    if menu.automatic.recall:get() and player.isRecalling then return end
    if player:spellSlot(1).state ~= 0 then return end
    if player.mana < player.manaCost1 then return end
    for i = 0, objManager.allies_n - 1 do
        local ally = objManager.allies[i]
        if ally and ally.isVisible and ally.isTargetable and ally.isAlive and ally.health / ally.maxHealth < menu.automatic.autoWunder[ally.charName]:get() / 100 and ally.pos:dist(player.pos) < 725 then
            player:castSpell("obj", 1, ally)
            if menu.info.debug:get() then
                chat.print("Auto Using W for Heal on " .. ally.charName)
            end
            return
        end
    end
end
cb.add(cb.tick, autoWHeal)

local function AutoQCCTraceFilter(seg, obj)
    if seg.startPos:dist(seg.endPos) > 850 then return false end

    if pred.trace.circular.hardlock(SpellQ, seg, obj) then
        return true
    end
    if pred.trace.circular.hardlockmove(SpellQ, seg, obj) then
        return true
    end
    return false
end

local function AutoQCCTargetFilter(res, obj, dist)
    if dist > 1100 then return false end
    local seg = pred.circular.get_prediction(SpellQ, obj)
    if not seg then return false end
    if not AutoQCCTraceFilter(seg, obj) then return false end

    res.pos = seg.endPos
    return true
end

local function autoQCC()
    if menu.automatic.recall:get() and player.isRecalling then return end
    if player:spellSlot(0).state ~= 0 then return end
    if player.mana < player.manaCost0 then return end
    local mode = menu.automatic.autoQCC:get()
    if mode == 1 then return end
    if mode == 3 then
        for i = 0, objManager.enemies_n - 1 do
            local enemy = objManager.enemies[i]
            if enemy and enemy.isVisible and enemy.isTargetable and enemy.isAlive and enemy.pos:dist(player.pos) < 850 then
                if enemy.buff[BUFF_STUN] or enemy.buff[BUFF_SNARE] or enemy.buff[BUFF_SUPPRESSION] or enemy.buff[BUFF_KNOCKUP] then
                    player:castSpell("pos", 0, enemy.pos)
                    if menu.info.debug:get() then
                        chat.print("Auto Using Q CC Static on " .. enemy.charName)
                    end
                    return
                end
            end
        end
    end
    if mode == 2 then
        local res = TS.get_result(AutoQCCTargetFilter)
        if res.pos then
            player:castSpell("pos", 0, vec3(res.pos.x, mousePos.y, res.pos.y))
            if menu.info.debug:get() then
                chat.print("Auto Using Q CC Prediction") --on " .. res.charName)
            end
            return
        end
    end
end
cb.add(cb.tick, autoQCC)

local function AutoQGapcloseTraceFilter(seg, obj)
    if seg.startPos:dist(seg.endPos) > 950 then return false end
    if obj.path.isActive and obj.path.isDashing then
        return true
    end
end

local function AutoQGapcloseTargetFilter(res, obj, dist)
    if dist > 1100 then return false end
    local seg = pred.circular.get_prediction(SpellQ, obj)
    if not seg then return false end
    if not AutoQGapcloseTraceFilter(seg, obj) then return false end

    res.pos = seg.endPos
    return true
end

local function autoQGapclose()
    if menu.automatic.recall:get() and player.isRecalling then return end
    if player:spellSlot(0).state ~= 0 then return end
    if player.mana < player.manaCost0 then return end
    local mode = menu.automatic.autoQGapclose:get()
    if mode == 1 then return end
    if mode == 2 then
        local seg = {}
        local target = TS.get_result(
            function(res, obj, dist)
                if dist <= SpellQ.range and obj.path.isActive and obj.path.isDashing then
                    res.obj = obj
                    return true
                end
            end
        ).obj
        if target then
            local pred_pos = pred.core.lerp(target.path, SpellQ.delay, target.path.dashSpeed)
            if pred_pos and pred_pos:dist(player.path.serverPos2D) <= SpellQ.range then
                seg.startPos = player.path.serverPos2D
                seg.endPos = vec2(pred_pos.x, pred_pos.y)
                player:castSpell("pos", 2, vec3(pred_pos.x, target.y, pred_pos.y))
            end
        end
    end
    if mode == 3 then
        local res = TS.get_result(AutoQGapcloseTargetFilter)
        if res.pos then
            player:castSpell("pos", 0, vec3(res.pos.x, mousePos.y, res.pos.y))
            if menu.info.debug:get() then
                chat.print("Auto Using Q Gapclose Prediction") --on " .. res.charName)
            end
            return
        end
    end
end
cb.add(cb.tick, autoQGapclose)

local function interrupt(spell)
    if menu.automatic.recall:get() and player.isRecalling then return end
    if menu.automatic.interruptQ:get() or menu.automatic.interruptR:get() then
        if spell.owner.type == TYPE_HERO and spell.owner.team == TEAM_ENEMY then
            local n = string.lower(spell.owner.charName)
            if interruptableSpells[n] then
                for _, ispell in pairs(interruptableSpells[n]) do
                    if string.lower(spell.name) == ispell.spellname then
                        -- Q Check
                        if menu.automatic.interruptQ:get() and player:spellSlot(0).state == 0 and player.mana >= player.manaCost0
                            and menu.automatic.interruptSpells[n .. ispell.menuslot]:get() >= 1 and player.pos:dist(spell.owner.pos) < SpellQ.range then
                            player:castSpell("pos", 0, spell.owner.pos)
                            if menu.info.debug:get() then
                                chat.print("Interrupting " .. spell.owner.charName .. " " .. ispell.menuslot .. " with Q")
                            end
                            return
                            -- R Check
                        elseif menu.automatic.interruptR:get() and player:spellSlot(3).state == 0 and player.mana >= player.manaCost3
                            and menu.automatic.interruptSpells[n .. ispell.menuslot]:get() >= 2 and player.pos:dist(spell.owner.pos) < SpellR.range then
                            player:castSpell("pos", 3, spell.owner.pos)
                            if menu.info.debug:get() then
                                chat.print("Interrupting " .. spell.owner.charName .. " " .. ispell.menuslot .. " with R")
                            end
                            return
                        end
                    end
                end
            end
        end
    end
end
cb.add(cb.spell, interrupt)


local function autoWTripleBounce()
    if menu.automatic.recall:get() and player.isRecalling then return end
    if player:spellSlot(1).state ~= 0 then return end
    if player.mana < player.manaCost1 then return end
    local mode = menu.automatic.autoWTripleBounce:get()
    if mode == 1 then return end
    if mode == 2 then
        --starting with enemy
        for i = 0, objManager.enemies_n - 1 do
            local enemy = objManager.enemies[i]
            if enemy and enemy.isVisible and enemy.isTargetable and enemy.isAlive and enemy.pos:dist(player.pos) < 725 then
                for j = 0, objManager.allies_n - 1 do
                    local ally = objManager.allies[j]
                    if ally and ally.isVisible and ally.isTargetable and ally.isAlive and ally.pos:dist(enemy.pos) < SpellW.bounceRange then
                        for k = 0, objManager.enemies_n - 1 do
                            local enemy2 = objManager.enemies[k]
                            if enemy2 and enemy2 ~= enemy and enemy2.isVisible and enemy2.isTargetable and enemy2.isAlive and enemy2.pos:dist(ally.pos) < SpellW.bounceRange then
                                player:castSpell("obj", 1, enemy)
                                if menu.info.debug:get() then
                                    chat.print("Auto W 3 Simple " ..
                                        enemy.charName .. " to " .. ally.charName .. " to " .. enemy2.charName)
                                end
                                return
                            end
                        end
                    end
                end
            end
        end
        --starting with ally
        for i = 0, objManager.allies_n - 1 do
            local ally = objManager.allies[i]
            if ally and ally.isVisible and ally.isTargetable and ally.isAlive and ally.pos:dist(player.pos) < 725 then
                for j = 0, objManager.enemies_n - 1 do
                    local enemy = objManager.enemies[j]
                    if enemy and enemy.isVisible and enemy.isTargetable and enemy.isAlive and enemy.pos:dist(ally.pos) < SpellW.bounceRange then
                        for k = 0, objManager.allies_n - 1 do
                            local ally2 = objManager.allies[k]
                            if ally2 and ally2 ~= ally and ally2.isVisible and ally2.isTargetable and ally2.isAlive and ally2.pos:dist(enemy.pos) < SpellW.bounceRange then
                                player:castSpell("obj", 1, ally)
                                if menu.info.debug:get() then
                                    chat.print("Auto W 3 Simple " ..
                                        ally.charName .. " to " .. enemy.charName .. " to " .. ally2.charName)
                                end
                                return
                            end
                        end
                    end
                end
            end
        end
    end
    if mode == 3 then
        --starting with enemy
        for i = 0, objManager.enemies_n - 1 do
            local enemy = objManager.enemies[i]
            local distanceTravelled = player.pos:dist(enemy.pos)
            if enemy and enemy.isVisible and enemy.isTargetable and enemy.isAlive and enemy.pos:dist(player.pos) < 725 then
                for j = 0, objManager.allies_n - 1 do
                    local ally = objManager.allies[j]
                    local allypos = pred.core.get_pos_after_time(ally, distanceTravelled / SpellW.missileSpeed)
                    if ally and ally.isVisible and ally.isTargetable and ally.isAlive and allypos:dist(enemy.pos2D) < SpellW.bounceRange then
                        distanceTravelled = distanceTravelled + allypos:dist(enemy.pos2D)
                        for k = 0, objManager.enemies_n - 1 do
                            local enemy2 = objManager.enemies[k]
                            if enemy2 and enemy2 ~= enemy and enemy2.isVisible and enemy2.isTargetable and enemy2.isAlive and pred.core.get_pos_after_time(enemy2, distanceTravelled / SpellW.missileSpeed):dist(allypos) < SpellW.bounceRange then
                                player:castSpell("obj", 1, enemy)
                                if menu.info.debug:get() then
                                    chat.print("Auto W 3 Pred " ..
                                        enemy.charName .. " to " .. ally.charName .. " to " .. enemy2.charName)
                                end
                                return
                            end
                        end
                    end
                end
            end
        end
        --starting with ally
        for i = 0, objManager.allies_n - 1 do
            local ally = objManager.allies[i]
            local distanceTravelled = player.pos:dist(ally.pos)
            if ally and ally.isVisible and ally.isTargetable and ally.isAlive and ally.pos:dist(player.pos) < 725 then
                for j = 0, objManager.enemies_n - 1 do
                    local enemy = objManager.enemies[j]
                    local enemypos = pred.core.get_pos_after_time(enemy, distanceTravelled / SpellW.missileSpeed)
                    if enemy and enemy.isVisible and enemy.isTargetable and enemy.isAlive and enemypos:dist(ally.pos2D) < SpellW.bounceRange then
                        distanceTravelled = distanceTravelled + enemypos:dist(ally.pos2D)
                        for k = 0, objManager.allies_n - 1 do
                            local ally2 = objManager.allies[k]
                            if ally2 and ally2 ~= ally and ally2.isVisible and ally2.isTargetable and ally2.isAlive and pred.core.get_pos_after_time(ally2, distanceTravelled / SpellW.missileSpeed):dist(enemypos) < SpellW.bounceRange then
                                player:castSpell("obj", 1, ally)
                                if menu.info.debug:get() then
                                    chat.print("Auto W 3 Pred " ..
                                        ally.charName .. " to " .. enemy.charName .. " to " .. ally2.charName)
                                end
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end
cb.add(cb.tick, autoWTripleBounce)

local function comboQBuffTarget(res, obj, dist)
    if dist < SpellQ.range and obj.buff[BUFF_SLOW] then
        res.obj = obj
        return true
    end
end
local function comboQMSTarget(res, obj, dist)
    if dist < SpellQ.range and obj.moveSpeed <= menu.q.comboMS:get() then
        res.obj = obj
        return true
    end
end
local function harassQMSTarget(res, obj, dist)
    if dist < SpellQ.range and obj.moveSpeed <= menu.q.harassMS:get() then
        res.obj = obj
        return true
    end
end

local function comboQTraceFilter(seg, obj)
    if seg.startPos:dist(seg.endPos) > SpellQ.range then return false end

    if pred.trace.circular.hardlock(SpellQ, seg, obj) then
        return true
    end
    if pred.trace.circular.hardlockmove(SpellQ, seg, obj) then
        return true
    end
    if pred.trace.newpath(obj, 0.033, 0.500) then
        return true
    end
end

local function comboQAlwaysTarget(res, obj, dist)
    if dist > 1000 then return false end
    local seg = pred.circular.get_prediction(SpellQ, obj)
    if not seg then return false end
    if not comboQTraceFilter(seg, obj) then return false end

    res.pos = seg.endPos
    res.obj = obj
    return true
end

local function comboHarassQ(comboOrHarass)
    -- Code duplication for debug purpose
    if player:spellSlot(0).state ~= 0 then return end
    if player.mana < player.manaCost0 then return end
    local mode = menu.q[comboOrHarass]:get()
    if mode == 1 then return end
    local qTarget = nil
    if mode == 2 then
        qTarget = TS.get_result(comboQBuffTarget).obj
        if not qTarget then return end
        local pos = pred.circular.get_prediction(SpellQ, qTarget)
        if pos and pos.startPos:dist(pos.endPos) < SpellQ.range then
            player:castSpell("pos", 0, pos.endPos:toGame3D())
            if menu.info.debug:get() then
                chat.print("Combo Q on " .. qTarget.charName .. " with Buff")
            end
        end
    end
    if mode == 3 then
        if comboOrHarass == "combo" then
            qTarget = TS.get_result(comboQMSTarget).obj
        else
            qTarget = TS.get_result(harassQMSTarget).obj
        end
        qTarget = TS.get_result(comboQMSTarget).obj
        if not qTarget then return end
        local pos = pred.circular.get_prediction(SpellQ, qTarget)
        if pos and pos.startPos:dist(pos.endPos) < SpellQ.range then
            player:castSpell("pos", 0, pos.endPos:toGame3D())
            if menu.info.debug:get() then
                chat.print("Combo Q on " .. qTarget.charName .. " with " .. qTarget.moveSpeed .. " MS")
            end
        end
    end
    if mode == 4 then
        local res = TS.get_result(comboQAlwaysTarget)
        if res.pos then
            player:castSpell('pos', 0, res.pos:toGame3D())
            if menu.info.debug:get() then
                chat.print("Combo Q on " .. res.obj.charName .. " Always")
            end
        end
    end
end

local function comboMode()
    comboHarassQ("combo")
end

local function harassMode()
    comboHarassQ("harass")
end


local function orbModes()
    if orb.menu.combat.key:get() then
        comboMode()
    elseif orb.menu.hybrid.key:get() then
        harassMode()
    end
end
cb.add(cb.tick, orbModes)


chat.print("Loaded Flofian Nami")
