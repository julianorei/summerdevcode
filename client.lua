-- DESABILITAR X NA MOTO

Citizen.CreateThread(function()
    while true do
        local idle = 1000
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped)
            if GetPedInVehicleSeat(vehicle,0) == ped and GetVehicleClass(vehicle) == 8 then
                idle = 5
                DisableControlAction(0,73,true) 
            end
        end
        Citizen.Wait(idle)
    end
end)

-- MUDAR DE LUGAR NO CARRO COM O COMANDO /p1 /p2 /p3 /p4

lugares = {-1,0,1,2}

for k,v in pairs(lugares) do
    RegisterCommand("p"..k, function(source, args)
        local ped = PlayerPedId()
        SetPedConfigFlag(ped, 184, true)
        SetPedIntoVehicle(ped, GetVehiclePedIsIn(ped), v)
    end)
end

-- DESATIVAR O Q / ENCOSTAR NA PAREDE

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local health = GetEntityHealth(ped)
        if health >= 101 then
            DisableControlAction(0,44,true)
        end
    end
end)

-- FIX DE CRIAÇÃO DE PERSONAGEM UM EM CIMA DO OUTRO

function PlayerInstancia()
    for , player in ipairs(GetActivePlayers()) do
        local ped = PlayerPedId()
        local otherPlayer = GetPlayerPed(player)
        if ped ~= otherPlayer then
            SetEntityVisible(otherPlayer, false)
            SetEntityNoCollisionEntity(ped, otherPlayer, true)
        end
    end
end

function PlayerReturnInstancia()
    for , player in ipairs(GetActivePlayers()) do
        local ped = PlayerPedId()
        local otherPlayer = GetPlayerPed(player)
        if ped ~= otherPlayer then
            SetEntityVisible(otherPlayer, true)
            SetEntityCollision(ped, true)
        end
    end
end

-- DESATIVAR A CAMERA AFK

Citizen.CreateThread(function()
    while true do
        InvalidateIdleCam()
        InvalidateVehicleIdleCam()
        Wait(1000)
    end
end

-- NÃO ATIRAR AGACHADO

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local player = PlayerId()
        if agachar then 
            DisablePlayerFiring(player, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local ped = PlayerPedId()
        DisableControlAction(0,36,true)
        if not IsPedInAnyVehicle(ped) then
            RequestAnimSet("move_ped_crouched")
            RequestAnimSet("move_ped_crouched_strafing")
            if IsDisabledControlJustPressed(0,36) then
                if agachar then
                    ResetPedStrafeClipset(ped)
                    ResetPedMovementClipset(ped,0.25)
                    agachar = false
                else
                    SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
                    SetPedMovementClipset(ped,"move_ped_crouched",0.25)
                    agachar = true
                end
            end
        end
    end
end)

-- SCRIPT /TENTAR

RegisterCommand('tentar', function(source, args)
    local ptr = math.random(1,2)
    if ptr == 1 then
        msg = ' ~g~Conseguiu~s~'
    else
        msg = ' ~r~Não conseguiu~s~'
    end
    local text = ' ' .. msg
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. '  '
    TriggerServerEvent('3dme:shareDisplay', text)
end)

-- SNIPPET ANTI BUNNY HOP

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local ped = PlayerPedId()
        if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
            local chance_result = math.random()
            if chance_result < 0.50 then
                Citizen.Wait(600)     
                SetPedToRagdoll(ped, 5000, 1, 2)
            else
                Citizen.Wait(2000)
            end
        end
    end
end)

-- DESATIVAR OS SONS DEFAULT DO GTA (SIRENES, TIROS, ETC)

CreateThread(function() 
  StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE");
  SetAudioFlag("PoliceScannerDisabled",true); 
end)

-- NÃO POR O CAPACETE QUANDO ESTÁ NA MOTO

Citizen.CreateThread(function()
  while true do
  local pPed = GetPlayerPed(-1)
  Citizen.Wait(500)
  if IsPedInAnyVehicle(pPed, true) then
  SetPedHelmet(pPed, false)
  RemovePedHelmet(pPed, true)
  end
 end
end) 
