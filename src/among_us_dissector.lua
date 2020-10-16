proto_among_us = Proto("amongus", "Among Us")

function proto_among_us.dissector(buffer, pinfo, tree)
    pinfo.cols.protocol = "amongus"
    local subtree = tree:add(proto_among_us, buffer(), "Among Us Packet")
    local buffwrap = create_buffer_wrapper(buffer)
    parse_packet_format(buffwrap, pinfo, subtree)
end


function create_buffer_wrapper(buffer)
    local object = {
        buffer = buffer,
        current_offset = 0
    }
    function object:read_bytes(consume)
        local bytes = self.buffer(self.current_offset, consume)
        self.current_offset = self.current_offset + consume
        return bytes
    end
    function object:rest_of_buffer()
        return self.buffer(self.current_offset)
    end
    function object:decode_packed()
        local packetlen = 0
        local initial_offset = self.current_offset

        local shift = 0
        local output = 0
        while (true)
        do
            local currbyte = self:read_bytes(1):uint()
            packetlen = packetlen + 1
            if currbyte >= 0x80 then
                currbyte = bit32.bxor(currbyte, 0x80)
                output = bit32.bor(output, bit32.lshift(currbyte, shift))
                shift = shift + 7
            else
                output = bit32.bor(output, bit32.lshift(currbyte, shift))
                break
            end
        end
        return output, self.buffer(initial_offset, packetlen)
    end
    return object
end



Packet_Format = {
    Unreliable = 0,
    Reliable = 1,
    Hello = 8,
    Disconnect = 9,
    Acknowledgement = 10,
    Ping = 12
}

Payload_Type = {
    CreateGame = 0,
    JoinGame = 1,
    StartGame = 2,
    RemoveGame = 3,
    RemovePlayer = 4,
    GameData = 5,
    GameDataTo = 6,
    JoinedGame = 7,
    Redirect = 13,
    RedirectMasterServer = 14,
    GetGameList2 = 16
}

Game_Data_Part_Type = {
    Data = 1,
    RPC = 2,
    Spawn = 4,
    Despawn = 5,
    SceneChange = 6,
    Ready = 7,
    ChangeSettings = 8
}

RPC_Code = {
    PlayAnimation = 0,
    CompleteTask = 1,
    SyncSettings = 2,
    SetInfected = 3,
    Exiled = 4,
    CheckName = 5,
    SetName = 6,
    CheckColor = 7,
    SetColor = 8,
    SetHat = 9,
    SetSkin = 10,
    ReportDeadBody = 11,
    MurderPlayer = 12,
    SendChat = 13,
    StartMeeting = 14,
    SetScanner = 15,
    SendChatNote = 16,
    SetPet = 17,
    SetStartCounter = 18,
    EnterVent = 19,
    ExitVent = 20,
    SnapTo = 21,
    Close = 22,
    VotingComplete = 23,
    CastVote = 24,
    ClearVote = 25,
    AddVote = 26,
    CloseDoorsOfType = 27,
    RepairSystem = 28,
    SetTasks = 29,
    UpdateGameData = 30
}

Spawned_Object_Ids = {
    ShipStatus = 0,
    MeetingHud = 1,
    LobbyBehaviour = 2,
    GameData = 3,
    Player = 4,
    HeadQuarters = 5,
    PlanetMap = 6,
    AprilShipStatus = 7,
    decode = function (self, id)
        for type, code in pairs(self) do
            if not ("decode" == type) and id == code then
                return type
            end
        end
        return "Unknown Object"
    end
}

ShipStatus_Components = {
    "AllSystemStatuses"
}
MeetingHud_Components = {
    "PlayerVoteFlags"
}
Lobby_Components = {
    "FollowerCamera"
}
GameData_Components = {
    "PlayerInfo",
    "VoteBanSystem"
}
Player_Components = {
    "PlayerControl",
    "PlayerPhysics",
    "CustomNetworkTransform"
}


