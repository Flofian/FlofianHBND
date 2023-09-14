local menu = menu('sonaMenu', 'Flofian Sona')

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
menu.automatic:slider("autoQmintargets", "Min targets to use Q", 1, 1, 2, 1)
menu.automatic:boolean("autoQamplify", "Use Q on ally auto attacks", true)
menu.automatic:slider("autoQamplifydirect", "^ Only when also hitting x enemies direct", 0, 0, 2, 1)
menu.automatic:slider("autoQmana", "Min % mana to use Q", 30, 0, 100, 5)

menu:menu("draws", "Drawings")
menu.draws:boolean("drawOnlyAlive", "Draw Only when Alive", true)
menu.draws:boolean("drawOnlyReady", "Draw Only Ready Spells", true)
menu.draws:boolean("drawPassive", "Draw Aura Range", true)
menu.draws:boolean("drawQ", "Draw Q Range", true)
menu.draws:boolean("drawW", "Draw W Range", true)
menu.draws:boolean("drawE", "Draw E Range", true)
menu.draws:boolean("drawR", "Draw R Range", true)



return menu