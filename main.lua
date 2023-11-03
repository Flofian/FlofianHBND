--chat.print("Loading...")

if player.charName == "Sona" then
    champ = module.load(header.id, 'sona/sona_main')
elseif player.charName == "Zyra" then
    champ = module.load(header.id, 'zyra/zyra_main')
elseif player.charName == "Nami" then
    champ = module.load(header.id, 'nami/nami_main')
--else 
    --champ = module.load(header.id, 'debug')
end