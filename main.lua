chat.clear()
chat.add('Flofian Sona Loaded')
chat.print()

local menu = module.load(header.id, 'menu')
local common = module.load(header.id, 'common')
local circle_quality = 64

local function amplifyAutoattack(spell)
    if not menu.automatic.autoQamplify:get() then return end
    if not spell.isBasicAttack then return end
    if player:spellSlot(0).state ~= 0 then return end
    if 100*player.mana/player.maxMana < menu.automatic.autoQmana:get() then return end
    if common.isAlly(spell.owner) and common.isEnemy(spell.target) then
        print('Found Basic Attack: ' .. spell.name)
        print('Target: ' .. spell.target.charName)
        print('Owner: ' .. spell.owner.charName)
        if spell.owner == player or spell.owner.vec3:dist(player.vec3)<menu.passive.passiveRange:get() then
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
print('Flofian Sona Loaded!')