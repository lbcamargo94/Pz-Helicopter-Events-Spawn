-- ============================================================
--  Options.lua -- HelicopterTrigger
--  Registra opcoes nativas do mod (Opcoes > Mods) via PZAPI
--  Nomes exibidos sao traduzidos via getText() (UI_EN / UI_PTBR)
-- ============================================================

local opts = PZAPI.ModOptions:create("HelicopterTrigger", getText("HET_OptTitle"))

opts:addKeyBind("activationKey",  getText("HET_OptKeyBind"),        Keyboard.KEY_F7)
opts:addSlider( "cooldownSecs",   getText("HET_OptCooldown"),        0, 3600, 1, 60)
opts:addSeparator()
opts:addTickBox("showMessage",    getText("HET_OptShowMessage"),     true)
opts:addTickBox("playSound",      getText("HET_OptPlaySound"),       true)
opts:addTickBox("allowInVehicle", getText("HET_OptAllowVehicle"),    false)
opts:addTickBox("requireConfirm", getText("HET_OptRequireConfirm"),  false)
opts:addTickBox("debugLogs",      getText("HET_OptDebugLogs"),       false)