-- Non 'Packet' Enums
Disconnect_Types = {
    None = 0,
    GameFull = 1,
    GameStarted = 2,
    GameNotFound = 3,
    CustomOld = 4,
    OutdatedClient = 5,
    BannedFromRoom = 6,
    KickedFromRoom = 7,
    Custom = 8,
    InvalidUsername = 9,
    Hacking = 10,
    Force = 16,
    BadConnection = 17,
    GameNotFound2 = 18,
    ServerClosed = 19,
    ServerOverloaded = 20,
    decode = function (self, number)
        for type, code in pairs(self) do
            if not ("decode" == type) and number == code then
                return type
            end
        end
        return "Unknown Reason Code: " .. string.format("%x", number) -- Convert to hex
    end
}

Crewmate_Colors = {
    "Red",
    "Blue",
    "DarkGreen",
    "Pink",
    "Orange",
    "Yellow",
    "Black",
    "White",
    "Purple",
    "Brown",
    "Cyan",
    "Lime"
}

Map_Ids = {
    "The Skeld",
    "Mira HQ",
    "Polus",
    decode = function (self, mapId)
        local mapstring = Map_Ids[mapId + 1] -- index + 1 because Lua table index at 1
        if not("decode" == mapstring) then
            return mapstring
        else
            return "Unknown Map Id: " .. mapId
        end
    end
}

Language_Ids = {
    Other = 1,
    Spanish = 2,
    Korean = 4,
    Russian = 8,
    Portuguese = 16,
    Arabic = 32,
    Filipino = 64,
    Polish = 128,
    English = 256,
    decode = function (self, language)
        for type, currlang in pairs(self) do
            if not ("decode" == type) and language == currlang then
                return type
             end
        end
        return "Unknown Language Code: " .. language
    end
}


 -- TODO
function decode_gamecode (gamecode) return gamecode end

function lerpValue(val, min, max)
    return min + (max - min) * val
end
function parseMoveVector(x, y)
    local lerpx = lerpValue(x / 65536, -40, 40)
    local lerpy = lerpValue(y / 65536, -40, 40)
    return lerpx, lerpy
end




function parse_packet_format(buffwrap, pinfo, tree)
    local packet_format = buffwrap:read_bytes(1)
    if packet_format:uint() == Packet_Format['Unreliable'] then
        tree:add(packet_format, "Packet Format: Unreliable")
        parse_packet_payload(buffwrap, pinfo, tree)

    else if packet_format:uint() == Packet_Format['Reliable'] then
        local packet_nonce = buffwrap:read_bytes(2)
        tree:add(packet_format, "Packet Format: Reliable")
        tree:add(packet_nonce, "Packet Nonce: " .. packet_nonce:uint())
        parse_packet_payload(buffwrap, pinfo, tree)

    else if packet_format:uint() == Packet_Format['Hello'] then
        tree:add(packet_format, "Packet Format: Hello")
        local packet_nonce = buffwrap:read_bytes(2)
        tree:add(packet_nonce, "Packet Nonce: " .. packet_nonce:uint())
        local hazel_version = buffwrap:read_bytes(1)
        tree:add(hazel_version, "Hazel Version: " .. hazel_version:uint())
        local client_version = buffwrap:read_bytes(4)
        tree:add(client_version, "Client Version: " .. client_version)

        local player_name_length = buffwrap:read_bytes(1)
        tree:add(player_name_length, "Player Name Length: " .. player_name_length:uint())
        local player_name_string = buffwrap:read_bytes(player_name_length:uint())
        tree:add(player_name_string, "Client Version: " .. player_name_string:string())

    else if packet_format:uint() == Packet_Format['Disconnect'] then
        tree:add(packet_format, "Packet Format: Disconnect")

    else if packet_format:uint() == Packet_Format['Acknowledgement'] then
        local packet_nonce = buffwrap:read_bytes(2)
        tree:add(packet_format, "Packet Format: Acknowledgement")
        tree:add(packet_nonce, "Packet Nonce: " .. packet_nonce:uint())

    else if packet_format:uint() == Packet_Format['Ping'] then
        local packet_nonce = buffwrap:read_bytes(2)
        tree:add(packet_format, "Packet Format: Ping")
        tree:add(packet_nonce, "Packet Nonce: " .. packet_nonce:uint())

    else
        tree:add(packet_format, "Packet Format: Unknown")
    end
    end
    end
    end
    end
    end
end

