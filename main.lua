chat.clear()
chat.add('Flofian Sona Loaded')
chat.print()

local menu = module.load(header.id, 'menu')
local common = module.load(header.id, 'common')
local circle_quality = 32

local function amplifyAutoattack(spell)
    if spell.isBasicAttack then
        if common.isAlly(spell.owner) and common.isEnemy(spell.target) then
            print('Found Basic Attack: ' .. spell.name)
            print('Target: ' .. spell.target.charName)
            print('Owner: ' .. spell.owner.charName)
            if spell.owner == player or spell.owner.vec3:dist(player.vec3)<menu.passive.passiveRange:get() then
                print('Amplifying Auto Attack')
                if 100*player.mana/player.maxMana > menu.automatic.autoQmana:get() then
                    player:castSpell('self', 0)
                end
                
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
        graphics.draw_circle(player.pos, menu.passive.passiveRange:get(), 3, graphics.argb(255,255,0,0), circle_quality)
    end
    if menu.draws.drawQ:get() and (not menu.draws.drawOnlyReady:get() or player:spellSlot(0).state == 0)then
        graphics.draw_circle(player.pos, menu.q.qRange:get(), 3, graphics.argb(255,0,0,255), circle_quality)
    end
end
cb.add(cb.draw, drawRanges)
print('Flofian Sona Loaded!')