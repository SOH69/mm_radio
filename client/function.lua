function Radio:Notify(title, description, type)
    lib.notify({
        title = title,
        description = description,
        type = type
    })
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
    TriggerServerEvent('mm_radio:server:addToRadioChannel', self.RadioChannel)

    if self:SplitStr(tostring(channel), ".")[2] ~= nil and self:SplitStr(tostring(channel), ".")[2] ~= "" then
        self:Notify('Joined', 'Joined Station ' ..channel.. ' MHz', 'success')
    else
        self:Notify('Joined', 'Joined Station ' ..channel.. '.00 MHz', 'success')
    end
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
    if self.onRadio then
        self:leaveradio()
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
    SendNUIMessage({
        action = "updateRadio",
        data = {
            onRadio = Radio.onRadio,
            channel = Radio.RadioChannel,
            volume = Radio.Volume,
            favourite = Radio.favourite,
            recomended = Radio.recomended,
            time = self:CalculateTimeToDisplay(),
            street = self:getCrossroads()
        }
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