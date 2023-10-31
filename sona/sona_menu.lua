local menu = menu('FlofianSonaMenu', 'Flofian Sona')

menu:menu("info", "Important Information")
menu.info:header("info1", "Feedback/Suggestion:")
menu.info:header("info2", "Discord: flofian")
menu.info:header("info3", "Telegram: @Flofian1")
menu.info:header("info0", "Github Repo: Flofian/FlofianHBND")
menu.info:header("info4", "Max range = actual range(wiki)")
menu.info:header("info5", "Lower range as a buffer")
menu.info:header("info6", "HealShieldPower is not implemented")
menu.info:boolean("infob", "Show Debug prints", false)

menu:menu("passive", "Passive Settings")
menu.passive:slider("passiveRange", "Passive Range", 380, 350, 400, 5)

menu:menu("q", "Q Settings")
menu.q:slider("qRange", "Q Range", 750, 700, 800, 5)
menu.q:header("hqCombo", "Combo Settings")
menu.q:slider("comboQ", "Min Hits (0 to disable)", 1, 0, 2, 1)
menu.q:header("hqHarass", "Harass Settings")
menu.q:slider("harassQ", "Min Hits (0 to disable)", 1, 0, 2, 1)


menu:menu("w", "W Settings")
menu.w:slider("wRange", "W Range", 975, 900, 1000, 5)
menu.w:header("hwCombo", "Combo Settings")
menu.w:boolean("comboW", "Use W", true)
menu.w:dropdown("comboWmode", "W Mode", 2, { "Max Waste", "Under X % HP" })
menu.w:slider("comboWmaxwaste", "Maximum wasted heal % ", 10, 0, 100, 5)
menu.w:menu("comboWunder", "Under X % HP")
menu.w.comboWunder:slider("Sona", "Sona", 60, 0, 100, 5)
for i = 1, objManager.allies_n - 1 do
    local ally = objManager.allies[i]
    menu.w.comboWunder:slider(ally.charName, ally.charName, 75, 0, 100, 5)
end

menu:menu("e", "E Settings")
menu.e:header("heCombo", "Combo Settings")
menu.e:slider("comboE", "Affected Champs (0 to disable)", 2, 0, 5, 1)

menu:menu("r", "R Settings")
menu.r:slider("rRange", "R Range", 950, 800, 1000, 5)
menu.r:header("hrCombo", "Combo Settings")
menu.r:slider("comboR", "Min Hits (0 to disable)", 2, 0, 5, 1)
menu.r:dropdown("rPredSize", "R Prediction Size", 2, { "Small", "Medium", "Large" })
menu.r:keybind("semiR", "Semi R Key", "T", nil)
menu.r:slider("semiRmin", "Semi R min Hits", 2, 1, 5, 1)

menu:menu("automatic", "Automatic")
menu.automatic:boolean("autoRecallCheck", "Dont Use anything while recalling", true)
menu.automatic:header("autoHeaderq", "Q")
--menu.automatic:boolean("automaticQ", "Use Q on enemies", true)
menu.automatic:slider("autoQmintargets", "Auto Q min targets (0 to disable)", 2, 0, 2, 1)
menu.automatic:boolean("autoQamplify", "Use Q on ally auto attacks", true)
menu.automatic:slider("autoQamplifydirect", "^ Only when hitting x enemies direct", 0, 0, 2, 1)
menu.automatic:slider("autoQmana", "[Both] Min % mana to use Q", 30, 0, 100, 5)
menu.automatic:boolean("onlyQifaery", "[Both] Only use Q if aery is ready", true)
menu.automatic:boolean("autoQturret", "[Both] Dont use Q under enemy turret", true)

menu.automatic:header("autoHeaderW", "W")
menu.automatic:header("autoHeaderW2", "Incoming Dmg needs Evade module")
menu.automatic:header("autoHeaderW3", "HealShieldPower is not implemented")
menu.automatic:boolean("automaticW", "Use W Shield on Incoming Damage", true)
menu.automatic:slider("autoWmaxwaste", "Maximum Wasted shield %", 10, 0, 100, 5)
menu.automatic.autoWmaxwaste:set("tooltip", "Example: 10%-> If shield is 100 and dmg is less than 90, it will not shield")
menu.automatic:slider("autoWminheals", "Only w if also heals x champs", 1, 0, 2, 1)
menu.automatic:slider("autoWmana", "Min % mana to use W", 30, 0, 100, 5)

menu.automatic:header("autoHeaderE", "E")
menu.automatic:boolean("automaticE", "Use E for Anti-Melee", true)
menu.automatic:dropdown("autoEselfally", "Use E on", 2, { "Self", "Self+Ally" })
menu.automatic:slider("autoErange", "Max Range", 300, 0, 600, 10)
menu.automatic.autoErange:set("tooltip", "Press E when enemy closer than x range")

menu.automatic:header("autoHeaderR", "R")
menu.automatic:slider("autoRmin", "Min enemies to use R (0 to disable)", 4, 0, 5, 1)
menu.automatic:slider("autoRminAlly", "Min Allies in Range (0 to disable)", 1, 0, 4, 1)


menu:menu("draws", "Drawings")
menu.draws:boolean("drawOnlyAlive", "Draw Only when Alive", true)
menu.draws:boolean("drawOnlyReady", "Draw Only Ready Spells", true)
menu.draws:boolean("drawPassive", "Draw Aura Range", true)
menu.draws:boolean("drawQ", "Draw Q Range", true)
menu.draws:boolean("drawW", "Draw W Range", true)
menu.draws:boolean("drawE", "Draw E Range", true)
menu.draws:boolean("drawR", "Draw R Range", true)
menu.draws:boolean("drawRbox", "Draw R Box (DEBUG)", false)

menu.draws:menu("colors", "Color Settings")
menu.draws.colors:color("colorPassive", "Passive Color", 255, 0, 0, 255)
menu.draws.colors:color("colorQ", "Q Color", 0, 0, 255, 255)
menu.draws.colors:color("colorW", "W Color", 0, 255, 0, 255)
menu.draws.colors:color("colorE", "E Color", 255, 0, 255, 255)
menu.draws.colors:color("colorR", "R Color", 255, 255, 0, 255)




return menu
