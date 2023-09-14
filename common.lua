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
    end
}