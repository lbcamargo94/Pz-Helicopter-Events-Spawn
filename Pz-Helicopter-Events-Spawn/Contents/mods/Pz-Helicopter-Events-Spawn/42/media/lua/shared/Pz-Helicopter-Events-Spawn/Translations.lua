-- ============================================================
--  Translations.lua -- Pz-Helicopter-Events-Spawn
--  Tabela de traducao propria para mods no B42.
--  getText() do B42 usa Java+JSON e nao carrega arquivos de mods
--  de forma confiavel, entao definimos as strings aqui em Lua.
-- ============================================================

local _EN = {
    HES_OptTitle              = "Pz-Helicopter-Events-Spawn",
    HES_OptDesc               = "Press the configured key to immediately trigger the vanilla PZ helicopter event. Configure behavior and multiplayer support below.",
    HES_SecControls           = "Controls",
    HES_SecBehavior           = "Behavior",
    HES_SecDebug              = "Debug",
    HES_OptKeyBind            = "Activation Key",
    HES_OptChance             = "Trigger Chance (%)",
    HES_OptShowMessage        = "Show on-screen notification",
    HES_OptPlaySound          = "Play alert siren",
    HES_OptAllowVehicle       = "Allow activation inside vehicles",
    HES_OptRequireConfirm     = "Require double-press confirmation",
    HES_OptRespectSandbox     = "Respect sandbox helicopter setting",
    HES_OptDebugLogs          = "Enable debug logs",
    HES_TipKeyBind            = "Key that triggers the helicopter event. Default: F7.",
    HES_TipChance             = "Probability (%) that pressing the key actually triggers the event. Set to 100 to always trigger.",
    HES_TipShowMessage        = "Displays a HUD notification when the helicopter event is activated.",
    HES_TipPlaySound          = "Plays a wailing siren when the event is triggered.",
    HES_TipAllowVehicle       = "When disabled, the key will not work while the player is inside a vehicle.",
    HES_TipRequireConfirm     = "Requires pressing the activation key twice within 5 seconds to confirm.",
    HES_TipRespectSandbox     = "When enabled, the trigger is blocked if helicopter events are disabled in sandbox settings.",
    HES_TipDebugLogs          = "Prints debug messages to the console. Useful for troubleshooting.",
    HES_MsgActivated          = "HELICOPTER EVENT ACTIVATED",
    HES_MsgRegion             = "A helicopter was spotted in the area.",
    HES_MsgPrepare            = "Get ready for visitors.",
    HES_MsgEventActive        = "Helicopter event already active!",
    HES_MsgConfirmTitle       = "CONFIRM ACTIVATION?",
    HES_MsgConfirmBody        = "Press %1 again to confirm.",
    HES_MsgVehicle            = "Cannot activate while inside a vehicle.",
    HES_MsgChanceFail         = "The helicopter didn't show up this time...",
    HES_MsgSandboxBlocked     = "Helicopter events are disabled in world settings.",
    HES_MsgActivationCount    = "Session: %1 activation(s)",
}

-- PTBR: apenas ASCII (sem acentos) para evitar KahluaException no Lua VM
local _PTBR = {
    HES_OptTitle              = "Pz-Helicopter-Events-Spawn",
    HES_OptDesc               = "Pressione a tecla configurada para disparar o evento de helicoptero vanilla do PZ. Configure comportamento e suporte a multiplayer abaixo.",
    HES_SecControls           = "Controles",
    HES_SecBehavior           = "Comportamento",
    HES_SecDebug              = "Depuracao",
    HES_OptKeyBind            = "Tecla de Ativacao",
    HES_OptChance             = "Chance de Ativacao (%)",
    HES_OptShowMessage        = "Exibir notificacao na tela",
    HES_OptPlaySound          = "Tocar sirene de alerta",
    HES_OptAllowVehicle       = "Permitir ativacao dentro de veiculos",
    HES_OptRequireConfirm     = "Exigir confirmacao (pressionar 2x)",
    HES_OptRespectSandbox     = "Respeitar config. sandbox do helicoptero",
    HES_OptDebugLogs          = "Ativar logs de depuracao",
    HES_TipKeyBind            = "Tecla que dispara o evento de helicoptero. Padrao: F7.",
    HES_TipChance             = "Probabilidade (%) de o evento disparar ao pressionar a tecla. 100 = sempre.",
    HES_TipShowMessage        = "Exibe notificacao na HUD ao ativar o evento.",
    HES_TipPlaySound          = "Reproduz sirene de emergencia ao ativar o evento.",
    HES_TipAllowVehicle       = "Quando desativado, a tecla nao funciona dentro de veiculos.",
    HES_TipRequireConfirm     = "Exige pressionar a tecla 2x em ate 5 segundos para confirmar.",
    HES_TipRespectSandbox     = "Bloqueia o disparo se helicopteros estiverem desativados no sandbox.",
    HES_TipDebugLogs          = "Exibe mensagens de depuracao no console.",
    HES_MsgActivated          = "EVENTO DE HELICOPTERO ATIVADO",
    HES_MsgRegion             = "Um helicoptero foi avistado na regiao.",
    HES_MsgPrepare            = "Prepare-se para receber visitas.",
    HES_MsgEventActive        = "Evento de helicoptero ja ativo!",
    HES_MsgConfirmTitle       = "CONFIRMAR ATIVACAO?",
    HES_MsgConfirmBody        = "Pressione %1 novamente para confirmar.",
    HES_MsgVehicle            = "Nao e possivel ativar dentro de um veiculo.",
    HES_MsgChanceFail         = "O helicoptero nao apareceu dessa vez...",
    HES_MsgSandboxBlocked     = "Eventos de helicoptero desativados nas config. do mundo.",
    HES_MsgActivationCount    = "Sessao: %1 ativacao(oes)",
}

local _LANGS = { EN = _EN, PTBR = _PTBR }
local _resolved = nil

local function _resolve()
    if _resolved then return _resolved end
    if Translator ~= nil then
        local tl = Translator.getLanguage()
        if tl ~= nil then
            local n = tl:name()
            if n and _LANGS[n] then
                _resolved = _LANGS[n]
                return _resolved
            end
        end
        _resolved = _EN
        return _resolved
    end
    return _EN
end

-- Funcao global usada em todos os arquivos do mod
function HES_getText(key, arg1)
    local val = nil
    local ok, r = pcall(getText, key)
    if ok then val = r end
    if val == nil or val == key then
        local t = _resolve()
        val = (t and t[key]) or key
    end
    if arg1 ~= nil and type(val) == "string" and val:find("%%1") then
        val = val:gsub("%%1", tostring(arg1))
    end
    return val or key
end
