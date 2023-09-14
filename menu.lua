local menu = menu('FlofianSonaMenu', 'Flofian Sona')

menu:menu("info", "Important Information")
menu.info:header("info1", "This Plugin is only in addition to other")
menu.info:header("info2", "It does not use R")
menu.info:header("info3", "Currently only helps for using Q passive")
menu.info:header("info4", "Max range = actual range(wiki)")
menu.info:header("info5", "Lower range as a buffer")

menu:menu("passive", "Passive Settings")
menu.passive:slider("passiveRange", "Passive Range", 380, 350, 400, 5)

menu:menu("q", "Q Settings")
menu.q:slider("qRange", "Q Range", 750, 700, 800, 5)

menu:menu("w", "W Settings")
menu.w:slider("wRange", "W Range", 950, 900, 1000, 5)

menu:menu("e", "E Settings")

menu:menu("r", "R Settings")
menu.r:slider("rRange", "R Range", 950, 800, 1000, 5)

menu:menu("automatic", "Automatic")
menu.automatic:boolean("automaticQ", "Use Q on enemies", true)
menu.automatic:slider("autoQmintargets", "Min targets to use Q", 2, 1, 2, 1)
menu.automatic:boolean("autoQamplify", "Use Q on ally auto attacks", true)
menu.automatic:slider("autoQamplifydirect", "^ Only when hitting x enemies direct", 0, 0, 2, 1)
menu.automatic:slider("autoQmana", "Min % mana to use Q", 30, 0, 100, 5)

menu:menu("draws", "Drawings")
menu.draws:boolean("drawOnlyAlive", "Draw Only when Alive", true)
menu.draws:boolean("drawOnlyReady", "Draw Only Ready Spells", true)
menu.draws:boolean("drawPassive", "Draw Aura Range", true)
menu.draws:boolean("drawQ", "Draw Q Range", true)
menu.draws:boolean("drawW", "Draw W Range", true)
menu.draws:boolean("drawE", "Draw E Range", true)
menu.draws:boolean("drawR", "Draw R Range", true)
menu.draws:menu("colors", "Color Settings")
menu.draws.colors:color("colorPassive", "Passive Color",255,0,0,255)
menu.draws.colors:color("colorQ", "Q Color",0,0,255,255)
menu.draws.colors:color("colorW", "W Color",0,255,0,255)
menu.draws.colors:color("colorE", "E Color",255,0,255,255)
menu.draws.colors:color("colorR", "R Color",255,255,0,255)




return menu