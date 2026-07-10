-- ============================================================
--  CooldownBar.lua -- Pz-Helicopter-Events-Spawn
--  Painel persistente com visual identico ao inventario B42.
--  Arrastavel, com botao de fechar. Reabre via opcao showCooldownBar.
-- ============================================================

require "Pz-Helicopter-Events-Spawn/Translations"

HES_CooldownBar = ISPanel:derive("HES_CooldownBar")

-- Dimensoes
local BAR_W      = 220
local TITLE_H    = 19
local CONTENT_H  = 52
local BAR_H      = TITLE_H + CONTENT_H
local MARGIN     = 14
local CLOSE_SZ   = TITLE_H - 4   -- tamanho do botao fechar

-- Cores do inventario B42
local BG_R = 38 / 255
local BG_G = 38 / 255
local BG_B = 38 / 255
local BG_A = 0.9

local BD_R = 0.40
local BD_G = 0.40
local BD_B = 0.40
local BD_A = 0.85

function HES_CooldownBar:new()
    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()
    local x  = sw - BAR_W - MARGIN
    local y  = sh - BAR_H - MARGIN

    local o = ISPanel.new(self, x, y, BAR_W, BAR_H)
    o.backgroundColor = { r = BG_R, g = BG_G, b = BG_B, a = BG_A }
    o.borderColor     = { r = BD_R, g = BD_G, b = BD_B, a = BD_A }
    o.moveWithMouse   = true
    o._closeHover     = false
    setmetatable(o, self)
    self.__index = self
    return o
end

-- -------------------------------------------------------
--  Detecta hover do mouse sobre o botao fechar
-- -------------------------------------------------------
function HES_CooldownBar:onMouseMove(dx, dy)
    local mx = self:getMouseX()
    local my = self:getMouseY()
    local cx = self.width - CLOSE_SZ - 2
    local cy = 2
    self._closeHover = (mx >= cx and mx <= cx + CLOSE_SZ and my >= cy and my <= cy + CLOSE_SZ)
    ISPanel.onMouseMove(self, dx, dy)
end

function HES_CooldownBar:onMouseMoveOutside(dx, dy)
    self._closeHover = false
    ISPanel.onMouseMoveOutside(self, dx, dy)
end

-- -------------------------------------------------------
--  Clique: fecha o painel ao clicar no botao X
-- -------------------------------------------------------
function HES_CooldownBar:onMouseDown(x, y)
    local cx = self.width - CLOSE_SZ - 2
    local cy = 2
    if x >= cx and x <= cx + CLOSE_SZ and y >= cy and y <= cy + CLOSE_SZ then
        self:setVisible(false)
        return true
    end
    return ISPanel.onMouseDown(self, x, y)
end

