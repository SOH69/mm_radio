Radio = {
	identifier = nil,
	playerServerID = GetPlayerServerId(PlayerId()),
	playerLoaded = false,
	PlayerJob = 'civilian',
	PlayerGang = 'none',
	PlayerDuty = false,
	PlayerDead = false,
	hasRadio = false,
	onRadio = false,
	usingRadio = false,
	RadioChannel = 0,
	radioProp = 0,
	Volume = 30,
	favourite = {},
	recomended = {},
	street = "Unknown",
	talkingList = {},
	locale = lib.getLocales(),
	jammer = {},
	batteryData = {},
	insideJammerZone = 0,
	insideJammer = false,
	signalJammed = false,
	allowedChannelInsideJammer = {},
	userData = json.decode(GetResourceKvpString('radioSettings2')) or {}
}

RegisterNetEvent('mm_radio:client:removedata', function()
	DeleteResourceKvp('radioSettings2')
	Radio.userData = {}
	SetResourceKvp('radioSettings2', json.encode(Radio.userData))
	if Framework.core.playerLoaded() then
		Radio:Init()
	end
end)

if not Shared.Ready then
	return error('Cannot Start Resource, MISSING DEPENDENCIES', 0)
end