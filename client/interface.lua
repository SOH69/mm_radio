if Shared.Core == 'qb' then
	QBCore = exports['qb-core']:GetCoreObject()
elseif Shared.Core == 'esx' then
	ESX = exports['es_extended']:getSharedObject()
end

Radio = {
	playerServerID = GetPlayerServerId(PlayerId()),
	PlayerJob = 'civilian',
	PlayerGang = 'none',
	PlayerDuty = false,
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
	userData = json.decode(GetResourceKvpString('radioSettings')) or {
		favourite = {},
		playerlist = {
			show = false,
			coords = {
				x = 15.0,
				y = 40.0
			}
		}
	}
}

if not Radio.userData.favourite then
	DeleteResourceKvp('radioSettings')
	Radio.userData = {
		favourite = {},
		playerlist = {
			show = false,
			coords = {
				x = 15.0,
				y = 40.0
			}
		}
	}
end