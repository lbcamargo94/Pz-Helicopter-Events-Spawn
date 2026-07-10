-- ============================================================
--  CooldownBar.lua -- Pz-Helicopter-Events-Spawn
--  Painel persistente com visual identico ao inventario B42
--  Depende de HES_State definido em Main.lua
-- ============================================================

HES_CooldownBar = ISPanel:derive("HES_CooldownBar")

-- Dimensoes
local BAR_W      = 220
local TITLE_H    = 19   -- mesmo valor de ISWindow.TitleBarHeight
local CONTENT_H  = 52   -- area abaixo do titulo
local BAR_H      = TITLE_H + CONTENT_H
local MARGIN     = 14

-- Cores do inventario B42 (de PZAPI/ui/organisms/Inventory.lua)
local INV_BG_R = 38 / 255   -- 0.149
local INV_BG_G = 38 / 255
local INV_BG_B = 38 / 255
local INV_BG_A = 0.9

-- Cor da borda (cinza medio, identico ao ISInventoryPage)
local BORDER_R = 0.40
local BORDER_G = 0.40
local BORDER_B = 0.40
local BORDER_A = 0.85

function HES_CooldownBar:new()
    local sw = getCore():getScreenWidth()
    local sh = getCore():getScreenHeight()
    local x  = sw - BAR_W - MARGIN
    local y  = sh - BAR_H - MARGIN

    local o = ISPanel.new(self, x, y, BAR_W, BAR_H)

    -- Herda o background do ISPanel (prerender() cuida do fundo + borda externa)
    o.backgroundColor = { r = INV_BG_R, g = INV_BG_G, b = INV_BG_B, a = INV_BG_A }
    o.borderColor     = { r = BORDER_R,  g = BORDER_G,  b = BORDER_B,  a = BORDER_A }

    setmetatable(o, self)
    self.__index = self
    return o
end

function HES_CooldownBar:render()
    -- Verifica visibilidade
    if not PZAPI or not PZAPI.ModOptions then return end
    local options = PZAPI.ModOptions:getOptions("Pz-Helicopter-Events-Spawn")
    if not options then return end
    local showOpt = options:getOption("showCooldownBar")
    if showOpt and not showOpt:getValue() then return end
    if not HES_State then return end

    -- Calcula progresso do cooldown
    local now        = getTimeInMillis()
    local cooldownMs = 0
    local cdOpt = options:getOption("cooldownSecs")
    if cdOpt then
        cooldownMs = (cdOpt:getValue() or 60) * 1000
    end
    local elapsed    = now - (HES_State.lastActivation or 0)
    local onCooldown = cooldownMs > 0 and elapsed < cooldownMs
    local progress   = onCooldown and (elapsed / cooldownMs) or 1.0

    local w = self.width

    -- -------------------------------------------------------
    --  Titulo (barra superior, identico ao ISInventoryPage)
    -- -------------------------------------------------------
    -- Borda ao redor da faixa de titulo (igual ao inventario)
    self:drawRectBorder(0, 0, w, TITLE_H, BORDER_A, BORDER_R, BORDER_G, BORDER_B)

    local titleFont = UIFont.Small
    local titleH    = getTextManager():getFontHeight(titleFont)
    local titleTxt  = getText("HES_BarLabel")
    local titleW    = getTextManager():MeasureStringX(titleFont, titleTxt)
    local titleX    = math.floor((w - titleW) / 2)
    local titleY    = math.floor((TITLE_H - titleH) / 2)
    self:drawText(titleTxt, titleX, titleY, 1, 1, 1, 1, titleFont)

    -- -------------------------------------------------------
    --  Area de conteudo
    -- -------------------------------------------------------
    local PAD    = 10
    local cy     = TITLE_H + 8   -- y do conteudo
    local barX   = PAD
    local barFW  = w - PAD * 2
    local barH   = 8

    -- Trilho da barra (fundo escuro)
    self:drawRect(barX, cy, barFW, barH, 0.70, 0.10, 0.10, 0.10)

    -- Preenchimento: amarelo durante cooldown, verde quando pronto
    local fillW = math.max(0, math.floor(barFW * progress))
    if onCooldown then
        self:drawRect(barX, cy, fillW, barH, 0.85, 0.76, 0.56, 0.10)
    else
        self:drawRect(barX, cy, fillW, barH, 0.85, 0.18, 0.70, 0.18)
    end

    -- Borda do trilho (igual ao estilo de progresso do inventario)
    self:drawRectBorder(barX, cy, barFW, barH, 0.50, BORDER_R, BORDER_G, BORDER_B)

    -- -------------------------------------------------------
    --  Textos de status e contador
    -- -------------------------------------------------------
    local textFont = UIFont.Small
    local textH    = getTextManager():getFontHeight(textFont)
    local textY    = cy + barH + 6

    -- Status (esquerda)
    local statusTxt
    if onCooldown then
        local remaining = math.ceil((cooldownMs - elapsed) / 1000)
        statusTxt = tostring(remaining) .. "s"
    else
        statusTxt = getText("HES_BarReady")
    end

    -- Cor do status: branco pronto, amarelo em cooldown
    local sr, sg, sb = 0.90, 0.90, 0.90
    if onCooldown then sr, sg, sb = 0.90, 0.80, 0.25 end
    self:drawText(statusTxt, PAD, textY, sr, sg, sb, 1, textFont)

    -- Contador de sessao (direita, cinza discreto)
    local count     = HES_State.sessionCount or 0
    local countTxt  = "#" .. tostring(count)
    local countW    = getTextManager():MeasureStringX(textFont, countTxt)
    self:drawText(countTxt, w - PAD - countW, textY, 0.55, 0.55, 0.55, 1, textFont)
end

-- ============================================================
--  Criacao e registro no UIManager (OnGameStart cobre novo
--  jogo e save carregado, igual ao ISChat e ISHotbar)
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