if Shared.Core == 'qb' then
	QBCore = exports['qb-core']:GetCoreObject()
elseif Shared.Core == 'esx' then
	ESX = exports['es_extended']:getSharedObject()
end

Radio = {
	playerServerID = GetPlayerServerId(PlayerId()),
	PlayerJob = 'civilian',
	PlayerGang = 'none',
	hasRadio = false,
	onRadio = false,
	usingRadio = false,
	PlayerItems = {},
	RadioChannel = 0,
	radioProp = 0,
	Volume = 30,
	favourite = {},
	recomended = {},
	street = "Unknown",
	talkingList = {},
	userfav = json.decode(GetResourceKvpString('radioSettings')) or {}
}