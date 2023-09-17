return {
  id = 'Flofian',
  name = 'Flofian',
  author = "Flofian",
  description = "Simple Sona Plugin by Flofian",
  load = function()
    return player.charName == "Sona"
  end,
  flag = {
    text = "Flofian",
    color = {
      text = 0xFF11EEEE ,
      background1 = 0xFF11EEEE,
      background2 = 0xFF000000,    
    },
  },
  shard = {
    "main",
    "common",
    "sona/main",
    "sona/menu",
  }
}