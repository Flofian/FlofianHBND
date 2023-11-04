local menu = menu('FlofianNamiMenu', 'Flofian Nami')
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

menu:menu("info", "Important Information")
--menu.info:header("info1", "Currently Only E on spells")
menu.info:boolean("debug", "Show Debug prints", false)

menu:menu("q", "Q Settings")
menu.q:dropdown("combo", "Use Q in Combo", 3, { "Off", "On Slow Buff", "Under x Movespeed", "Always" })
menu.q:slider("comboMS", "Max Movespeed to use Q in Combo", 300, 100, 400, 10)
menu.q.comboMS:set("visible", menu.q.combo:get() == 3)
menu.q.combo:set("callback", function(old, new) 
    if old == 3 then menu.q.comboMS:set("visible", false) end
    if new == 3 then menu.q.comboMS:set("visible", true) end
end)
menu.q:dropdown("harass", "Use Q in Harass", 2, { "Off", "On Slow Buff", "Under x Movespeed", "Always" })
menu.q:slider("harassMS", "Max Movespeed to use Q in Harass", 300, 100, 400, 10)
menu.q.harassMS:set("visible", menu.q.harass:get() == 3)
menu.q.harass:set("callback", function(old, new) 
    if old == 3 then menu.q.harassMS:set("visible", false) end
    if new == 3 then menu.q.harassMS:set("visible", true) end
end)

menu:menu("e", "E Settings")
menu.e:boolean("eOnSpells", "Use E on spells", true)
menu.e:boolean("eCombo", "Only use E in Combo", false)
menu.e:boolean("eSpellTargetOverwrite", "OVERWRITE Only E on targetted Spells", false)
menu.e.eSpellTargetOverwrite:set("tooltip", "By default, only targeted Spells are enabled in champ settings")
menu.e:boolean("eSpellAAOverwrite", "OVERWRITE Only E on Autoattacks", false)
local targetUnit = 1
for i = 0, objManager.allies_n - 1 do
    local ally = objManager.allies[i]
    menu.e:menu(ally.charName, ally.charName)
    menu.e[ally.charName]:boolean("use", "Use E on " .. ally.charName, true)
    menu.e[ally.charName]:boolean("AA", "Auto Attack", true)
    menu.e[ally.charName]:boolean("Q", "Q", ally:spellSlot(0).targetingType == targetUnit)
    menu.e[ally.charName]:boolean("W", "W", ally:spellSlot(1).targetingType == targetUnit)
    menu.e[ally.charName]:boolean("E", "E", ally:spellSlot(2).targetingType == targetUnit)
    menu.e[ally.charName]:boolean("R", "R", ally:spellSlot(3).targetingType == targetUnit)
end

menu:menu("automatic", "Automatic")
menu.automatic:boolean("recall", "Dont use anything while recalling", true)
menu.automatic:header("hAutoQ", "Auto Q")
menu.automatic:dropdown("autoQCC", "Use Q on CC Mode", 2, { "Off", "Predicton", "Buff" })
menu.automatic:dropdown("autoQGapclose", "Use Q on Gapclose", 3, { "Off", "Simple (NOT TESTED)", "Prediction" })



menu.automatic:header("hAutoW", "Auto W")
menu.automatic:boolean("autoWHeal", "Use W for Heal under x ", true)
menu.automatic:slider("autoWHealMana", "Min % mana to use W", 30, 0, 100, 5)
menu.automatic:menu("autoWunder", "Auto W under x % HP (0 to disable)")
for i = 0, objManager.allies_n - 1 do
    local ally = objManager.allies[i]
    menu.automatic.autoWunder:slider(ally.charName, ally.charName, 60, 0, 100, 5)
end
menu.automatic:dropdown("autoWTripleBounce", "Use W for Triple Bounce", 2, { "Off", "Simple", "Prediction" })
menu.automatic.autoWTripleBounce:set("tooltip", "Nami W bounces randomly so no guarantee")

menu.automatic:header("hAutoE", "E not here, look E Settings")

menu.automatic:header("hInterrupt", "Interrupt Settings")
menu.automatic:boolean("interruptQ", "Q to interrupt Danger 1 and 2", true)
menu.automatic:boolean("interruptR", "R to interrupt Danger 2", true)
menu.automatic:menu("interruptSpells", "Spell Danger Level")
for i = 0, objManager.enemies_n - 1 do
    local enemy = objManager.enemies[i]
    local n = string.lower(enemy.charName)
    if interruptableSpells[n] then
        for _, spell in pairs(interruptableSpells[n]) do
            menu.automatic.interruptSpells:slider(n .. spell.menuslot,
                enemy.charName .. " " .. spell.menuslot, spell.danger, 0, 2, 1)
        end
    end
end


return menu
