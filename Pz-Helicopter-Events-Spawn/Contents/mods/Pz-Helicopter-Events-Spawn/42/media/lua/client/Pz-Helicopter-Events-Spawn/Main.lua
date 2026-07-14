-- ============================================================
--  Main.lua -- Pz-Helicopter-Events-Spawn
--  Tecla configuravel dispara testHelicopter() (evento vanilla)
--  Suporte: SP, MP cliente+servidor, B42.19+
-- ============================================================

require "Pz-Helicopter-Events-Spawn/Options"

-- ============================================================
--  Estado global
-- ============================================================

HES_State = HES_State or {}
HES_State.sessionCount   = HES_State.sessionCount or 0
HES_State.pendingConfirm = false
HES_State.pendingTime    = 0

local CONFIRM_WINDOW = 5000

-- ============================================================
--  Helpers
-- ============================================================

local function getOpt(id)
    local options = PZAPI.ModOptions:getOptions("Pz-Helicopter-Events-Spawn")
    if not options then return nil end
    local opt = options:getOption(id)
    if not opt then return nil end
    return opt:getValue()
end

local function dbg(msg)
    if getOpt("debugLogs") then
        print("[HES] " .. tostring(msg))
    end
end

-- ============================================================
--  Painel de mensagem HUD (flutuante, auto-desaparece)
-- ============================================================

HES_MsgPanel = ISPanel:derive("HES_MsgPanel")

function HES_MsgPanel:new(lines, isWarning)
    local sw  = getCore():getScreenWidth()
    local sh  = getCore():getScreenHeight()
    local lh  = 24
    local pad = 14
    local w   = 460
    local h   = #lines * lh + pad * 2
    local x   = math.floor((sw - w) / 2)
    local y   = math.floor(sh * 0.20)

    local o = ISPanel.new(self, x, y, w, h)
    o.lines     = lines
    o.isWarning = isWarning or false
    o.startTime = getTimeInMillis()
    o.duration  = 5500
    o.lh        = lh
    o.pad       = pad
    setmetatable(o, self)
    self.__index = self
    return o
end

function HES_MsgPanel:render()
    local elapsed = getTimeInMillis() - self.startTime
    if elapsed >= self.duration then
        self:removeFromUIManager()
        return
    end
    local fadeStart = self.duration - 1500
    local alpha = elapsed > fadeStart
        and (1 - (elapsed - fadeStart) / 1500)
        or  1.0
    local w = self.width
    local h = self.height
    self:drawRect(0, 0, w, h, alpha * 0.80, 0.05, 0.05, 0.05)
    self:drawRectBorder(0, 0, w, h, alpha * 0.90, 0.55, 0.55, 0.55)
    for i, line in ipairs(self.lines) do
        local ty = self.pad + (i - 1) * self.lh
        local r, g, b
        if i == 1 and not self.isWarning then
            r, g, b = 1.0, 0.85, 0.15
        elseif i == 1 and self.isWarning then
            r, g, b = 1.0, 0.55, 0.10
        else
            r, g, b = 0.90, 0.90, 0.90
        end
        local font  = (i == 1) and UIFont.Medium or UIFont.Small
        local textW = getTextManager():MeasureStringX(font, line)
        local textX = math.floor((w - textW) / 2)
        self:drawText(line, textX, ty, r, g, b, alpha, font)
    end
end

local function showHUDMsg(lines, isWarning)
    if not getOpt("showMessage") then return end
    local panel = HES_MsgPanel:new(lines, isWarning)
    panel:initialise()
    panel:addToUIManager()
end

-- ============================================================
--  Persistencia: historico em ModData do jogador
-- ============================================================

local function loadHistory(player)
    local md = player:getModData()
    return {
        total   = md.HES_Total   or 0,
        lastDay = md.HES_LastDay or 0,
    }
end

local function saveHistory(player, total, lastDay)
    local md = player:getModData()
    md.HES_Total   = total
    md.HES_LastDay = lastDay
end

