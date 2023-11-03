local menu = menu('FlofianNamiMenu', 'Flofian Nami')

menu:menu("info", "Important Information")
menu.info:header("info1", "Currently Only E on spells")
menu.info:boolean("debug", "Show Debug prints", false)

menu:menu("e", "E Settings")
menu.e:boolean("eOnSpells", "Use E on spells", true)
menu.e:boolean("eSpellTargetOverwrite", "OVERWRITE Only E on targetted Spells", false)
menu.e.eSpellTargetOverwrite:set("tooltip", "By default, only targeted Spells are enabled in champ settings")
local targetUnit = 1
--menu.e:menu("Nami", "Nami")
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

return menu