function parse_packet_payload(buffwrap, pinfo, tree)

    local packet_length = buffwrap:read_bytes(2)
    tree:add(packet_length, "Packet Length: " .. packet_length:le_uint())
    local payload_type = buffwrap:read_bytes(1)

    if payload_type:uint() == Payload_Type['CreateGame'] then
        tree:add(payload_type, "Payload Type: CreateGame")

    else if payload_type:uint() == Payload_Type['JoinGame'] then
        local subtree = tree:add(payload_type, "Payload Type: JoinGame")
        if buffwrap:rest_of_buffer():len() == 5 then
            local gamecode = buffwrap:read_bytes(4)
            local map_ownership = buffwrap:read_bytes(1)
            subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))
            subtree:add(map_ownership, "Map Ownership: " .. map_ownership)
        else
            local disconnectType = buffwrap:read_bytes(1)
            local disconnectString = Disconnect_Types:decode(disconnectType:uint())
            subtree:add(disconnectType, "Disconnected: " .. disconnectString)
        end

    else if payload_type:uint() == Payload_Type['StartGame'] then
        tree:add(payload_type, "Payload Type: StartGame")

    else if payload_type:uint() == Payload_Type['RemoveGame'] then
        tree:add(payload_type, "Payload Type: RemoveGame")

    else if payload_type:uint() == Payload_Type['RemovePlayer'] then
        tree:add(payload_type, "Payload Type: RemovePlayer")

    else if payload_type:uint() == Payload_Type['GameData'] then
        local subtree = tree:add(payload_type, "Payload Type: GameData")

        local gamecode = buffwrap:read_bytes(4)
        subtree:add(gamecode, "Gamecode: " .. decode_gamecode(gamecode:int()))

        parseGameDataParts(buffwrap, pinfo, subtree)

    else if payload_type:uint() == Payload_Type['GameDataTo'] then
        local subtree = tree:add(payload_type, "Payload Type: GameDataTo")

        local gamecode = buffwrap:read_bytes(4)
        local recipientid, packed_int_buffer = buffwrap:decode_packed()
        subtree:add(gamecode, "Gamecode: " .. decode_gamecode(gamecode:int()))
        subtree:add(packed_int_buffer, "Recipient Client ID (Packed Int): " .. recipientid)

        parseGameDataParts(buffwrap, pinfo, subtree)

    else if payload_type:uint() == Payload_Type['JoinedGame'] then
        local subtree = tree:add(payload_type, "Payload Type: JoinedGame")

        local gamecode = buffwrap:read_bytes(4)
        local clientid = buffwrap:read_bytes(4)
        local hostid = buffwrap:read_bytes(4)
        subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))
        subtree:add(clientid, "Client Id: " .. clientid:le_uint())
        subtree:add(hostid, "Host Id: " .. hostid:le_uint())

        local otherPlayerIdCount, packed_other_client_count = buffwrap:decode_packed()

        local other_player_subtree = subtree:add(packed_other_client_count,
            "Other Player Id Count (Packed Int): " .. otherPlayerIdCount)
        for i=1, otherPlayerIdCount, 1
        do
            local otherPlayerId, packed_other_player_id = buffwrap:decode_packed()
            other_player_subtree:add(packed_other_player_id, "Other Player " .. i .. ": " .. otherPlayerId)
        end

	else if payload_type:uint() == Payload_Type['RedirectMasterServer'] then
		tree:add(payload_type, "RedirectMasterServer")

    else if payload_type:uint() == Payload_Type['GetGameList2'] then
        tree:add(payload_type, "Get Game List V2 (Request or response)")

    else if payload_type:uint() == Payload_Type['Redirect'] then
        local subtree = tree:add(payload_type, "Payload Type: Redirect")

        local ipaddr = buffwrap:read_bytes(4)
        local port = buffwrap:read_bytes(2)
        subtree:add(ipaddr, "Redirect To IP: " .. ipaddr:ipv4())
        subtree:add(port, "Redirect To Port: " .. ipaddr:uint())
    else
        tree:add(payload_type, "Payload Type: Unknown Payload: " .. payload_type:uint())
    end
    end
    end
    end
    end
    end
    end
    end
	end
    end
    end
end

