local menu = module.load(header.id, 'nami/nami_menu')
local common = module.load(header.id, 'common')
local evade = module.seek("evade")
local orb = module.internal('orb')
local pred = module.internal("pred");
local TS = module.internal("TS")
local circle_quality = 64
local bool_to_number = { [true] = 1, [false] = 0 }
local spell_dir = { [0] = "Q", [1] = "W", [2] = "E", [3] = "R" }


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
    if player:spellSlot(2).state ~= 0 then return end
    if player.mana < player.manaCost2 then return end
    if spell.owner.type ~= TYPE_HERO or spell.owner.team ~= TEAM_ALLY then return end
    if spell.owner.pos:dist(player.pos) > 800 then return end
    --chat.print(spell.name)
    --chat.print(spell.owner.charName .. " " .. spell.slot)
    if not menu.e.eOnSpells:get() then return end
    if not menu.e[spell.owner.charName].use:get() then return end
    if menu.e.eSpellTargetOverwrite:get() and not spell.hasTarget then return end
    local spellSlot = spellSlotToLetter(spell)
    if spellSlot == -1 then return end
    if spell.hasTarget and not (spell.target.type == TYPE_HERO and spell.target.team == TEAM_ENEMY) then 
        --chat.print("Not using on targeted " .. spell.owner.charName .. " " .. spellSlot) 
    return end
    local allowed = menu.e[spell.owner.charName][spellSlot]:get()
    if allowed then
        --chat.print("Using on " .. spell.owner.charName .. " " .. spellSlot)
        local target = spell.owner
        player:castSpell("obj", 2, target)
    else
        --chat.print("Not using on " .. spell.owner.charName .. " " .. spellSlot)
    end
end

cb.add(cb.spell, autoEOnSpell)



chat.print("Loaded Flofian Nami")
