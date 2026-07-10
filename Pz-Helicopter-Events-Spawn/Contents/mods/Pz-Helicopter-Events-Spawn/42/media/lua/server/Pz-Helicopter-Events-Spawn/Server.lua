-- ============================================================
--  Server.lua -- Pz-Helicopter-Events-Spawn
--  Handler de comandos enviados por clientes MP
--  Executado apenas no contexto de servidor
-- ============================================================

local function onClientCommand(module, command, player, args)
    if module ~= "Pz-Helicopter-Events-Spawn" then return end

    if command == "triggerHelicopter" then
        print("[HET] servidor: triggerHelicopter solicitado por " .. tostring(player:getUsername()))
        pcall(testHelicopter)

    elseif command == "endHelicopter" then
        print("[HET] servidor: endHelicopter solicitado por " .. tostring(player:getUsername()))
        pcall(endHelicopter)
    end
end

Events.OnClientCommand.Add(onClientCommand)