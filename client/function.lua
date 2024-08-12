local insideJammer = false

function IsJammerAllowed(id, channel)
    for i=1, #Radio.jammer do
        local entity = Radio.jammer[i]
        if entity.id == id then
            return lib.table.contains(entity.allowedChannels, channel)
        end
    end
end

function Radio:Notify(msg, duration)
    self:SendSvelteMessage("notify", {msg = msg, duration = duration or 5000})
end

function Radio:connectSound()
    PlaySoundFrontend(-1, 'Retune_High', 'MP_RADIO_SFX', true)
end

function Radio:closeEvent()
    PlaySoundFrontend(-1, 'Off_High', 'MP_RADIO_SFX', true)
end

function Radio:SplitStr(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        t[#t+1] = str
    end
    return t
end

function Radio:getCrossroads()
    local player = cache.ped
    local pos = GetEntityCoords(player)
    local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    if street2 == 0 then
        return GetStreetNameFromHashKey(street1)
    else
        return GetStreetNameFromHashKey(street2)
    end
end

function Radio:SetDefaultData(cid)
    self.userData[cid] = {
        favourite = {},
        name = nil,
        overlaySizeMultiplier = 50,
        radioSizeMultiplier = 50,
        allowMovement = false,
        playerlist = {
            show = false,
            coords = {
                x = 15.0,
                y = 40.0
            }
        },
        radio = {
            coords = {
                x = 10,
                y = 15,
            },
        }
    }
    SetResourceKvp('radioSettings2', json.encode(self.userData))
end

function Radio:Init(data)
    local player = data or Framework.core.getPlayerData()
    self.identifier = player.cid
    self.PlayerJob = player.job.name
    self.PlayerDuty = player.job.onDuty
    if Shared.Core == 'qb' then
        self.PlayerGang = player.gang.name
    end
    if not self.userData[self.identifier] then self:SetDefaultData(self.identifier) end
    self.userData[self.identifier].name = self.userData[self.identifier].name or player.firstName .. " " .. player.lastName
    local rec = {}
    for k, v in pairs(Shared.RestrictedChannels) do
        if v.type == 'job' and lib.table.contains(v.name, self.PlayerJob) then
            rec[#rec+1] = k
        elseif v.type == 'gang' and lib.table.contains(v.name, self.PlayerGang) then
            rec[#rec+1] = k
        end
    end
    self.favourite = rec
    for _, val in ipairs(self.userData[self.identifier].favourite) do
        if not lib.table.contains(self.favourite, val) then
            self.favourite[#self.favourite+1] = val
        end
    end

    if not self.userData[self.identifier].enableClicks then
        exports['pma-voice']:setVoiceProperty('micClicks', false)
    end

    self:doRadioCheck()
end

function Radio:connecttoradio(channel)
    if self.RadioChannel ~= 0 then
        TriggerServerEvent('mm_radio:server:removeFromRadioChannel', self.RadioChannel)
    end
    self.RadioChannel = channel
    if not Radio.onRadio then
        Radio.onRadio = true
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    end
    exports["pma-voice"]:setRadioChannel(channel)
    TriggerServerEvent('mm_radio:server:addToRadioChannel', self.RadioChannel, self.userData[self.identifier].name)
    self:connectSound()
    self:Notify(locale('join_notify_description', channel))
    if not lib.table.contains(Radio.recomended, channel) then
        Radio.recomended[#Radio.recomended+1] = channel
    end
    if self.insideJammer then
        Radio.signalJammed = false
        Radio:SendSvelteMessage("insideJammer", false)
    end
end

function Radio:doRadioCheck(items)
    if not Shared.Inventory then self.hasRadio = true return end
    self.batteryData = {}
    self.hasRadio = false
    local playerItems = items or Framework.inventory.playerItems()
    for _, v in pairs(playerItems) do
        if lib.table.contains(Shared.RadioItem, v.name) then
            self.hasRadio = true
            if v.metadata?.radioId or v.info?.radioId then
                self.batteryData[#self.batteryData+1] = v[Shared.Inventory == 'ox' and 'metadata' or 'info'].radioId
            end
        end
    end
    if not self.hasRadio and self.onRadio then
        Radio:leaveradio()
    end
end

function Radio:leaveradio()
    self:closeEvent()
    TriggerServerEvent('mm_radio:server:removeFromRadioChannel', self.RadioChannel)
    self.RadioChannel = 0
    self.onRadio = false
    exports["pma-voice"]:setRadioChannel(0)
    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
    self:update()
end

function Radio:update()
    local battery, radioId = lib.callback.await('mm_radio:server:getradiodata', false)
    self:SendSvelteMessage("updateRadio", {
        radioId = radioId,
        onRadio = Radio.onRadio,
        channel = Radio.RadioChannel,
        volume = Radio.Volume,
        favourite = Radio.favourite,
        recomended = Radio.recomended,
        userData = Radio.userData[self.identifier],
        time = self:CalculateTimeToDisplay(),
        street = self:getCrossroads(),
        locale = self.locale,
        channelName = Shared.RadioNames,
        insideJammerZone = self.signalJammed,
        battery = battery,
        overlay = Shared.Overlay
    })
end

function Radio:toggleRadioAnimation(pState)
    lib.requestAnimDict('cellphone@')
	if pState then
		TriggerEvent("attachItemRadio", "radio01")
		TaskPlayAnim(cache.ped, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, false, false, false)
		self.radioProp = CreateObject(`prop_cs_hand_radio`, 1.0, 1.0, 1.0, true, true, false)
		AttachEntityToEntity(self.radioProp, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.14, 0.01, -0.02, 110.0, 120.0, -15.0, true, false, false, false, 2, true)
	else
		StopAnimTask(cache.ped, "cellphone@", "cellphone_text_read_base", 1.0)
		ClearPedTasks(cache.ped)
		if self.radioProp ~= 0 then
			DeleteObject(self.radioProp)
			self.radioProp = 0
		end
	end
end

function Radio:CalculateTimeToDisplay()
	local hour = GetClockHours()
    local minute = GetClockMinutes()
    local second = GetClockSeconds()

    local obj = ""

	if minute <= 9 then
		minute = "0" .. minute
    end

    obj = hour..":"..minute

    return obj, (60 - second)
end

function Radio:RemoveJammerZone()
    for i=1, #self.jammer do
        self.jammer[i].zone:remove()
        self.jammer[i].zoneJammer:remove()
    end
end

function Radio:OpenJammerConfig(id)
    for i=1, #Radio.jammer do
        if Radio.jammer[i].id == id then
            local isDamaged = GetEntityHealth(Radio.jammer[i].entity) <= 0
            lib.registerContext({
                id = 'jammer_menu',
                title = 'Jammer Configuration',
                onExit = function ()
                    if insideJammer then lib.showTextUI('[E] Configure Jammer') end
                end,
                options = {
                    {
                        title = 'Toggle Jammer Switch',
                        description = 'Turn On/Off this jammer, Current State: '..(Radio.jammer[i].enable and 'Enabled' or 'Disabled'),
                        disabled = isDamaged,
                        icon = 'fa-toggle-on',
                        onSelect = function ()
                            TriggerServerEvent('mm_radio:server:togglejammer', Radio.jammer[i].id)
                            lib.showTextUI('[E] Configure Jammer')
                        end
                    },
                    {
                        title = 'Remove Jammer',
                        description = 'Remove this jammer',
                        icon = 'fa-trash',
                        disabled = not Radio.jammer[i].canRemove,
                        onSelect = function ()
                            TriggerServerEvent('mm_radio:server:removejammer', Radio.jammer[i].id, isDamaged)
                        end
                    },
                    {
                        title = 'Change Jammer Range',
                        description = 'Change the range of this jammer',
                        icon = 'fa-ruler',
                        disabled = isDamaged,
                        onSelect = function ()
                            local input = lib.inputDialog('Jammer Configuration', {
                                {
                                    type = 'slider',
                                    label = 'Change Jammer Range',
                                    description = 'Change the range of this jammer',
                                    icon = 'fa-ruler',
                                    min = Shared.Jammer.range.min,
                                    max = Shared.Jammer.range.max,
                                    step = Shared.Jammer.range.step,
                                    default = Radio.jammer[i].range,
                                },
                            })
                            if not input then return end
                            TriggerServerEvent('mm_radio:server:changeJammerRange', Radio.jammer[i].id, input[1])
                            lib.showTextUI('[E] Configure Jammer')
                        end
                    },
                    {
                        title = 'Allowed Channel',
                        description = 'Configure Allowed Channel for this jammer',
                        icon = 'fa-circle-check',
                        disabled = isDamaged,
                        onSelect = function ()
                            local allowedChannels = {
                                id = 'jammer_allowed_channel',
                                title = 'Allowed Channel',
                                menu = 'jammer_menu',
                                options = {}
                            }
                            for j=1, #Radio.jammer[i].allowedChannels do
                                allowedChannels.options[#allowedChannels.options+1] = {
                                    title = 'Channel '..Radio.jammer[i].allowedChannels[j],
                                    description = 'Remove this channel from allowed channel',
                                    icon = 'fa-trash',
                                    onSelect = function ()
                                        table.remove(Radio.jammer[i].allowedChannels, j)
                                        TriggerServerEvent('mm_radio:server:removeallowedchannel', Radio.jammer[i].id, Radio.jammer[i].allowedChannels)
                                        lib.showTextUI('[E] Configure Jammer')
                                    end
                                }
                            end
                            allowedChannels.options[#allowedChannels.options+1] = {
                                title = 'Add Channel',
                                description = 'Add more channel to allowed channel',
                                icon = 'fa-circle-plus',
                                onSelect = function ()
                                    local input = lib.inputDialog('Add Channel', {
                                        {type = 'number', label = 'Channel Frequency', description = 'Provide Channel Frequency', icon = 'fa-wifi', precision = 2},
                                    })
                                    if not input then return end
                                    table.insert(Radio.jammer[i].allowedChannels, input[1])
                                    TriggerServerEvent('mm_radio:server:addallowedchannel', Radio.jammer[i].id, Radio.jammer[i].allowedChannels)
                                    lib.showTextUI('[E] Configure Jammer')
                                end
                            }
                            lib.registerContext(allowedChannels)
                            lib.showContext('jammer_allowed_channel')
                        end
                    }
                }
            })
            lib.showContext('jammer_menu')
            break
        end
    end
end

function Radio:UpdateJammerZone(id, allowedChannels)
    if not self.insideJammer then return end
    local containChannel = lib.table.contains(allowedChannels, self.RadioChannel)
    self.insideJammerZone = id
    if not containChannel then
        self.signalJammed = true
        self:SendSvelteMessage("insideJammer", true)
        exports["pma-voice"]:setRadioChannel(0)
    else
        self.signalJammed = false
        self:SendSvelteMessage("insideJammer", false)
        exports["pma-voice"]:setRadioChannel(self.RadioChannel)
    end
end

function Radio:UpdateJammerRemove(id)
    if self.insideJammerZone == id then
        self.insideJammer = false
        if IsJammerAllowed(id, self.RadioChannel) then return end
        self.insideJammerZone = 0
        self.signalJammed = false
        self:SendSvelteMessage("insideJammer", false)
        exports["pma-voice"]:setRadioChannel(self.RadioChannel)
    end
end

function UpdateTime()
    CreateThread(function()
        while Radio.usingRadio do
            local currentTime, nextUpdate = Radio:CalculateTimeToDisplay()
            Radio:SendSvelteMessage("UpdateTime", currentTime)
            Wait(nextUpdate*1000)
        end
    end)
end

function DisableControls()
    CreateThread(function()
        while Radio.usingRadio and Radio.userData[Radio.identifier].allowMovement do
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 199, true)
            DisableControlAction(0, 200, true)
            DisablePlayerFiring(cache.playerId, true)
            Wait(5)
        end
    end)
end

function OnInsideJammerZone(data)
    CreateThread(function()
        while Radio.insideJammer do
            local isDamaged = GetEntityHealth(data.entity) <= 0
            if isDamaged then
                for i=1, #Radio.jammer do
                    local entity = Radio.jammer[i]
                    if entity.id == data.jammerid then
                        Radio:UpdateJammerRemove(data.jammerid)
                        entity.zone:remove()
                    end
                end
            end
            Wait(5000)
        end
    end)
end

function OnEnterJammerZone(self)
    if GetEntityHealth(self.entity) <= 0 then return end
    Radio.insideJammer = true
    Radio.insideJammerZone = self.jammerid
    OnInsideJammerZone(self)
    if IsJammerAllowed(self.jammerid, Radio.RadioChannel) then return end
    Radio.signalJammed = true
    Radio:SendSvelteMessage("insideJammer", true)
    exports["pma-voice"]:setRadioChannel(0)
end

function OnExitJammerZone(self)
    Radio.insideJammer = false
    Radio.insideJammerZone = 0
    if IsJammerAllowed(self.jammerid, Radio.RadioChannel) then return end
    Radio.signalJammed = false
    Radio:SendSvelteMessage("insideJammer", false)
    exports["pma-voice"]:setRadioChannel(Radio.RadioChannel)
end

function OnEnterJammer(self)
    if not Shared.Jammer.permission or not (lib.table.contains(Shared.Jammer.permission, Radio.PlayerJob) or lib.table.contains(Shared.Jammer.permission, Radio.PlayerGang)) then
        return
    end
    lib.showTextUI('[E] Configure Jammer')
    insideJammer = true
    CreateThread(function()
        while insideJammer do
            if IsControlJustPressed(0, 38) then
                Radio:OpenJammerConfig(self.jammerid)
                lib.hideTextUI()
            end
            Wait(5)
        end
    end)
end

function OnExitJammer()
    lib.hideTextUI()
    insideJammer = false
end

function JoinRadio(channel)
    if Radio.insideJammer and not IsJammerAllowed(Radio.insideJammerZone, channel) then
        return Radio:Notify(locale('jammer_notify_description', channel), 10000)
    end
    if not channel or channel > Shared.MaxFrequency or channel < 1 then
        return Radio:Notify(locale('invalid_notify_description', channel))
    end
    if channel == Radio.RadioChannel then
        return Radio:Notify(locale('already_notify_description', channel), 10000)
    end
    local connectChannel = math.floor(channel)
    if Shared.RestrictedChannels[connectChannel] then
        local type = Shared.RestrictedChannels[connectChannel].type
        local name = Shared.RestrictedChannels[connectChannel].name
        if type == 'job' and lib.table.contains(name, Radio.PlayerJob) and Radio.PlayerDuty then
            Radio:connecttoradio(channel)
            Radio:update()
        elseif type == 'gang' and lib.table.contains(name, Radio.PlayerGang) then
            Radio:connecttoradio(channel)
            Radio:update()
        else
            Radio:Notify(locale('restricted_notify_description', channel), 10000)
        end
    else
        Radio:connecttoradio(channel)
        Radio:update()
    end
end

exports('JoinRadio', JoinRadio)

local function LeaveRadio()
    Radio:leaveradio()
end

exports('LeaveRadio', LeaveRadio)

lib.addKeybind({
    name = 'radio',
    description = 'Press = to open Radio',
    defaultKey = 'EQUALS',
    onPressed = function()
        if not Radio.usingRadio then
            if Shared.Inventory and Radio.hasRadio then
                TriggerEvent('mm_radio:client:use')
            elseif not Shared.Inventory then
                TriggerEvent('mm_radio:client:use')
            end
        end
    end
})

lib.addKeybind({
    name = '+channel',
    description = 'Press to switch to next radio channel',
    defaultKey = 'PERIOD',
    onPressed = function()
        if not Radio.onRadio then return end
        local currentChannel = Radio.RadioChannel
        JoinRadio(currentChannel + 1)
    end
})

lib.addKeybind({
    name = '-channel',
    description = 'Press to switch to previous radio channel',
    defaultKey = 'COMMA',
    onPressed = function()
        if not Radio.onRadio then return end
        local currentChannel = Radio.RadioChannel
        JoinRadio(currentChannel - 1)
    end
})

if Shared.Battery.state then
    CreateThread(function()
        while true do
            TriggerServerEvent('mm_radio:server:consumeBattery', Radio.batteryData)
            Wait(Shared.Battery.depletionTime * 60000)
        end
    end)
end