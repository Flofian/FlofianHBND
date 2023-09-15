chat.clear()
chat.add('Flofian Sona Loaded')
chat.print()

local menu = module.load(header.id, 'menu')
local common = module.load(header.id, 'common')
local circle_quality = 64


local function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ',\n'
       end
       return s .. '} '
    else
        
       return tostring(o)
    end
end

local function amplifyAutoattack(spell)
    if not menu.automatic.autoQamplify:get() then return end
    if not spell.isBasicAttack then return end
    if player:spellSlot(0).state ~= 0 then return end
    if 100*player.mana/player.maxMana < menu.automatic.autoQmana:get() then return end
    if menu.automatic.onlyQifaery:get() and not common.isAeryReady() then return end
    if common.isAlly(spell.owner) and common.isEnemy(spell.target) then
        print('Found Basic Attack: ' .. spell.name)
        print('Target: ' .. spell.target.charName)
        print('Owner: ' .. spell.owner.charName)
        if spell.owner == player or spell.owner.pos:dist(player.pos)<menu.passive.passiveRange:get() then
            local directenemies = 0
            for i=0, objManager.enemies_n-1 do
                local enemy = objManager.enemies[i]
                if enemy.isVisible and enemy.isTargetable and not enemy.isDead and player.pos:dist(enemy.pos)<menu.q.qRange:get() then
                    directenemies = directenemies + 1
                end
            end
            print('Direct Enemies: ' .. directenemies)
            if directenemies >= menu.automatic.autoQamplifydirect:get() then
                print('Amplifying Auto Attack')
                player:castSpell('self', 0)
            end
        end
    end
end
cb.add(cb.cast_finish, amplifyAutoattack)

local function drawRanges()
    if (menu.draws.drawOnlyAlive:get() and player.isDead) or not graphics.get_draw() then
        return
    end
    if menu.draws.drawPassive:get() then
        graphics.draw_circle(player.pos, menu.passive.passiveRange:get(), 3, menu.draws.colors.colorPassive:get(), circle_quality)
    end
    if menu.draws.drawQ:get() and (not menu.draws.drawOnlyReady:get() or player:spellSlot(0).state == 0)then
        graphics.draw_circle(player.pos, menu.q.qRange:get(), 3, menu.draws.colors.colorQ:get(), circle_quality)
    end
    if menu.draws.drawW:get() and (not menu.draws.drawOnlyReady:get() or player:spellSlot(1).state == 0)then
        graphics.draw_circle(player.pos, menu.w.wRange:get(), 3, menu.draws.colors.colorW:get(), circle_quality)
    end
    if menu.draws.drawE:get() and (not menu.draws.drawOnlyReady:get() or player:spellSlot(2).state == 0)then
        graphics.draw_circle(player.pos, menu.passive.passiveRange:get(), 3, menu.draws.colors.colorE:get(), circle_quality)
    end
    if menu.draws.drawR:get() and (not menu.draws.drawOnlyReady:get() or player:spellSlot(3).state == 0)then
        graphics.draw_circle(player.pos, menu.r.rRange:get(), 3, menu.draws.colors.colorR:get(), circle_quality)
    end
end
cb.add(cb.draw, drawRanges)

local function antiMelee()
    if player:spellSlot(2).state ~= 0 then return end
    if player.mana < player.manaCost2 then return end
    if menu.automatic.autoEselfally:get() == 1 then
        for i=0, objManager.enemies_n-1 do
            local enemy = objManager.enemies[i]
            if enemy.isVisible and enemy.isTargetable and not enemy.isDead and player.pos:dist(enemy.pos)<menu.automatic.autoErange:get() then
                player:castSpell('self', 2)
                return
            end
        end
    else
        allies_in_range = {}
        for i=0, objManager.allies_n-1 do
            local ally = objManager.allies[i]
            if ally.isTargetable and not ally.isDead and player.pos:dist(ally.pos)<menu.passive.passiveRange:get() then
                table.insert(allies_in_range, ally)
            end
        end
        
        for i=0, objManager.enemies_n-1 do
            local enemy = objManager.enemies[i]
            if enemy.isVisible and enemy.isTargetable and not enemy.isDead then
                for j=1, #allies_in_range do
                    if allies_in_range[j].pos:dist(enemy.pos)<menu.automatic.autoErange:get() then
                        player:castSpell('self', 2)
                        return
                    end
                end
            end
        end
    end
end
cb.add(cb.tick, antiMelee)

local function useQ()
    if player:spellSlot(0).state ~= 0 then return end
    if player.mana < player.manaCost0 then return end
    if 100*player.mana/player.maxMana < menu.automatic.autoQmana:get() then return end
    if not menu.automatic.automaticQ:get() then return end
    if menu.automatic.onlyQifaery:get() and not common.isAeryReady() then return end
    local targets = {}
    for i=0, objManager.enemies_n-1 do
        local enemy = objManager.enemies[i]
        if enemy.isVisible and enemy.isTargetable and not enemy.isDead and player.pos:dist(enemy.pos)<menu.q.qRange:get() then
            table.insert(targets, enemy)
        end
    end
    if #targets >= menu.automatic.autoQmintargets:get() then
        player:castSpell('self', 0)
    end
end
cb.add(cb.tick, useQ)

print('Flofian Sona Loaded!')