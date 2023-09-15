return {
    isAlly = function (obj)
        for i=0, objManager.allies_n-1 do
            local ally = objManager.allies[i]
            if ally == obj then
                return true
            end
        end
    end,
    isEnemy = function (obj)
        for i=0, objManager.enemies_n-1 do
            local ally = objManager.enemies[i]
            if ally == obj then
                return true
            end
        end
    end,
    
    isAeryReady = function ()
        if player.rune:get(0).name == "SummonAery" then
            return player.buff["assets/perks/styles/sorcery/summonaery/summonaery.lua"]
        end
    end,
     
}