-- ============================================================
--  Logica principal de disparo
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

    -- sandbox
    if getOpt("respectSandbox") then
        local sv = SandboxVars
        if sv and sv.Helicopter ~= nil and sv.Helicopter == 1 then
            dbg("bloqueado pelo sandbox")
            showHUDMsg({ HES_getText("HES_MsgSandboxBlocked") }, true)
            return
        end
    end

    -- restricao de veiculo
    if not getOpt("allowInVehicle") and player:getVehicle() ~= nil then
        dbg("dentro de veiculo, bloqueado")
        showHUDMsg({ HES_getText("HES_MsgVehicle") }, true)
        return
    end

    -- chance aleatoria
    local chance = getOpt("triggerChance") or 100
    if chance < 100 then
        if math.random(1, 100) > chance then
            dbg("chance falhou (" .. chance .. "%)")
            showHUDMsg({ HES_getText("HES_MsgChanceFail") }, true)
            return
        end
    end

    -- Som de confirmacao ANTES de chamar o helicoptero
    if getOpt("playSound") then
        local sm = getSoundManager and getSoundManager()
        if sm then
            local x, y, z = player:getX(), player:getY(), player:getZ()
            local handle = sm:PlayWorldSoundImpl("hes_solidcopy", false, x, y, z, 0, 9999, 1, false)
            if not handle or handle == 0 then
                sm:playUISound("UIActivateButton")
                dbg("solidcopy: OGG nao carregado, usando UIActivateButton como fallback")
            else
                dbg("solidcopy: handle=" .. tostring(handle))
            end
        end
    end

    -- MP: delega ao servidor
    if isClient() and not isServer() then
        sendClientCommand(player, "Pz-Helicopter-Events-Spawn", "triggerHelicopter", {})
        dbg("comando enviado ao servidor (MP)")
    else
        local ok, err = pcall(testHelicopter)
        if not ok then
            dbg("erro em testHelicopter: " .. tostring(err))
            return
        end
    end

    -- atualiza estado
    HES_State.sessionCount = HES_State.sessionCount + 1

    -- historico persistente
    local hist = loadHistory(player)
    local currentDay = 0
    if getGameTime() then
        currentDay = math.floor(getGameTime():getWorldAgeHours() / 24)
    end
    local newTotal = hist.total + 1
    saveHistory(player, newTotal, currentDay)
    dbg("total historico: " .. newTotal .. " | dia: " .. currentDay)

    -- notificacoes
    showHUDMsg({
        HES_getText("HES_MsgActivated"),
        HES_getText("HES_MsgRegion"),
        HES_getText("HES_MsgPrepare"),
        HES_getText("HES_MsgActivationCount", tostring(HES_State.sessionCount)),
    })

    dbg("evento ativado (sessao: " .. HES_State.sessionCount .. ")")
end

-- ============================================================
--  Handler de teclado
-- ============================================================

Events.OnKeyPressed.Add(function(key)
    local player = getPlayer()
    if not player or player:isDead() then return end
    if not getGameTime() then return end

    local options = PZAPI.ModOptions:getOptions("Pz-Helicopter-Events-Spawn")
    if not options then return end

    local activKeyOpt = options:getOption("activationKey")
    if not activKeyOpt then return end
    if key ~= activKeyOpt:getValue() then return end

    local now = getTimeInMillis()

    if getOpt("requireConfirm") then
        if HES_State.pendingConfirm and (now - HES_State.pendingTime) < CONFIRM_WINDOW then
            HES_State.pendingConfirm = false
            dbg("confirmacao recebida")
            doTrigger()
        else
            HES_State.pendingConfirm = true
            HES_State.pendingTime    = now
            dbg("aguardando confirmacao")
            if getOpt("showMessage") then
                local keyName = getKeyName(activKeyOpt:getValue())
                local panel = HES_MsgPanel:new({
                    HES_getText("HES_MsgConfirmTitle"),
                    HES_getText("HES_MsgConfirmBody", keyName),
                }, true)
                panel:initialise()
                panel:addToUIManager()
            end
        end
    else
        HES_State.pendingConfirm = false
        doTrigger()
    end
end)
