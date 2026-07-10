-- ============================================================
--  Options.lua -- Pz-Helicopter-Events-Spawn
--  Registra opcoes nativas do mod (Opcoes > Mods) via PZAPI
-- ============================================================

local opts = PZAPI.ModOptions:create("Pz-Helicopter-Events-Spawn", getText("HET_OptTitle"))

opts:addDescription("HET_OptDesc")
opts:addSeparator()

opts:addTitle(getText("HET_SecControls"))
opts:addKeyBind("activationKey",   getText("HET_OptKeyBind"),         Keyboard.KEY_F7, getText("HET_TipKeyBind"))
opts:addKeyBind("endKey",          getText("HET_OptEndKey"),          0,               getText("HET_TipEndKey"))
opts:addSlider( "cooldownSecs",    getText("HET_OptCooldown"),        0, 3600, 1,  60, getText("HET_TipCooldown"))
opts:addSlider( "minEventSecs",    getText("HET_OptMinEvent"),        0,  600, 1,   0, getText("HET_TipMinEvent"))
opts:addSeparator()

opts:addTitle(getText("HET_SecBehavior"))
opts:addSlider( "triggerChance",   getText("HET_OptChance"),          0,  100, 1, 100, getText("HET_TipChance"))
opts:addSlider( "minDaysBeforeUse",getText("HET_OptMinDays"),         0,  365, 1,   0, getText("HET_TipMinDays"))
opts:addTickBox("showMessage",     getText("HET_OptShowMessage"),     true,            getText("HET_TipShowMessage"))
opts:addTickBox("showCooldownBar", getText("HET_OptShowCooldownBar"), true,            getText("HET_TipShowCooldownBar"))
opts:addTickBox("playSound",       getText("HET_OptPlaySound"),       true,            getText("HET_TipPlaySound"))
opts:addTickBox("allowInVehicle",  getText("HET_OptAllowVehicle"),    false,           getText("HET_TipAllowVehicle"))
opts:addTickBox("requireConfirm",  getText("HET_OptRequireConfirm"),  false,           getText("HET_TipRequireConfirm"))
opts:addTickBox("respectSandbox",  getText("HET_OptRespectSandbox"),  false,           getText("HET_TipRespectSandbox"))
opts:addSeparator()

opts:addTitle(getText("HET_SecDebug"))
opts:addTickBox("debugLogs",       getText("HET_OptDebugLogs"),       false,           getText("HET_TipDebugLogs"))