function parseGameDataParts (buffwrap, pinfo, tree)
    while (buffwrap:rest_of_buffer():len() > 0)
    do
        local part_length = buffwrap:read_bytes(2)
        tree:add(part_length, "Part Length: " .. part_length:le_uint())
        local startActualOffset = buffwrap.current_offset

        local part_type = buffwrap:read_bytes(1)
        if part_type:uint() == Game_Data_Part_Type['Data'] then
            local subtree = tree:add(part_type, "Part Type: Data")
            parseDataPart(buffwrap, pinfo, subtree)

        else if part_type:uint() == Game_Data_Part_Type['RPC'] then
            local subtree = tree:add(part_type, "Part Type: RPC")
            parseRPCPart(buffwrap, pinfo, subtree, part_length:le_uint())

        else if part_type:uint() == Game_Data_Part_Type['Spawn'] then
            local subtree = tree:add(part_type, "Part Type: Spawn")
            parseSpawnPart(buffwrap, pinfo, subtree)

        else if part_type:uint() == Game_Data_Part_Type['Despawn'] then
            tree:add(part_type, "Part Type: Despawn")

        else if part_type:uint() == Game_Data_Part_Type['SceneChange'] then
            tree:add(part_type, "Part Type: SceneChange")

            local clientid, packed_net_id_buffer = buffwrap:decode_packed()
            local sceneLength = buffwrap:read_bytes(1)
            local sceneName = buffwrap:read_bytes(sceneLength:le_uint())
            tree:add(packed_net_id_buffer, "Client Id (Packed Int): " .. clientid)
            tree:add(sceneLength, "Scene Name Length: " .. sceneLength:le_uint())
            tree:add(sceneName, "Scene Name: " .. sceneName)

        else if part_type:uint() == Game_Data_Part_Type['Ready'] then
            tree:add(part_type, "Part Type: Ready")

        else if part_type:uint() == Game_Data_Part_Type['ChangeSettings'] then
            tree:add(part_type, "Part Type: ChangeSettings")

        else
            tree:add(part_type, "Part Type: Unknown Part")
        end
        end
        end
        end
        end
        end
        end

        -- Consume Unused bytes
        local actualBytesRead = buffwrap.current_offset - startActualOffset
        local declaredLength = part_length:le_uint() + 1 -- to add in the part type
        if actualBytesRead < declaredLength then
            buffwrap:read_bytes(declaredLength - actualBytesRead)
        end
    end
end

function parseDataPart(buffwrap, pinfo, tree)
    local netid, packed_net_id_buffer = buffwrap:decode_packed()
    local sequenceId = buffwrap:read_bytes(2)


    tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
    tree:add(sequenceId, "Sequence Id: " .. sequenceId:uint())

    local x = buffwrap:read_bytes(2)
    local y = buffwrap:read_bytes(2)
    local dx = buffwrap:read_bytes(2)
    local dy = buffwrap:read_bytes(2)

    local poseX, poseY = parseMoveVector(x:le_uint(), y:le_uint())
    local velX, velY = parseMoveVector(dx:le_uint(), dy:le_uint())
    tree:add(x, "Pose Vector.x: " .. poseX)
    tree:add(y, "Pose Vector.y: " .. poseY)
    tree:add(dx, "Velocity Vector.x: " .. velX)
    tree:add(dy, "Velocity Vector.y: " .. velY)
end

function parseSpawnPart(buffwrap, pinfo, tree)
    local spawnId, packed_spawn_buffer = buffwrap:decode_packed()
    local ownerId, packed_owner_buffer = buffwrap:decode_packed()
    local flag = buffwrap:read_bytes(1)
    local component_count, packed_component_count_buffer = buffwrap:decode_packed()

    tree:add(packed_spawn_buffer, "Spawn Id (Packed Int): " .. spawnId
            .. " (" .. Spawned_Object_Ids:decode(spawnId).. ")" )
    tree:add(packed_owner_buffer, "Owner Id (Packed Int): " .. ownerId)
    tree:add(flag, "Flag: " .. flag:bitfield(0, 8))

    local subtree = tree:add(packed_component_count_buffer,
            "Components: Count: " .. component_count)
    for i=1,component_count,1
    do
        parseSpawnObjectComponents(buffwrap, pinfo, subtree, spawnId, i)
    end