-- -------------------------------------------------------
--  Render
-- -------------------------------------------------------
function HES_CooldownBar:render()
    if not PZAPI or not PZAPI.ModOptions then return end
    local options = PZAPI.ModOptions:getOptions("Pz-Helicopter-Events-Spawn")
    if not options then return end
    if not HES_State then return end

    -- Progresso do cooldown
    local now        = getTimeInMillis()
    local cooldownMs = 0
    local cdOpt = options:getOption("cooldownSecs")
    if cdOpt then cooldownMs = (cdOpt:getValue() or 60) * 1000 end
    local elapsed    = now - (HES_State.lastActivation or 0)
    local onCooldown = cooldownMs > 0 and elapsed < cooldownMs
    local progress   = onCooldown and (elapsed / cooldownMs) or 1.0

    local w   = self.width
    local PAD = 10

    -- Barra de titulo (borda identica ao ISInventoryPage)
    self:drawRectBorder(0, 0, w, TITLE_H, BD_A, BD_R, BD_G, BD_B)

    -- Label centrado (sem a area do botao fechar)
    local titleFont = UIFont.Small
    local titleH    = getTextManager():getFontHeight(titleFont)
    local titleTxt  = HES_getText("HES_BarLabel")
    local titleW    = getTextManager():MeasureStringX(titleFont, titleTxt)
    local titleX    = math.floor(((w - CLOSE_SZ - 4) - titleW) / 2)
    local titleY    = math.floor((TITLE_H - titleH) / 2)
    self:drawText(titleTxt, titleX, titleY, 1, 1, 1, 1, titleFont)

    -- Botao fechar (X) no canto superior direito do titulo
    local cx  = w - CLOSE_SZ - 2
    local cy2 = 2
    local bgA = self._closeHover and 0.35 or 0.0
    self:drawRect(cx, cy2, CLOSE_SZ, CLOSE_SZ, bgA, 0.85, 0.15, 0.15)
    self:drawRectBorder(cx, cy2, CLOSE_SZ, CLOSE_SZ, 0.50, BD_R, BD_G, BD_B)
    local xFont = UIFont.Small
    local xTxt  = "x"
    local xW    = getTextManager():MeasureStringX(xFont, xTxt)
    local xH    = getTextManager():getFontHeight(xFont)
    local xR    = self._closeHover and 1.0 or 0.75
    self:drawText(xTxt, cx + math.floor((CLOSE_SZ - xW) / 2), cy2 + math.floor((CLOSE_SZ - xH) / 2), xR, 0.35, 0.35, 1, xFont)

    -- Barra de progresso
    local py   = TITLE_H + 8
    local barX = PAD
    local barW = w - PAD * 2
    local barH = 8

    self:drawRect(barX, py, barW, barH, 0.70, 0.10, 0.10, 0.10)

    local fillW = math.max(0, math.floor(barW * progress))
    if onCooldown then
        self:drawRect(barX, py, fillW, barH, 0.85, 0.76, 0.56, 0.10)
    else
        self:drawRect(barX, py, fillW, barH, 0.85, 0.18, 0.70, 0.18)
    end
    self:drawRectBorder(barX, py, barW, barH, 0.50, BD_R, BD_G, BD_B)

    -- Textos de status e contador
    local textFont = UIFont.Small
    local textY    = py + barH + 6

    local statusTxt
    if onCooldown then
        local remaining = math.ceil((cooldownMs - elapsed) / 1000)
        statusTxt = tostring(remaining) .. "s"
    else
        statusTxt = HES_getText("HES_BarReady")
    end

    local sr, sg, sb = 0.90, 0.90, 0.90
    if onCooldown then sr, sg, sb = 0.90, 0.80, 0.25 end
    self:drawText(statusTxt, PAD, textY, sr, sg, sb, 1, textFont)

    local count   = HES_State.sessionCount or 0
    local countTxt = "#" .. tostring(count)
    local countW   = getTextManager():MeasureStringX(textFont, countTxt)
    self:drawText(countTxt, w - PAD - countW, textY, 0.55, 0.55, 0.55, 1, textFont)
end

-- ============================================================
--  Criacao, sincronizacao de visibilidade e registro
-- ============================================================

local _barPanel  = nil
local _prevShow  = nil   -- ultimo valor lido da opcao showCooldownBar

local function createBar()
    if _barPanel then return end
    _barPanel = HES_CooldownBar:new()
    _barPanel:initialise()
    _barPanel:addToUIManager()
    _barPanel:setAlwaysOnTop(true)
    _prevShow = true
end

-- Sincroniza visibilidade com a opcao: desativar/ativar showCooldownBar
-- fecha ou reabre o painel sem reiniciar o jogo
Events.OnTick.Add(function()
    if not _barPanel then return end
    local options = PZAPI.ModOptions:getOptions("Pz-Helicopter-Events-Spawn")
    if not options then return end
    local showOpt = options:getOption("showCooldownBar")
    if not showOpt then return end
    local val = showOpt:getValue()
    if val ~= _prevShow then
        _prevShow = val
        _barPanel:setVisible(val == true)
    end
end)

Events.OnGameStart.Add(createBar)