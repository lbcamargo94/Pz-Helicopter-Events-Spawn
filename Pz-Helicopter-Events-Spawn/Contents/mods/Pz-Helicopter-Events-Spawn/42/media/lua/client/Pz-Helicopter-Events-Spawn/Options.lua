-- ============================================================
--  Options.lua -- Pz-Helicopter-Events-Spawn
--  Registra opcoes nativas do mod (Opcoes > Mods) via PZAPI
--  Nomes e tooltips sao traduzidos via getText() (UI_EN / UI_PTBR)
-- ============================================================

local opts = PZAPI.ModOptions:create("Pz-Helicopter-Events-Spawn", getText("HET_OptTitle"))

opts:addDescription("HET_OptDesc")
opts:addSeparator()

opts:addTitle(getText("HET_SecControls"))
opts:addKeyBind("activationKey",  getText("HET_OptKeyBind"),        Keyboard.KEY_F7, getText("HET_TipKeyBind"))
opts:addSlider( "cooldownSecs",   getText("HET_OptCooldown"),        0, 3600, 1, 60,  getText("HET_TipCooldown"))
opts:addSlider( "minEventSecs",   getText("HET_OptMinEvent"),         0,  600, 1,  0,  getText("HET_TipMinEvent"))
opts:addSeparator()

opts:addTitle(getText("HET_SecBehavior"))
opts:addTickBox("showMessage",    getText("HET_OptShowMessage"),     true,  getText("HET_TipShowMessage"))
opts:addTickBox("playSound",      getText("HET_OptPlaySound"),       true,  getText("HET_TipPlaySound"))
opts:addTickBox("allowInVehicle", getText("HET_OptAllowVehicle"),    false, getText("HET_TipAllowVehicle"))
opts:addTickBox("requireConfirm", getText("HET_OptRequireConfirm"),  false, getText("HET_TipRequireConfirm"))
opts:addSeparator()

opts:addTitle(getText("HET_SecDebug"))
opts:addTickBox("debugLogs",      getText("HET_OptDebugLogs"),       false, getText("HET_TipDebugLogs"))