end

function parseSpawnObjectComponents(buffwrap, pinfo, tree, objecttype, index)
    local startOffset = buffwrap.current_offset
    local netid, packed_net_id_buffer = buffwrap:decode_packed()
    local component_length = buffwrap:read_bytes(2)
    local componentCommand = buffwrap:read_bytes(1)
    local data = buffwrap:read_bytes(component_length:le_uint())

    local whole_packet_buffer = buffwrap.buffer(startOffset, buffwrap.current_offset - startOffset)
    local component_tree

    if objecttype == Spawned_Object_Ids["ShipStatus"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. ShipStatus_Components[index] .. ")")

    else if objecttype == Spawned_Object_Ids["MeetingHud"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. MeetingHud_Components[index] .. ")")

    else if objecttype == Spawned_Object_Ids["LobbyBehaviour"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. Lobby_Components[index] .. ")")

    else if objecttype == Spawned_Object_Ids["GameData"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. GameData_Components[index] .. ")")

    else if objecttype == Spawned_Object_Ids["Player"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. Player_Components[index] .. ")")

    else
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (Unknown)")
    end
    end
    end
    end
    end

    component_tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
    component_tree:add(component_length, "Component Length: " .. component_length:le_uint())
    component_tree:add(data, "Component Data: " .. data)


    -- Consume unused byteswiw
    local actualBytesRead = buffwrap.current_offset - startOffset
    local declaredLength = component_length:le_uint() + packed_net_id_buffer:len() + 3 -- to add in length before data
    if actualBytesRead < declaredLength then
        buffwrap:read_bytes(declaredLength - actualBytesRead)
    end
end

