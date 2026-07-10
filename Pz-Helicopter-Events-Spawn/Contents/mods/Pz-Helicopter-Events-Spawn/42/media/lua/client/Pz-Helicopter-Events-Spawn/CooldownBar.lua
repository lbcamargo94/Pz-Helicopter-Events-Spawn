-- ============================================================
--  CooldownBar.lua -- Pz-Helicopter-Events-Spawn
--  Barra de cooldown persistente no canto inferior direito
--  Depende de HES_State definido em Main.lua
-- ============================================================

HES_CooldownBar = ISPanel:derive("HES_CooldownBar")

local BAR_W   = 220
local BAR_H   = 54
local MARGIN  = 14
local PAD     = 10

function HES_CooldownBar:new()
    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()
    local x  = sw - BAR_W - MARGIN
    local y  = sh - BAR_H - MARGIN

    local o = ISPanel.new(self, x, y, BAR_W, BAR_H)
    setmetatable(o, self)
    self.__index = self
    return o
end

function HES_CooldownBar:render()
    -- respeita opcao de visibilidade
    if not PZAPI or not PZAPI.ModOptions then return end
    local options = PZAPI.ModOptions:getOptions("Pz-Helicopter-Events-Spawn")
    if not options then return end
    local showOpt = options:getOption("showCooldownBar")
    if showOpt and not showOpt:getValue() then return end

    if not HES_State then return end

    local now       = getTimeInMillis()
    local cooldownMs = 0
    local cdOpt = options:getOption("cooldownSecs")
    if cdOpt then
        cooldownMs = (cdOpt:getValue() or 60) * 1000
    end

    local elapsed  = now - (HES_State.lastActivation or 0)
    local onCooldown = cooldownMs > 0 and elapsed < cooldownMs
    local progress   = 1.0
    if onCooldown then
        progress = elapsed / cooldownMs
    end

    local w = self.width
    local h = self.height

    -- fundo
    self:drawRect(0, 0, w, h, 0.75, 0.05, 0.05, 0.05)
    self:drawRectBorder(0, 0, w, h, 0.85, 0.35, 0.35, 0.35)

    -- label
    local label = getText("HES_BarLabel")
    local labelFont = UIFont.Small
    local labelW = getTextManager():MeasureStringX(labelFont, label)
    local labelX = math.floor((w - labelW) / 2)
    self:drawText(label, labelX, PAD, 0.80, 0.80, 0.80, 0.90, labelFont)

    local barY  = PAD + 16
    local barH  = 8
    local barX  = PAD
    local barFW = w - PAD * 2

    -- trilho da barra
    self:drawRect(barX, barY, barFW, barH, 0.60, 0.15, 0.15, 0.15)

    -- preenchimento: verde quando pronto, amarelo durante cooldown
    local fillW = math.floor(barFW * progress)
    if onCooldown then
        self:drawRect(barX, barY, fillW, barH, 0.80, 0.80, 0.60, 0.10)
    else
        self:drawRect(barX, barY, fillW, barH, 0.80, 0.20, 0.75, 0.20)
    end

    -- texto de status
    local statusFont = UIFont.Small
    local statusText
    if onCooldown then
        local remaining = math.ceil((cooldownMs - elapsed) / 1000)
        statusText = tostring(remaining) .. "s"
    else
        statusText = getText("HES_BarReady")
    end

    -- contador de sessao
    local count = HES_State.sessionCount or 0
    local countText = "#" .. tostring(count)

    local countW   = getTextManager():MeasureStringX(statusFont, countText)
    local textY    = barY + barH + 4

    self:drawText(statusText, PAD, textY, 0.90, 0.90, 0.90, 0.90, statusFont)
    self:drawText(countText, w - PAD - countW, textY, 0.60, 0.60, 0.60, 0.80, statusFont)
end

-- ============================================================
--  Criacao e registro da barra no UIManager
-- ============================================================

local _barPanel = nil

local function createBar()
    if _barPanel then return end
    _barPanel = HES_CooldownBar:new()
    _barPanel:initialise()
    _barPanel:addToUIManager()
    _barPanel:setAlwaysOnTop(true)
end

Events.OnGameStart.Add(createBar)