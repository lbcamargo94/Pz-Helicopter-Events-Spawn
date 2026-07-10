-- ============================================================
--  Translations.lua -- Pz-Helicopter-Events-Spawn
--  Tabela de traducao propria para mods no B42.
--  getText() do B42 usa Java+JSON e nao carrega arquivos de mods
--  de forma confiavel, entao definimos as strings aqui em Lua.
-- ============================================================

local _EN = {
    HES_OptTitle              = "Pz-Helicopter-Events-Spawn",
    HES_OptDesc               = "Press the configured key to immediately trigger the vanilla PZ helicopter event. Configure cooldown, behavior, and multiplayer support below.",
    HES_SecControls           = "Controls",
    HES_SecBehavior           = "Behavior",
    HES_SecDebug              = "Debug",
    HES_OptKeyBind            = "Activation Key",
    HES_OptEndKey             = "Manual End Key",
    HES_OptCooldown           = "Cooldown (seconds)",
    HES_OptMinEvent           = "Minimum event duration (seconds)",
    HES_OptChance             = "Trigger Chance (%)",
    HES_OptMinDays            = "Min. in-game days before use",
    HES_OptShowMessage        = "Show on-screen notification",
    HES_OptShowCooldownBar    = "Show cooldown bar",
    HES_OptPlaySound          = "Play alert siren",
    HES_OptAllowVehicle       = "Allow activation inside vehicles",
    HES_OptRequireConfirm     = "Require double-press confirmation",
    HES_OptRespectSandbox     = "Respect sandbox helicopter setting",
    HES_OptDebugLogs          = "Enable debug logs",
    HES_TipKeyBind            = "Key that triggers the helicopter event. Default: F7.",
    HES_TipEndKey             = "Key to manually end the active helicopter event. Leave unbound (None) to disable.",
    HES_TipCooldown           = "Minimum time between activations in seconds. Set to 0 to disable the cooldown.",
    HES_TipMinEvent           = "The helicopter event automatically ends after this many seconds. Set to 0 to use the game default duration.",
    HES_TipChance             = "Probability (%) that pressing the key actually triggers the event. Set to 100 to always trigger.",
    HES_TipMinDays            = "The trigger key is blocked for the first N in-game days. Set to 0 to allow from day 1.",
    HES_TipShowMessage        = "Displays a HUD notification when the helicopter event is activated or ended.",
    HES_TipShowCooldownBar    = "Shows a cooldown progress bar in the corner of the screen.",
    HES_TipPlaySound          = "Plays a wailing siren (VehicleSirenWall) when the event is triggered.",
    HES_TipAllowVehicle       = "When disabled, the key will not work while the player is inside a vehicle.",
    HES_TipRequireConfirm     = "Requires pressing the activation key twice within 5 seconds to confirm.",
    HES_TipRespectSandbox     = "When enabled, the trigger is blocked if helicopter events are disabled in sandbox settings.",
    HES_TipDebugLogs          = "Prints debug messages to the console. Useful for troubleshooting.",
    HES_MsgActivated          = "HELICOPTER EVENT ACTIVATED",
    HES_MsgRegion             = "A helicopter was spotted in the area.",
    HES_MsgPrepare            = "Get ready for visitors.",
    HES_MsgEventEnded         = "Helicopter event ended.",
    HES_MsgConfirmTitle       = "CONFIRM ACTIVATION?",
    HES_MsgConfirmBody        = "Press %1 again to confirm.",
    HES_MsgCooldown           = "Cooldown: %1 seconds remaining.",
    HES_MsgVehicle            = "Cannot activate while inside a vehicle.",
    HES_MsgChanceFail         = "The helicopter didn't show up this time...",
    HES_MsgDayBlocked         = "Too early. Available from day %1.",
    HES_MsgSandboxBlocked     = "Helicopter events are disabled in world settings.",
    HES_MsgActivationCount    = "Session: %1 activation(s)",
    HES_BarLabel              = "Helicopter Trigger",
    HES_BarReady              = "READY",
    HES_SecFire               = "Helicopter Fire",
    HES_OptFireEnabled        = "Enable fire simulation",
    HES_OptFirePlayer         = "Fire can damage the player",
    HES_OptFireZombies        = "Fire can kill nearby zombies",
    HES_OptFireDamage         = "Player damage per burst (%)",
    HES_OptFireInterval       = "Seconds between bursts",
    HES_OptFireDuration       = "Fire duration (seconds)",
    HES_TipFireEnabled        = "Simulates the helicopter firing bursts during the event. Uses the fire duration setting.",
    HES_TipFirePlayer         = "Each burst deals damage to the player if outdoors. Set to 0% damage to disable harm.",
    HES_TipFireZombies        = "Each burst randomly kills nearby zombies within a 15-square radius.",
    HES_TipFireDamage         = "Health percentage lost per burst. 5 = removes 5% max health each burst.",
    HES_TipFireInterval       = "Seconds between fire bursts. Lower = more frequent.",
    HES_TipFireDuration       = "How long the helicopter fires after being triggered (seconds).",
    HES_MsgFireHit            = "INCOMING FIRE! Take cover!",
}