function parseRPCPart(buffwrap, pinfo, tree, rpclength)

    local netid, packed_net_id_buffer = buffwrap:decode_packed()
    tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
    local rpc_code = buffwrap:read_bytes(1)
    if rpc_code:uint() == RPC_Code['PlayAnimation'] then
        local animation_type = buffwrap:read_bytes(1)
        tree:add(rpc_code, "RPC Code: PlayAnimation")
        tree:add(animation_type, "Animation Type: " .. animation_type:uint())

    else if rpc_code:uint() == RPC_Code['CompleteTask'] then
        local task_id = buffwrap:read_bytes(1)
        tree:add(rpc_code, "RPC Code: CompleteTask")
        tree:add(task_id, "Task Id: " .. task_id:uint())

    else if rpc_code:uint() == RPC_Code['SyncSettings'] then
        local settingssubtree = tree:add(rpc_code, "RPC Code: SyncSettings")

        local settingsLength, packed_settings_length = buffwrap:decode_packed()
        settingssubtree:add(packed_settings_length, "Settings Length: " .. settingsLength)

        local version = buffwrap:read_bytes(1)
        settingssubtree:add(version, "Version: " .. version:uint())

        local maxPlayers = buffwrap:read_bytes(1)
        settingssubtree:add(maxPlayers, "Max Players: " .. maxPlayers:uint())
        local language = buffwrap:read_bytes(4)
        settingssubtree:add(language, "Language: " .. Language_Ids:decode(language:le_uint()))
        local mapId = buffwrap:read_bytes(1)
        settingssubtree:add(mapId, "Map Id: " .. Map_Ids:decode(mapId:uint()))

        local playerSpeed = buffwrap:read_bytes(4)
        settingssubtree:add(playerSpeed, "Player Speed: " .. playerSpeed:le_float())
        local crewmateVision = buffwrap:read_bytes(4)
        settingssubtree:add(crewmateVision, "Crewmate Vision: " .. crewmateVision:le_float())
        local impostorVision = buffwrap:read_bytes(4)
        settingssubtree:add(impostorVision, "Impostor Vision: " .. impostorVision:le_float())
        local killCooldown = buffwrap:read_bytes(4)
        settingssubtree:add(killCooldown, "Kill Cooldown: " .. killCooldown:le_float())

        local commonTasks = buffwrap:read_bytes(1)
        settingssubtree:add(commonTasks, "Common Tasks: " .. commonTasks:uint())
        local longTasks = buffwrap:read_bytes(1)
        settingssubtree:add(longTasks, "Long Tasks: " .. longTasks:uint())
        local shortTasks = buffwrap:read_bytes(1)
        settingssubtree:add(shortTasks, "Short Tasks: " .. shortTasks:uint())

        local emergencyMeetings = buffwrap:read_bytes(4)
        settingssubtree:add(emergencyMeetings, "Emergency Meeting: " .. emergencyMeetings:le_uint())
        local impostorCount = buffwrap:read_bytes(1)
        settingssubtree:add(impostorCount, "Impostor Count: " .. impostorCount:uint())
        local killDistance = buffwrap:read_bytes(1)
        settingssubtree:add(killDistance, "Kill Distance: " .. killDistance:uint())

        local discussionTime = buffwrap:read_bytes(4)
        settingssubtree:add(discussionTime, "Discussion Time: " .. discussionTime:le_uint())
        local votingTime = buffwrap:read_bytes(4)
        settingssubtree:add(votingTime, "Voting Time: " .. votingTime:le_uint())

        local defaults = buffwrap:read_bytes(1)
        settingssubtree:add(defaults, "Defaults: " .. defaults:uint())
        local emergencyCooldown = buffwrap:read_bytes(1)
        settingssubtree:add(emergencyCooldown, "Emergency Cooldown: " .. emergencyCooldown:uint())
        local confirmEjects = buffwrap:read_bytes(1)
        settingssubtree:add(confirmEjects, "Confirm Ejects: " .. confirmEjects:uint())
        local visualTasks = buffwrap:read_bytes(1)
        settingssubtree:add(visualTasks, "Visual Tasks: " .. visualTasks:uint())

    else if rpc_code:uint() == RPC_Code['SetInfected'] then
        tree:add(rpc_code, "RPC Code: SetInfected")

        infectedCount, packed_infected_buffer = buffwrap:decode_packed()
        tree:add(packed_infected_buffer, "Infected Count (Packed Int): " .. infectedCount)
        infected_player_ids = buffwrap:read_bytes(infectedCount)
        tree:add(infected_player_ids, "Infected Player Ids: "
                .. infected_player_ids:bytes():tohex(false, ", "))

    else if rpc_code:uint() == RPC_Code['Exiled'] then
        tree:add(rpc_code, "RPC Code: Exiled")
    else if rpc_code:uint() == RPC_Code['CheckName'] then
        tree:add(rpc_code, "RPC Code: CheckName")
        local name_length = buffwrap:read_bytes(1)
        local name_string = buffwrap:read_bytes(name_length:le_uint())
        tree:add(name_length, "Name Length: ", name_length:uint())
        tree:add(name_string, "Name: " .. name_string:string())

    else if rpc_code:uint() == RPC_Code['SetName'] then
        tree:add(rpc_code, "RPC Code: SetName")
        local name_length = buffwrap:read_bytes(1)
        local name_string = buffwrap:read_bytes(name_length:le_uint())
        tree:add(name_length, "Name Length: ", name_length:uint())
        tree:add(name_string, "Name: " .. name_string:string())

    else if rpc_code:uint() == RPC_Code['CheckColor'] then
        tree:add(rpc_code, "RPC Code: CheckColor")
        local color_byte = buffwrap:read_bytes(1)
        tree:add(color_byte, "Color: " .. Crewmate_Colors[color_byte:uint() + 1]) --color + 1 cause Lua table starts at 1

    else if rpc_code:uint() == RPC_Code['SetColor'] then
        tree:add(rpc_code, "RPC Code: SetColor")
        local color_byte = buffwrap:read_bytes(1)
        tree:add(color_byte, "Color: " .. Crewmate_Colors[color_byte:uint() + 1]) --color + 1 cause Lua table starts at 1

    else if rpc_code:uint() == RPC_Code['SetHat'] then
        tree:add(rpc_code, "RPC Code: SetHat")
        local hat_byte = buffwrap:read_bytes(1)
        tree:add(hat_byte, "Hat Id: " .. hat_byte:uint())

    else if rpc_code:uint() == RPC_Code['SetSkin'] then
        tree:add(rpc_code, "RPC Code: SetSkin")
        local skin_byte = buffwrap:read_bytes(1)
        tree:add(skin_byte, "Skin Id: " .. skin_byte:uint())

    else if rpc_code:uint() == RPC_Code['ReportDeadBody'] then
        tree:add(rpc_code, "RPC Code: ReportDeadBody")
        local target_player = buffwrap:read_bytes(1)
        if target_player:uint() == 255 then
            tree:add(target_player, "Player Id: " .. target_player:uint() .. "(Button)")
        end
        tree:add(target_player, "Player Id: " .. target_player:uint())

    else if rpc_code:uint() == RPC_Code['MurderPlayer'] then
        tree:add(rpc_code, "RPC Code: MurderPlayer")
        local murderNetId, packed_murder_net_id = buffwrap:decode_packed()
        tree:add(packed_murder_net_id, "Murdered NetId (Packed Int): " .. murderNetId)

    else if rpc_code:uint() == RPC_Code['SendChat'] then
        tree:add(rpc_code, "RPC Code: SendChat")
        local chat_string_length = buffwrap:read_bytes(1)
        local chat_string = buffwrap:read_bytes(chat_string_length:uint())
        tree:add(chat_string_length, "Chat Length: ", chat_string_length:uint())
        tree:add(chat_string, "Chat String: " .. chat_string:string())

    else if rpc_code:uint() == RPC_Code['StartMeeting'] then
        tree:add(rpc_code, "RPC Code: StartMeeting")
        local target_player = buffwrap:read_bytes(1)
        if target_player:uint() == 255 then
            tree:add(target_player, "Player Id: " .. target_player:uint() .. "(Button)")
        end
        tree:add(target_player, "Player Id: " .. target_player:uint())

    else if rpc_code:uint() == RPC_Code['SetScanner'] then
        tree:add(rpc_code, "RPC Code: SetScanner")
        local scanning_bool_byte = buffwrap:read_bytes(1)
        local scanning_stage = buffwrap:read_bytes(1)
        if scanning_bool_byte:uint() == 1 then
            tree:add(scanning_bool, "Scanning: true")
        else if scanning_bool_byte:uint() == 0 then
            tree:add(scanning_bool, "Scanning: false")
        end
        end
        tree:add(scanning_stage, "Scanning Stage: " .. scanning_stage:uint())

    else if rpc_code:uint() == RPC_Code['SendChatNote'] then
        tree:add(rpc_code, "RPC Code: SendChatNote")

    else if rpc_code:uint() == RPC_Code['SetPet'] then
        tree:add(rpc_code, "RPC Code: SetPet")

    else if rpc_code:uint() == RPC_Code['SetStartCounter'] then
        tree:add(rpc_code, "RPC Code: SetStartCounter")

        local startCounter = buffwrap:read_bytes(2)
        tree:add(startCounter, "Start Counter: " .. startCounter:le_uint())

    else if rpc_code:uint() == RPC_Code['EnterVent'] then
        tree:add(rpc_code, "RPC Code: EnterVent")

    else if rpc_code:uint() == RPC_Code['ExitVent'] then
        tree:add(rpc_code, "RPC Code: ExitVent")

    else if rpc_code:uint() == RPC_Code['SnapTo'] then
        tree:add(rpc_code, "RPC Code: SnapTo")

    else if rpc_code:uint() == RPC_Code['Close'] then
        tree:add(rpc_code, "RPC Code: Close")

    else if rpc_code:uint() == RPC_Code['VotingComplete'] then
        tree:add(rpc_code, "RPC Code: VotingComplete")

    else if rpc_code:uint() == RPC_Code['CastVote'] then
        tree:add(rpc_code, "RPC Code: CastVote")

    else if rpc_code:uint() == RPC_Code['ClearVote'] then
        tree:add(rpc_code, "RPC Code: ClearVote")

    else if rpc_code:uint() == RPC_Code['AddVote'] then
        tree:add(rpc_code, "RPC Code: AddVote")

    else if rpc_code:uint() == RPC_Code['CloseDoorsOfType'] then
        tree:add(rpc_code, "RPC Code: CloseDoorsOfType")

    else if rpc_code:uint() == RPC_Code['RepairSystem'] then
        tree:add(rpc_code, "RPC Code: RepairSystem")

    else if rpc_code:uint() == RPC_Code['SetTasks'] then
        tree:add(rpc_code, "RPC Code: SetTasks")

        local playerId = buffwrap:read_bytes(1)
        local taskLength = buffwrap:read_bytes(1)
        local taskIds = buffwrap:read_bytes(taskLength:le_uint())

        tree:add(playerId, "Player Id: " .. playerId:int())
        tree:add(taskLength, "Task Id Length: " .. taskLength:le_uint())
        tree:add(taskIds, "Task Id: " .. taskIds)

    else if rpc_code:uint() == RPC_Code['UpdateGameData'] then
        tree:add(rpc_code, "RPC Code: UpdateGameData")
        local currentOffset = buffwrap.current_offset
        local RPCPayloadlength = rpclength - packed_net_id_buffer:len() - 1 -- For netid and rpc code
        while (buffwrap.current_offset - currentOffset < RPCPayloadlength)
        do
            local playerDataLength = buffwrap:read_bytes(2)
            local currentPlayerOffset = buffwrap.current_offset

            local playerId = buffwrap:read_bytes(1)
            tree:add(playerDataLength, "Player Data Length: " .. playerDataLength:le_uint())
            local playerSubtree = tree:add(playerId, "Player Id: " .. playerId:uint())

            local name_length = buffwrap:read_bytes(1)
            local name_string = buffwrap:read_bytes(name_length:le_uint())
            playerSubtree:add(name_length, "Name Length: " .. name_length:uint())
            playerSubtree:add(name_string, "Name : " .. name_string:string())

            local color_byte = buffwrap:read_bytes(1)
            playerSubtree:add(color_byte, "Color: " .. Crewmate_Colors[color_byte:uint() + 1])--color + 1 cause Lua table starts at 1

            local hatid, packed_hat_buffer = buffwrap:decode_packed()
            playerSubtree:add(packed_hat_buffer, "Hat Id (Packed Int): " .. hatid)

            local petid, packed_pet_buffer = buffwrap:decode_packed()
            playerSubtree:add(packed_pet_buffer, "Pet Id (Packed Int): " .. petid)

            local skinid, packed_skin_id = buffwrap:decode_packed()
            playerSubtree:add(packed_skin_id, "Skin Id (Packed Int): " .. skinid)

            local flagbitfield = buffwrap:read_bytes(1)
            local deathFlag = bit32.band(flagbitfield:uint(), 4)
            local impostorFlag = bit32.band(flagbitfield:uint(), 2)
            local disconnectFlag = bit32.band(flagbitfield:uint(), 1)
            playerSubtree:add(flagbitfield, "Flags: Disconnect: " .. disconnectFlag ..
                    ", Impostor: " .. impostorFlag ..
                    ", Death: " .. deathFlag)

            local tasks_total = buffwrap:read_bytes(1)
            local tasksSubtree = playerSubtree:add(tasks_total, "Task Amount: " .. tasks_total:uint())
            for i=1, tasks_total:uint(), 1 do
                local taskid, packed_task_id = buffwrap:decode_packed()
                local task_status = buffwrap:read_bytes(1)
                tasksSubtree:add(packed_task_id, "Task Id (Packed Int): " .. taskid)
                if task_status:uint() == 1 then
                    tasksSubtree:add(task_status, "Task complete: true")
                else
                    tasksSubtree:add(task_status, "Task complete: false")
                end
            end

            -- Consume unused bytes
            local actualBytesRead = buffwrap.current_offset - currentPlayerOffset
            local declaredLength = playerDataLength:le_uint() + 1 -- add byte length for id of player
            if actualBytesRead < declaredLength then
                buffwrap:read_bytes(declaredLength - actualBytesRead)
            end
        end




    else
        tree:add(rpc_code, "RPC Code: Unknown RPC Code")
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
end

udp_table = DissectorTable.get("udp.port")
udp_table:add(22023, proto_among_us)
udp_table:add(22123, proto_among_us)
udp_table:add(22223, proto_among_us)
udp_table:add(22723, proto_among_us)
udp_table:add(22823, proto_among_us)
udp_table:add(22623, proto_among_us)