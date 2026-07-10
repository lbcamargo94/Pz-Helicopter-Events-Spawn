-- ============================================================
--  Main.lua -- HelicopterTrigger v1.0.0
--  Tecla configuravel dispara testHelicopter() (evento vanilla)
--  Requer B42.19+, Single Player
-- ============================================================

require "HelicopterTrigger/Options"

-- ============================================================
--  Estado interno
-- ============================================================

local _lastActivation  = 0       -- getTimeInMillis() da ultima ativacao
local _pendingConfirm  = false   -- aguardando segunda pressao de confirmacao
local _pendingTime     = 0       -- quando a confirmacao foi solicitada

local CONFIRM_WINDOW   = 5000    -- janela para confirmar (ms)

-- ============================================================
--  Helpers
-- ============================================================

local function getOpt(id)
    local options = PZAPI.ModOptions:getOptions("HelicopterTrigger")
    if not options then return nil end
    local opt = options:getOption(id)
    if not opt then return nil end
    return opt:getValue()
end

local function dbg(msg)
    if getOpt("debugLogs") then
        print("[HelicopterTrigger] " .. tostring(msg))
    end
end

-- ============================================================
--  Painel de mensagem HUD
-- ============================================================

HET_MsgPanel = ISPanel:derive("HET_MsgPanel")

function HET_MsgPanel:new(lines, isWarning)
    local sw    = getCore():getScreenWidth()
    local sh    = getCore():getScreenHeight()
    local lh    = 24
    local pad   = 14
    local w     = 440
    local h     = #lines * lh + pad * 2
    local x     = math.floor((sw - w) / 2)
    local y     = math.floor(sh * 0.20)

    local o = ISPanel.new(self, x, y, w, h)
    o.lines      = lines
    o.isWarning  = isWarning or false
    o.startTime  = getTimeInMillis()
    o.duration   = 5500
    o.lh         = lh
    o.pad        = pad
    setmetatable(o, self)
    self.__index = self
    return o
end

function HET_MsgPanel:render()
    local elapsed = getTimeInMillis() - self.startTime
    if elapsed >= self.duration then
        self:removeFromUIManager()
        return
    end

    -- fade out durante os ultimos 1500ms
    local fadeStart = self.duration - 1500
    local alpha = elapsed > fadeStart
        and (1 - (elapsed - fadeStart) / 1500)
        or  1.0

    local w = self.width
    local h = self.height

    self:drawRect(0, 0, w, h, alpha * 0.80, 0.05, 0.05, 0.05)
    self:drawRectBorder(0, 0, w, h, alpha * 0.90, 0.55, 0.55, 0.55)

    for i, line in ipairs(self.lines) do
        local y   = self.pad + (i - 1) * self.lh
        local r, g, b

        if i == 1 and not self.isWarning then
            -- titulo principal: amarelo
            r, g, b = 1.0, 0.85, 0.15
        elseif i == 1 and self.isWarning then
            -- aviso: laranja
            r, g, b = 1.0, 0.55, 0.10
        else
            r, g, b = 0.90, 0.90, 0.90
        end

        local font   = (i == 1) and UIFont.Medium or UIFont.Small
        local textW  = getTextManager():MeasureStringX(font, line)
        local textX  = math.floor((w - textW) / 2)

        self:drawText(line, textX, y, r, g, b, alpha, font)
    end
end

local function showHUDMsg(lines, isWarning)
    local panel = HET_MsgPanel:new(lines, isWarning)
    panel:initialise()
    panel:addToUIManager()
end

-- ============================================================
--  Logica de ativacao
-- ============================================================

local function doTrigger()
    local player = getPlayer()
    if not player or player:isDead() then
        dbg("jogador morto ou nulo, cancelado")
        return
    end

    if not getGameTime() then
        dbg("jogo nao iniciado, cancelado")
        return
    end

    -- restricao de veiculo
    if not getOpt("allowInVehicle") and player:getVehicle() ~= nil then
        dbg("dentro de veiculo, bloqueado")
        if getOpt("showMessage") then
            showHUDMsg({ getText("HET_MsgVehicle") }, true)
        end
        return
    end

    -- cooldown
    local now        = getTimeInMillis()
    local cooldownMs = (getOpt("cooldownSecs") or 60) * 1000
    if cooldownMs > 0 and (now - _lastActivation) < cooldownMs then
        local remaining = math.ceil((cooldownMs - (now - _lastActivation)) / 1000)
        dbg("cooldown ativo: " .. remaining .. "s")
        if getOpt("showMessage") then
            showHUDMsg({ getText("HET_MsgCooldown", tostring(remaining)) }, true)
        end
        return
    end

    -- disparo do evento vanilla
    local ok, err = pcall(testHelicopter)
    if not ok then
        dbg("erro em testHelicopter: " .. tostring(err))
        return
    end

    _lastActivation = now
    dbg("evento ativado")

    if getOpt("showMessage") then
        showHUDMsg({
            getText("HET_MsgActivated"),
            getText("HET_MsgRegion"),
            getText("HET_MsgPrepare"),
        })
    end

    if getOpt("playSound") then
        pcall(function()
            getSoundManager():playUISound("UIActivateButton")
        end)
    end
end

-- ============================================================
--  Handler de tecla
-- ============================================================

Events.OnKeyPressed.Add(function(key)
    local player = getPlayer()
    if not player or player:isDead() then return end
    if not getGameTime() then return end

    local options = PZAPI.ModOptions:getOptions("HelicopterTrigger")
    if not options then return end

    local keyOpt = options:getOption("activationKey")
    if not keyOpt then return end
    if key ~= keyOpt:getValue() then return end

    local now = getTimeInMillis()

    if getOpt("requireConfirm") then
        if _pendingConfirm and (now - _pendingTime) < CONFIRM_WINDOW then
            -- segunda pressao: confirma e dispara
            _pendingConfirm = false
            dbg("confirmacao recebida")
            doTrigger()
        else
            -- primeira pressao: aguarda confirmacao
            _pendingConfirm = true
            _pendingTime    = now
            dbg("aguardando confirmacao")
            if getOpt("showMessage") then
                local keyName = getKeyName(keyOpt:getValue())
                showHUDMsg({
                    getText("HET_MsgConfirmTitle"),
                    getText("HET_MsgConfirmBody", keyName),
                }, true)
            end
        end
    else
        _pendingConfirm = false
        doTrigger()
    end
end)
