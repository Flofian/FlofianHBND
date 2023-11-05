local delayedActions, delayedActionsExecuter = {}, nil
return {
    isAlly = function(obj)
        for i = 0, objManager.allies_n - 1 do
            local ally = objManager.allies[i]
            if ally == obj then
                return true
            end
        end
    end,
    isEnemy = function(obj)
        for i = 0, objManager.enemies_n - 1 do
            local ally = objManager.enemies[i]
            if ally == obj then
                return true
            end
        end
    end,

    isAeryReady = function()
        if player.rune:get(0).name == "SummonAery" then
            return player.buff["assets/perks/styles/sorcery/summonaery/summonaery.lua"]
        else
            return true
        end
    end,
    getIncomingDamage = function(obj, evade)
        if not evade then
            --print('Evade not found')
            return
        end
        local ad_damage, ap_damage, true_damage, buff_list = evade.damage.count(obj)
        local incoming_damage = ad_damage + ap_damage + true_damage
        if incoming_damage > 0 then
            --print('Incoming Damage: ' .. incoming_damage)
        end
        return incoming_damage
    end,
    countEnemiesInRange = function(pos, range)
        local enemies_in_range = 0
        for i = 0, objManager.enemies_n - 1 do
            local enemy = objManager.enemies[i]
            if pos:dist(enemy.pos) < range and enemy.isVisible and enemy.isTargetable and not enemy.isDead then
                enemies_in_range = enemies_in_range + 1
            end
        end
        return enemies_in_range
    end,
    countAlliesInRange = function(pos, range)
        local count = 0
        for i = 0, objManager.allies_n - 1 do
            local ally = objManager.allies[i]
            if pos:dist(ally.pos) < range and ally.isVisible and ally.isTargetable and not ally.isDead then
                count = count + 1
            end
        end
        return count
    end,
    isPlayerUnderTurret = function()
        for i = 0, objManager.turrets.size[TEAM_ENEMY] - 1 do
            local turret = objManager.turrets[TEAM_ENEMY][i]
            if turret.isAlive and turret.pos:dist(player) < 900 then
                return true
            end
        end
        return false
    end,
    isValidTarget = function(obj)
        return obj and obj.isVisible and not obj.isDead and obj.isTargetable
    end,
    delayedAction = function(func, delay, args)  --delay in seconds
        if not delayedActionsExecuter then
            function delayedActionsExecuter()
                for t, funcs in pairs(delayedActions) do
                    if t <= os.clock() then
                        for i = 1, #funcs do
                            local f = funcs[i]
                            if f and f.func then
                                f.func(unpack(f.args or {}))
                            end
                        end
                        delayedActions[t] = nil
                    end
                end
            end

            cb.add(cb.tick, delayedActionsExecuter)
        end
        local t = os.clock() + (delay or 0)
        if delayedActions[t] then
            delayedActions[t][#delayedActions[t] + 1] = { func = func, args = args }
        else
            delayedActions[t] = { { func = func, args = args } }
        end
    end
}
