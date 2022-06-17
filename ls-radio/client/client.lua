ESX = nil
local PlayerData = {}
local radioMenu = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function PrintChatMessage(text)
    TriggerEvent('chatMessage', "LS-Radio", { 255, 0, 0 }, text)
end

function enableRadio(enable)
  SetNuiFocus(true, true)
  radioMenu = enable

  SendNUIMessage({
    type = "enableui",
    enable = enable
  })
end

RegisterCommand('radio', function(source, args)
    if Config.enableCmd then
      enableRadio(true)
    end
end, false)

RegisterNUICallback('joinRadio', function(data, cb)
  local _source = source
  local PlayerData = ESX.GetPlayerData(_source)
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports.saltychat:GetRadioChannel(true)

  if data.channel ~= getPlayerRadioChannel then
    if tonumber(data.channel) <= Config.RestrictedChannels then
      if(PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fbi' or PlayerData.job.name == 'milizia' or PlayerData.job.name == 'sceriffi') then
        exports.saltychat:SetRadioChannel(data.channel, true)
        
        ESX.ShowNotification( Config.messages['joined_to_radio'] .. data.channel .. ' MHz </b>')
      elseif not (PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'fbi' or PlayerData.job.name == 'milizia' or PlayerData.job.name == 'sceriffi') then
        ESX.ShowNotification(Config.messages['restricted_channel_error'])
      end
    end
    if tonumber(data.channel) > Config.RestrictedChannels then
      exports.saltychat:SetRadioChannel(data.channel, true)

      ESX.ShowNotification( Config.messages['joined_to_radio'] .. data.channel .. ' MHz </b>')
    end
  else
    ESX.ShowNotification(Config.messages['you_on_radio'] .. data.channel .. ' MHz </b>')
  end

  -- Debug output
  --[[
  PrintChatMessage("radio: " .. data.channel)
  print('radiook')
  ]]

  cb('ok')
end)

local prop
animazioneRadio2 = function(bool)
  if bool then
    RequestAnimDict("cellphone@");
    while not HasAnimDictLoaded("cellphone@") do Wait(5) end
    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_in", 3.0, -1, -1, 50, 0, false, false, false)
    prop = CreateObject(GetHashKey('prop_cs_hand_radio'),0.0 ,0.0, 0.0, true, true, true)
    SetEntityCollision(prop,false,false)
   AttachEntityToEntity(prop,PlayerPedId(),GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
    StopAnimTask(PlayerPedId(), "cellphone@","cellphone_text_in", -4.0)
  else
    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_out", 3.0, -1, -1, 50, 0, false, false, false)
    StopAnimTask(PlayerPedId(), "cellphone@","cellphone_text_out", -4.0)
    DeleteEntity(prop)
    Citizen.Wait(200)
    ClearPedTasks(PlayerPedId())
  end
end

animazioneRadio = function()
  Citizen.CreateThread(function()
    RequestAnimDict("random@arrests");
    while not HasAnimDictLoaded("random@arrests") do Wait(5) end
    TaskPlayAnim(PlayerPedId(),"random@arrests","generic_radio_chatter", 8.0, 0.0, -1, 49, 0, 0, 0, 0);
    local prop = CreateObject(GetHashKey('prop_cs_hand_radio'),0.0 ,0.0, 0.0, true, true, true)
    SetEntityCollision(prop,false,false)
    AttachEntityToEntity(prop,PlayerPedId(),GetPedBoneIndex(PlayerPedId(),60309),0.06,0.05,0.03,-90.0,30.0,0.0,false,false,false,false,2,true)
    Citizen.Wait(4000)
    StopAnimTask(PlayerPedId(), "random@arrests","generic_radio_chatter", -4.0)			
    DeleteEntity(prop)
  end)
end

local storeCanale = ""
RegisterCommand("mutaRadio", function()
  local canaleAttuale = exports.saltychat:GetRadioChannel(true)
  if storeCanale ~= "" and (canaleAttuale == "" or not canaleAttuale) then
    exports.saltychat:SetRadioChannel(storeCanale, true)
    ESX.ShowNotification("Hai smutato la radio")
  --  animazioneRadio2()
    RequestAnimDict("cellphone@");
    TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_in", 3.0, -1, -1, 50, 0, false, false, false)
    prop = CreateObject(GetHashKey('prop_cs_hand_radio'),0.0 ,0.0, 0.0, true, true, true)
    AttachEntityToEntity(prop,PlayerPedId(),GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
    Citizen.Wait(1500)
    StopAnimTask(PlayerPedId(), "cellphone@","cellphone_text_in", -4.0)
  else
    if canaleAttuale and canaleAttuale ~= "" then
      storeCanale = canaleAttuale
      exports.saltychat:SetRadioChannel("", true)
      ESX.ShowNotification("Hai mutato la radio")
      RequestAnimDict("cellphone@");
      TaskPlayAnim(PlayerPedId(), "cellphone@", "cellphone_text_in", 3.0, -1, -1, 50, 0, false, false, false)
      prop = CreateObject(GetHashKey('prop_cs_hand_radio'),0.0 ,0.0, 0.0, true, true, true)
      AttachEntityToEntity(prop,PlayerPedId(),GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 0, 2, 1)
      Citizen.Wait(1500)
      StopAnimTask(PlayerPedId(), "cellphone@","cellphone_text_in", -4.0)
      DeleteEntity(prop)
    else
      ESX.ShowNotification("Non hai la radio accesa","error")
    end
  end
end)
RegisterKeyMapping("mutaRadio","Muta/Smuta la radio~","KEYBOARD","k")

RegisterNUICallback('leaveRadio', function(data, cb)
  local playerName = GetPlayerName(PlayerId())
  local getPlayerRadioChannel = exports.saltychat:GetRadioChannel(true)

  if getPlayerRadioChannel == nil or getPlayerRadioChannel == '' then
    ESX.ShowNotification( Config.messages['not_on_radio'])
  else
    exports.saltychat:SetRadioChannel('', true)

    ESX.ShowNotification( Config.messages['you_leave'] .. getPlayerRadioChannel .. ' MHz </b>')
  end

  cb('ok')
end)

RegisterNUICallback('escape', function(data, cb)
  enableRadio(false)
  SetNuiFocus(false, false)
  animazioneRadio2(false)
  cb('ok')
end)

RegisterNetEvent('ls-radio:use')
AddEventHandler('ls-radio:use', function()
  enableRadio(true)
  animazioneRadio2(true)
end)

local canalecollegato = 0

RegisterCommand("frequenza", function()
    local canalecollegato = exports.saltychat:GetRadioChannel(true)
    ESX.ShowNotification("E' collegato alla radio: "..canalecollegato)
end)

RegisterNetEvent('ls-radio:onRadioDrop')
AddEventHandler('ls-radio:onRadioDrop', function(source)
  local playerName = GetPlayerName(source)
  local getPlayerRadioChannel = exports.saltychat:GetRadioChannel(true)

  if getPlayerRadioChannel ~= nil and getPlayerRadioChannel ~= '' then
    exports.saltychat:SetRadioChannel('', true)

    ESX.ShowNotification( Config.messages['you_leave'] .. getPlayerRadioChannel .. '.00 MHz </b>')
  end
end)

Citizen.CreateThread(function()
  while true do
    if radioMenu then
      DisableControlAction(0, 1, guiEnabled) -- LookLeftRight
      DisableControlAction(0, 2, guiEnabled) -- LookUpDown

      DisableControlAction(0, 142, guiEnabled) -- MeleeAttackAlternate

      DisableControlAction(0, 106, guiEnabled) -- VehicleMouseControlOverride

      if IsDisabledControlJustReleased(0, 142) then -- MeleeAttackAlternate
        SendNUIMessage({
            type = "click"
        })
      end
    end

    Citizen.Wait(0)
  end
end)
