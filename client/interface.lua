if Shared.Core == 'qb' then
	QBCore = exports['qb-core']:GetCoreObject()
elseif Shared.Core == 'esx' then
	ESX = exports['es_extended']:getSharedObject()
end

Radio = {
	playerServerID = GetPlayerServerId(PlayerId()),
	playerLoaded = false,
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
	locale = lib.getLocales(),
	radioName = "Master Mind",
	userData = json.decode(GetResourceKvpString('radioSettings182')) or {
		favourite = {},
		name = {},
		playerlist = {
			show = false,
			coords = {
				x = 15.0,
				y = 40.0
			}
		}
	}
}

RegisterNetEvent('mm_radio:client:removedata', function()
	DeleteResourceKvp('radioSettings182')
	Radio.userData = {
		favourite = {},
		name = {},
		playerlist = {
			show = false,
			coords = {
				x = 15.0,
				y = 40.0
			}
		}
	}
	SetResourceKvp('radioSettings182', json.encode(Radio.userData))
	if Shared.Core == 'qb' and LocalPlayer.state.isLoggedIn then
		Radio:QBInit()
	elseif Shared.Core == 'qbx' and LocalPlayer.state.isLoggedIn then
		Radio:QboxInit()
	elseif Shared.Core == 'esx' and ESX.IsPlayerLoaded() then
		Radio:ESXInit()
	end
end)

if not Shared.Ready then
	return error('UI has not been built, refer to the readme or download a release build.\n	^3https://github.com/SOH69/mm_radio/releases/', 0)
end