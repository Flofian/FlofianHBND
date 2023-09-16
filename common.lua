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
    getIncomingTargetedDamage = function (obj,evade)
        if not evade then 
            print('Evade not found')
            return end
        local ad_damage, ap_damage, true_damage, buff_list = evade.damage.count(obj)
        local incoming_damage = ad_damage + ap_damage + true_damage
        if incoming_damage > 0 then
            print('Incoming Damage: ' .. incoming_damage)
        end
        return incoming_damage
    end
    
}