-- PTBR: apenas ASCII (sem acentos) para evitar KahluaException no Lua VM
local _PTBR = {
    HES_OptTitle              = "Pz-Helicopter-Events-Spawn",
    HES_OptDesc               = "Pressione a tecla configurada para disparar o evento de helicoptero vanilla do PZ. Configure cooldown, comportamento e suporte a multiplayer abaixo.",
    HES_SecControls           = "Controles",
    HES_SecBehavior           = "Comportamento",
    HES_SecDebug              = "Depuracao",
    HES_OptKeyBind            = "Tecla de Ativacao",
    HES_OptEndKey             = "Tecla de Encerramento Manual",
    HES_OptCooldown           = "Cooldown (segundos)",
    HES_OptMinEvent           = "Duracao minima do evento (segundos)",
    HES_OptChance             = "Chance de Ativacao (%)",
    HES_OptMinDays            = "Dias minimos de jogo antes de usar",
    HES_OptShowMessage        = "Exibir notificacao na tela",
    HES_OptShowCooldownBar    = "Exibir barra de cooldown",
    HES_OptPlaySound          = "Tocar sirene de alerta",
    HES_OptAllowVehicle       = "Permitir ativacao dentro de veiculos",
    HES_OptRequireConfirm     = "Exigir confirmacao (pressionar 2x)",
    HES_OptRespectSandbox     = "Respeitar config. sandbox do helicoptero",
    HES_OptDebugLogs          = "Ativar logs de depuracao",
    HES_TipKeyBind            = "Tecla que dispara o evento de helicoptero. Padrao: F7.",
    HES_TipEndKey             = "Tecla para encerrar o evento ativo. Deixe sem atribuicao (None) para desativar.",
    HES_TipCooldown           = "Tempo minimo entre ativacoes em segundos. 0 desativa o cooldown.",
    HES_TipMinEvent           = "O evento e encerrado automaticamente apos N segundos. 0 usa a duracao padrao do jogo.",
    HES_TipChance             = "Probabilidade (%) de o evento disparar ao pressionar a tecla. 100 = sempre.",
    HES_TipMinDays            = "A tecla fica bloqueada nos primeiros N dias de jogo. 0 libera desde o dia 1.",
    HES_TipShowMessage        = "Exibe notificacao na HUD ao ativar ou encerrar o evento.",
    HES_TipShowCooldownBar    = "Exibe barra de progresso de cooldown na tela.",
    HES_TipPlaySound          = "Reproduz sirene de emergencia (VehicleSirenWall) ao ativar o evento.",
    HES_TipAllowVehicle       = "Quando desativado, a tecla nao funciona dentro de veiculos.",
    HES_TipRequireConfirm     = "Exige pressionar a tecla 2x em ate 5 segundos para confirmar.",
    HES_TipRespectSandbox     = "Bloqueia o disparo se helicopteros estiverem desativados no sandbox.",
    HES_TipDebugLogs          = "Exibe mensagens de depuracao no console.",
    HES_MsgActivated          = "EVENTO DE HELICOPTERO ATIVADO",
    HES_MsgRegion             = "Um helicoptero foi avistado na regiao.",
    HES_MsgPrepare            = "Prepare-se para receber visitas.",
    HES_MsgEventEnded         = "Evento de helicoptero encerrado.",
    HES_MsgConfirmTitle       = "CONFIRMAR ATIVACAO?",
    HES_MsgConfirmBody        = "Pressione %1 novamente para confirmar.",
    HES_MsgCooldown           = "Cooldown: %1 segundos restantes.",
    HES_MsgVehicle            = "Nao e possivel ativar dentro de um veiculo.",
    HES_MsgChanceFail         = "O helicoptero nao apareceu dessa vez...",
    HES_MsgDayBlocked         = "Cedo demais. Disponivel a partir do dia %1.",
    HES_MsgSandboxBlocked     = "Eventos de helicoptero desativados nas config. do mundo.",
    HES_MsgActivationCount    = "Sessao: %1 ativacao(oes)",
    HES_BarLabel              = "Gatilho de Helicoptero",
    HES_BarReady              = "PRONTO",
    HES_SecFire               = "Fogo do Helicoptero",
    HES_OptFireEnabled        = "Ativar simulacao de fogo",
    HES_OptFirePlayer         = "Fogo pode danificar o jogador",
    HES_OptFireZombies        = "Fogo pode matar zumbis proximos",
    HES_OptFireDamage         = "Dano por rajada no jogador (%)",
    HES_OptFireInterval       = "Segundos entre rajadas",
    HES_OptFireDuration       = "Duracao do fogo (segundos)",
    HES_TipFireEnabled        = "Simula o helicoptero atirando rajadas durante o evento.",
    HES_TipFirePlayer         = "Cada rajada causa dano ao jogador se ele estiver ao ar livre.",
    HES_TipFireZombies        = "Cada rajada mata aleatoriamente zumbis em raio de 15 quadrados.",
    HES_TipFireDamage         = "Porcentagem de saude removida por rajada. 5 = 5% por rajada.",
    HES_TipFireInterval       = "Segundos entre rajadas. Menos segundos = mais intenso.",
    HES_TipFireDuration       = "Por quanto tempo o helicoptero atira apos ser ativado (segundos).",
    HES_MsgFireHit            = "FOGO INIMIGO! Busque abrigo!",
}

local _LANGS = { EN = _EN, PTBR = _PTBR }
local _resolved = nil

local function _resolve()
    if _resolved then return _resolved end
    -- B42: idioma via Translator.getLanguage():name() (getCore() nao tem getLanguage())
    -- Translator pode nao estar disponivel durante o carregamento compartilhado do mod.
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
    -- Translator indisponivel: retorna EN sem cachear para tentar novamente depois
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
