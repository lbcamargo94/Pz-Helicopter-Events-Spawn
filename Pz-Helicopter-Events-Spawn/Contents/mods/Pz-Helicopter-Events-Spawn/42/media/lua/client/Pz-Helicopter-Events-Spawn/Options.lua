-- ============================================================
--  Options.lua -- Pz-Helicopter-Events-Spawn
--  Registra opcoes nativas do mod (Opcoes > Mods) via PZAPI
-- ============================================================

require "Pz-Helicopter-Events-Spawn/Translations"

local opts = PZAPI.ModOptions:create("Pz-Helicopter-Events-Spawn", HES_getText("HES_OptTitle"))

opts:addDescription("HES_OptDesc")
opts:addSeparator()

opts:addTitle(HES_getText("HES_SecControls"))
opts:addKeyBind("activationKey",   HES_getText("HES_OptKeyBind"),         Keyboard.KEY_F7, HES_getText("HES_TipKeyBind"))
opts:addKeyBind("endKey",          HES_getText("HES_OptEndKey"),          0,               HES_getText("HES_TipEndKey"))
opts:addSlider( "cooldownSecs",    HES_getText("HES_OptCooldown"),        0, 3600, 1,  60, HES_getText("HES_TipCooldown"))
opts:addSlider( "minEventSecs",    HES_getText("HES_OptMinEvent"),        0,  600, 1,   0, HES_getText("HES_TipMinEvent"))
opts:addSeparator()

opts:addTitle(HES_getText("HES_SecBehavior"))
opts:addSlider( "triggerChance",    HES_getText("HES_OptChance"),          0,  100, 1, 100, HES_getText("HES_TipChance"))
opts:addSlider( "minDaysBeforeUse", HES_getText("HES_OptMinDays"),         0,  365, 1,   0, HES_getText("HES_TipMinDays"))
opts:addTickBox("showMessage",      HES_getText("HES_OptShowMessage"),     true,            HES_getText("HES_TipShowMessage"))
opts:addTickBox("showCooldownBar",  HES_getText("HES_OptShowCooldownBar"), true,            HES_getText("HES_TipShowCooldownBar"))
opts:addTickBox("playSound",        HES_getText("HES_OptPlaySound"),       true,            HES_getText("HES_TipPlaySound"))
opts:addTickBox("allowInVehicle",   HES_getText("HES_OptAllowVehicle"),    false,           HES_getText("HES_TipAllowVehicle"))
opts:addTickBox("requireConfirm",   HES_getText("HES_OptRequireConfirm"),  false,           HES_getText("HES_TipRequireConfirm"))
opts:addTickBox("respectSandbox",   HES_getText("HES_OptRespectSandbox"),  false,           HES_getText("HES_TipRespectSandbox"))
opts:addSeparator()

opts:addTitle(HES_getText("HES_SecFire"))
opts:addTickBox("fireEnabled",      HES_getText("HES_OptFireEnabled"),     false,           HES_getText("HES_TipFireEnabled"))
opts:addTickBox("fireHitsPlayer",   HES_getText("HES_OptFirePlayer"),      true,            HES_getText("HES_TipFirePlayer"))
opts:addTickBox("fireHitsZombies",  HES_getText("HES_OptFireZombies"),     false,           HES_getText("HES_TipFireZombies"))
opts:addSlider( "fireDamage",       HES_getText("HES_OptFireDamage"),      1,  50, 1,   5,  HES_getText("HES_TipFireDamage"))
opts:addSlider( "fireBurstInterval",HES_getText("HES_OptFireInterval"),    2,  30, 1,   8,  HES_getText("HES_TipFireInterval"))
opts:addSlider( "fireDuration",     HES_getText("HES_OptFireDuration"),   10, 300, 5,  30,  HES_getText("HES_TipFireDuration"))
opts:addSeparator()

opts:addTitle(HES_getText("HES_SecDebug"))
opts:addTickBox("debugLogs",        HES_getText("HES_OptDebugLogs"),       false,           HES_getText("HES_TipDebugLogs"))