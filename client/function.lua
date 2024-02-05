function Radio:Notify(msg, duration)
    self:SendSvelteMessage("notify", {msg = msg, duration = duration or 5000})
end

function Radio:closeEvent()
	TriggerEvent("InteractSound_CL:PlayOnOne","click",0.6)
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

function Radio:connecttoradio(channel)
    self.RadioChannel = channel
    if Radio.onRadio then
        exports["pma-voice"]:setRadioChannel(0)
    else
        Radio.onRadio = true
        exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
    end
    exports["pma-voice"]:setRadioChannel(channel)
    TriggerServerEvent('mm_radio:server:addToRadioChannel', self.RadioChannel, self.userData.name)
    
    self:Notify(locale('join_notify_description', channel))
    if not lib.table.contains(Radio.recomended, channel) then
        Radio.recomended[#Radio.recomended+1] = channel
    end
end

function Radio:doRadioCheck()
    if Shared.Inventory == 'ox' then
        self.hasRadio = exports.ox_inventory:Search('count', 'radio') > 0
    elseif Shared.Inventory == 'qb' then
        local _hasRadio = false
        for _, item in pairs(Radio.PlayerItems) do
            if item.name == "radio" then
                _hasRadio = true
                break
            end
        end
        self.hasRadio = _hasRadio
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
    self:SendSvelteMessage("updateRadio", {
        onRadio = Radio.onRadio,
        channel = Radio.RadioChannel,
        volume = Radio.Volume,
        favourite = Radio.favourite,
        recomended = Radio.recomended,
        userData = Radio.userData,
        time = self:CalculateTimeToDisplay(),
        street = self:getCrossroads(),
        locale = self.locale,
        channelName = Shared.RadioNames
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

    local obj = ""

	if minute <= 9 then
		minute = "0" .. minute
    end

    obj = hour..":"..minute

    return obj
end

function JoinRadio(channel)
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

CreateThread(function()
    while true do
        Wait(1000)
        if Radio.playerLoaded then
            if not Radio.hasRadio and Radio.onRadio and Shared.Inventory then
                Radio:leaveradio()
            end
        end
    end
end)