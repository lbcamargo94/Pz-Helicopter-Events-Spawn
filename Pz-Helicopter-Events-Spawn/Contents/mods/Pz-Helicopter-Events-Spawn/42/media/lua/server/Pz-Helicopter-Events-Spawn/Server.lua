-- ============================================================
--  Server.lua -- Pz-Helicopter-Events-Spawn
--  Handler de comandos enviados por clientes MP
--  Executado apenas no contexto de servidor
-- ============================================================

local function onClientCommand(module, command, player, args)
    if module ~= "Pz-Helicopter-Events-Spawn" then return end

    if command == "triggerHelicopter" then
        print("[HES] servidor: triggerHelicopter solicitado por " .. tostring(player:getUsername()))
        pcall(testHelicopter)
    end
end

Events.OnClientCommand.Add(onClientCommand)