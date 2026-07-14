-- ============================================================
--  Sounds.lua -- Pz-Helicopter-Events-Spawn
--  Registra sons OGG via OnLoadSoundBanks.
--
--  B42: addSound() registra o alias; PlayWorldSoundImpl() reproduz.
--  Se o OGG nao for encontrado no VFS do mod, o handle retornado
--  sera 0 e o Main.lua usa som vanilla como fallback automatico.
--
--  Fallback: solidcopy -> UIActivateButton (UI click)
-- ============================================================

Events.OnLoadSoundBanks.Add(function()
    local sb = getFMODSoundBank and getFMODSoundBank()
    if not sb then return end   -- servidor: sem audio

    local ok, e = pcall(function()
        sb:addSound(
            "hes_solidcopy",
            "media/sound/solid-copy-continue-over-military-radio-voice-vadi-sound.ogg",
            1.0, 0, 9999, 9999, 0, 1, false
        )
    end)

    print("[HES] Sounds: hes_solidcopy=" .. (ok and "OK" or ("ERRO:" .. tostring(e))))
end)
