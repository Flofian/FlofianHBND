local menu = menu('FlofianZyraMenu', 'Flofian Zyra')

menu:menu("info", "Important Information")
menu.info:header("info1", "Feedback/Suggestion:")
menu.info:header("info2", "Discord: flofian")
menu.info:header("info3", "Telegram: @Flofian1")
menu.info:header("info0", "Github Repo: Flofian/FlofianHBND")
menu.info:boolean("infob", "Show Debug prints", false)

menu:menu("passive", "Passive Settings")

menu:menu("q", "Q Settings")



menu:menu("w", "W Settings")


menu:menu("e", "E Settings")

menu:menu("r", "R Settings")

menu:menu("automatic", "Automatic")


menu:menu("draws", "Drawings")
menu.draws:boolean("drawOnlyAlive", "Draw Only when Alive", true)
menu.draws:boolean("drawOnlyReady", "Draw Only Ready Spells", true)
menu.draws:boolean("drawSeeds", "Draw Seeds", true)
menu.draws:boolean("drawPlants", "Draw Plant Range", true)
menu.draws:boolean("drawQ", "Draw Q Range", true)
menu.draws:boolean("drawW", "Draw W Range", true)
menu.draws:boolean("drawE", "Draw E Range", true)
menu.draws:boolean("drawR", "Draw R Range", true)

menu.draws:menu("colors", "Color Settings")
menu.draws.colors:color("colorSeeds", "Seed Color", 255, 0, 0, 255)
menu.draws.colors:color("colorMeleePlants", "Melee Plant Color", 255, 0, 0, 255)
menu.draws.colors:color("colorRangedPlants", "Ranged Plant Color", 0, 0, 255, 255)
menu.draws.colors:color("colorQ", "Q Color", 0, 0, 255, 255)
menu.draws.colors:color("colorW", "W Color", 0, 255, 0, 255)
menu.draws.colors:color("colorE", "E Color", 255, 0, 255, 255)
menu.draws.colors:color("colorR", "R Color", 255, 255, 0, 255)

return menu
