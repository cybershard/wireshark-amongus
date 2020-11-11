proto_among_us = Proto("amongus", "Among Us")





Packet_Format = {
    Unreliable = 0,
    Reliable = 1,
    Hello = 8,
    Disconnect = 9,
    Acknowledgement = 10,
    Ping = 12,
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
    EndGame = 8,
    GetGameList1 = 9, -- impl
    AlterGame = 10,
    KickPlayer = 11,
    WaitForHost = 12, -- impl
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

HeadQuarters_Components = {
    "AllSystemStatuses"
}

PlanetMap_Components = {
    "AllSystemStatuses",
}

AprilShipStatus_Components = {
    "Flipped Skeld",
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
    [0] = "Red",
    [1] = "Blue",
    [2] = "DarkGreen",
    [3] = "Pink",
    [4] = "Orange",
    [5] = "Yellow",
    [6] = "Black",
    [7] = "White",
    [8] = "Purple",
    [9] = "Brown",
    [10] = "Cyan",
    [11] = "Lime"
}

Map_Ids = {
    ["The Skeld"] = 0,
    ["Mira HQ"] = 1,
    ["Polus"] = 2,
    decode = function (self, map_id)
        for type, currid in pairs(self) do
            if not ("decode" == type) and currid == map_id then
                return type
            end
        end
        return "Unknown Map Id: " .. map_id
    end
}

System_Types = {
    ["Hallway"] = 0,
    ["Storage"] = 1,
    ["Cafeteria"] = 2,
    ["Reactor"] = 3,
    ["UpperEngine"] = 4,
    ["Nav"] = 5,
    ["Admin"] = 6,
    ["Electrical"] = 7,
    ["LifeSupp"] = 8,
    ["Shields"] = 9,
    ["MedBay"] = 10,
    ["Security"] = 11,
    ["Weapons"] = 12,
    ["LowerEngine"] = 13,
    ["Comms"] = 14,
    ["ShipTasks"] = 15,
    ["Doors"] = 16,
    ["Sabotage"] = 17,
    ["DecontaminationNormal"] = 18,
    ["Launchpad"] = 19,
    ["LockerRoom"] = 20,
    ["Laboratory"] = 21,
    ["Balcony"] = 22,
    ["Office"] = 23,
    ["Greenhouse"] = 24,
    ["Dropship"] = 25,
    ["DecontaminationRightLab"] = 26,
    ["Outside"] = 27,
    ["Specimens"] = 28,
    ["BoilerRoom"] = 29,
    decode = function (self, system_id)
        for type, currid in pairs(self) do
            if not ("decode" == type) and currid == system_id then
                return type
            end
        end
        return "Unknown System Type: " .. system_id
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

V2 = "QWXRTYLPESDFGHUJKZOCVBINMA"
function V2index (index)
    return string.sub(V2, index + 1, index + 1)
end


function generate_backreference(table)
    local int_to_string = {}
    for key, value in pairs(table) do
        if key ~= "decode" then
            int_to_string[value] = tostring(key)
        end
    end
    return int_to_string
end
Packet_format_its = generate_backreference(Packet_Format)
Payload_Type_its = generate_backreference(Payload_Type)
Game_Data_Part_Type_its = generate_backreference(Game_Data_Part_Type)
--RPC_Code_its = generate_backreference(RPC_Code)
--Spawned_Object_Ids_its = generate_backreference(Spawned_Object_Ids)
--Disconnect_Types_its = generate_backreference(Disconnect_Types)
--Crewmate_Colors_its = generate_backreference(Crewmate_Colors)
--Map_Ids_its = generate_backreference(Map_Ids)
--Language_Ids_its = generate_backreference(Language_Ids)



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
    function object:peek_bytes(consume)
        return self.buffer(self.current_offset, consume)
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




function decode_gamecode (gamecode)
    local a = bit32.band(gamecode, 0x3FF)
    local b = bit32.band(bit32.rshift(gamecode, 10), 0xFFFFF)
    return V2index(a % 26) .. V2index(a / 26)
            .. V2index(b % 26)
            .. V2index(b / 26 % 26)
            .. V2index(b / (26 ^ 2) % 26)
            .. V2index(b / (26 ^ 3) % 26)
end
function decode_amount_repaired(amount) return amount end
function decode_ipv4(ipv4_buffer)
    local ipv4 = ipv4_buffer:tvb()
    local first_octet = ipv4(0, 1)
    local second_octet = ipv4(1, 1)
    local third_octet = ipv4(2, 1)
    local fourth_octet = ipv4(3, 1)
    return "" .. first_octet:uint() .. "."
            .. second_octet:uint() .. "."
            .. third_octet:uint() .. "."
            .. fourth_octet:uint()
end

function lerpValue(val, min, max)
    return min + (max - min) * val
end
function parseMoveVector(x, y)
    local lerpx = lerpValue(x / 65536, -40, 40)
    local lerpy = lerpValue(y / 65536, -40, 40)
    return lerpx, lerpy
end




-- Dissector Main Fields

packet_format_field = ProtoField.uint8("amongus.packet_format", "Packet Format", base.DEC, Packet_format_its)
payload_type_field = ProtoField.uint8("amongus.payload_type", "Payload Type", base.DEC, Payload_Type_its)
game_data_field = ProtoField.uint8("amongus.game_data", "Part Type", base.DEC, Game_Data_Part_Type_its)
--data_game_data_part_field = ProtoField.uint8("amongus.game_data.data", "RPC Type", base.DEC, Game_Data_Part_Type_its)
--rpc_game_data_part_field = ProtoField.uint8("amongus.game_data.rpc", "Payload Type", base.DEC, RPC_Code_its)

proto_among_us.fields = { packet_format_field, payload_type_field, game_data_field }

-- Dissector Main function

function proto_among_us.dissector(buffer, pinfo, tree)
    pinfo.cols.protocol = proto_among_us.name:lower()
    local subtree = tree:add(proto_among_us, buffer(), "Among Us Packet")
    local buffwrap = create_buffer_wrapper(buffer)
    parse_packet_format(buffwrap, pinfo, subtree)
end

function parse_packet_format(buffwrap, pinfo, tree)
    local b_packet_format = buffwrap:read_bytes(1)
    tree:add(packet_format_field, b_packet_format)

    if b_packet_format:uint() == Packet_Format['Unreliable'] then
        parse_packet_payload(buffwrap, pinfo, tree)

    else if b_packet_format:uint() == Packet_Format['Reliable'] then
        local packet_nonce = buffwrap:read_bytes(2)
        tree:add(packet_nonce, "Packet Nonce: " .. packet_nonce:uint())
        parse_packet_payload(buffwrap, pinfo, tree)

    else if b_packet_format:uint() == Packet_Format['Hello'] then
        local packet_nonce = buffwrap:read_bytes(2)
        tree:add(packet_nonce, "Packet Nonce: " .. packet_nonce:uint())
        local hazel_version = buffwrap:read_bytes(1)
        tree:add(hazel_version, "Hazel Version: " .. hazel_version:uint())
        local client_version = buffwrap:read_bytes(4)
        tree:add(client_version, "Client Version: " .. client_version)

        local player_name_length = buffwrap:read_bytes(1)
        tree:add(player_name_length, "Player Name Length: " .. player_name_length:uint())
        local player_name_string = buffwrap:read_bytes(player_name_length:uint())
        tree:add(player_name_string, "Player Name: " .. player_name_string:string())

    else if b_packet_format:uint() == Packet_Format['Disconnect'] then
        if (buffwrap:rest_of_buffer():len() > 0) then
            local disconnectType = buffwrap:read_bytes(1)
            local disconnectString = Disconnect_Types:decode(disconnectType:uint())
            tree:add(disconnectType, "Disconnected: " .. disconnectString)
        end
    else if b_packet_format:uint() == Packet_Format['Acknowledgement'] then
        local packet_nonce = buffwrap:read_bytes(2)
        tree:add(packet_nonce, "Packet Nonce: " .. packet_nonce:uint())

    else if b_packet_format:uint() == Packet_Format['Ping'] then
        local packet_nonce = buffwrap:read_bytes(2)
        tree:add(packet_nonce, "Packet Nonce: " .. packet_nonce:uint())

    end
    end
    end
    end
    end
    end
end

function parse_packet_payload(buffwrap, pinfo, tree)

    while (buffwrap:rest_of_buffer():len() > 0) do

        local payload_length = buffwrap:read_bytes(2)
        tree:add(payload_length, "Packet Length: " .. payload_length:le_uint())
        local payloadStartOffset = buffwrap.current_offset
        local b_payload_type = buffwrap:read_bytes(1)
        local subtree = tree:add(payload_type_field, b_payload_type)


        if b_payload_type:uint() == Payload_Type['CreateGame'] then
            if not (payload_length:le_uint() == 43) then -- Length of a GetGameList Packet (GameOptionsData + 2 bytes for length)
                local gamecode = buffwrap:read_bytes(4)
                subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))
                return
            end

            local settingsLength, packed_settings_length = buffwrap:decode_packed()
            subtree:add(packed_settings_length, "GameOptionsData Length (Packed Int): " .. settingsLength)
            parseGameOptionsData(buffwrap, pinfo, subtree)

        else if b_payload_type:uint() == Payload_Type['JoinGame'] then
            if payload_length:le_uint() == 5 then
                local gamecode = buffwrap:read_bytes(4)
                local map_ownership = buffwrap:read_bytes(1)
                subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))
                subtree:add(map_ownership, "Map Ownership: " .. map_ownership)
            else if payload_length:le_uint() == 12 then
                local gamecode = buffwrap:read_bytes(4)
                local clientid = buffwrap:read_bytes(4)
                local hostid = buffwrap:read_bytes(4)

                subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))
                subtree:add(clientid, "Client Id: " .. clientid:le_uint())
                subtree:add(hostid, "Host Id: " .. hostid:le_uint())

            else
                local disconnectType = buffwrap:read_bytes(1)
                local disconnectString = Disconnect_Types:decode(disconnectType:uint())
                subtree:add(disconnectType, "Disconnected: " .. disconnectString)
            end
            end

        else if b_payload_type:uint() == Payload_Type['StartGame'] then
            local gamecode = buffwrap:read_bytes(4)
            subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))

        else if b_payload_type:uint() == Payload_Type['RemoveGame'] then

        else if b_payload_type:uint() == Payload_Type['RemovePlayer'] then
            local gamecode = buffwrap:read_bytes(4)
            local clientid = buffwrap:read_bytes(4)
            local hostid = buffwrap:read_bytes(4)
            local reasonId = buffwrap:read_bytes(1)
            subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))
            subtree:add(clientid, "Client Id: " .. clientid:le_uint())
            subtree:add(hostid, "Host Id: " .. hostid:le_uint())
            subtree:add(reasonId, "Reason Id: " .. reasonId:uint())


        else if b_payload_type:uint() == Payload_Type['GameData'] then
            local gamecode = buffwrap:read_bytes(4)
            subtree:add(gamecode, "Gamecode: " .. decode_gamecode(gamecode:int()))

            parseGameDataParts(buffwrap, pinfo, subtree,
                    payload_length:le_uint() - 4) -- minus 4 because of gamecode bytes

        else if b_payload_type:uint() == Payload_Type['GameDataTo'] then
            local gamecode = buffwrap:read_bytes(4)
            local recipientid, packed_recipientid_buffer = buffwrap:decode_packed()
            subtree:add(gamecode, "Gamecode: " .. decode_gamecode(gamecode:int()))
            subtree:add(packed_recipientid_buffer, "Recipient Client ID (Packed Int): " .. recipientid)

            parseGameDataParts(buffwrap, pinfo, subtree,
                    payload_length:le_uint() - 4 - packed_recipientid_buffer:len()) -- minus 4 because of gamecode bytes

        else if b_payload_type:uint() == Payload_Type['JoinedGame'] then
            local gamecode = buffwrap:read_bytes(4)
            local clientid = buffwrap:read_bytes(4)
            local hostid = buffwrap:read_bytes(4)
            subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))
            subtree:add(clientid, "Client Id: " .. clientid:le_uint())
            subtree:add(hostid, "Host Id: " .. hostid:le_uint())

            local otherPlayerIdCount, packed_other_client_count = buffwrap:decode_packed()

            local other_player_subtree = subtree:add(packed_other_client_count,
                "Other Client Id Count (Packed Int): " .. otherPlayerIdCount)
            for i=1, otherPlayerIdCount, 1
            do
                local otherPlayerId, packed_other_player_id = buffwrap:decode_packed()
                other_player_subtree:add(packed_other_player_id, "Other Client " .. i .. ": " .. otherPlayerId)
            end
        else if b_payload_type:uint() == Payload_Type["EndGame"] then
            local gamecode = buffwrap:read_bytes(4)
            subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))
            local end_reason = buffwrap:read_bytes(1)
            subtree:add(end_reason, "End Reason: " .. end_reason:uint())
            local show_ad = buffwrap:read_bytes(1)
            subtree:add(show_ad, "Show Ad: " .. end_reason:uint())

        else if b_payload_type:uint() == Payload_Type["AlterGame"] then
            local gamecode = buffwrap:read_bytes(4)
            subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))

            local payloadVersion = buffwrap:read_bytes(1)
            local privacyBool = buffwrap:read_bytes(1)
            if privacyBool:uint() == 1 then
                subtree:add(privacyBool, "Privacy: Public")
            else
                subtree:add(privacyBool, "Privacy: Private")
            end
        else if b_payload_type:uint() == Payload_Type["KickPlayer"] then
            if payload_length:le_uint() == 2 then
                local playerId, packed_player_id_buffer = buffwrap:decode_packed()
                subtree:add(packed_player_id_buffer, "Player Id (Packed Int): " .. playerId)
                if banned:uint() == 1 then
                    subtree:add(banned, "Banned: true")
                else if banned:uint() == 0 then
                    subtree:add(banned, "Banned: false")
                end
                end
            else
                local gamecode = buffwrap:read_bytes(4)
                subtree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))
                local playerId, packed_player_id_buffer = buffwrap:decode_packed()
                subtree:add(packed_player_id_buffer, "Player Id (Packed Int): " .. playerId)
                local banned = buffwrap:read_bytes(1)
                if banned:uint() == 1 then
                    subtree:add(banned, "Banned: true")
                else if banned:uint() == 0 then
                    subtree:add(banned, "Banned: false")
                end
                end
            end
        else if b_payload_type:uint() == Payload_Type['Redirect'] then
                local ipaddr = buffwrap:read_bytes(4)
                local port = buffwrap:read_bytes(2)
                subtree:add(ipaddr, "Redirect To IP: " .. decode_ipv4(ipaddr))
                subtree:add(port, "Redirect To Port: " .. port:le_uint())

        else if b_payload_type:uint() == Payload_Type['RedirectMasterServer'] then
            local masterServerListVersion = buffwrap:read_bytes(1)
            local masterServerListLength = buffwrap:read_bytes(1)
            subtree:add(masterServerListLength, "MasterServerList Length: " .. masterServerListLength:le_uint())
            for i=1,masterServerListLength:le_uint(),1
            do
                local serverStart = buffwrap:peek_bytes(3)
                local serverTree = subtree:add(serverStart, "Master Server " .. i)

                local serverLength = buffwrap:read_bytes(2)
                serverTree:add(serverLength, "Server Length: " .. serverLength:le_uint())
                seperatorTag = buffwrap:read_bytes(1)

                local name_length = buffwrap:read_bytes(1)
                local name_string = buffwrap:read_bytes(name_length:le_uint())
                serverTree:add(name_length, "Name Length: ", name_length:uint())
                serverTree:add(name_string, "Name: " .. name_string:string())

                local ipaddr = buffwrap:read_bytes(4)
                local port = buffwrap:read_bytes(2)
                serverTree:add(ipaddr, "IP: " .. decode_ipv4(ipaddr))
                serverTree:add(port, "Port: " .. port:le_uint())
                local player_count = buffwrap:read_bytes(2)
                serverTree:add(player_count, "Player Count: " .. player_count:le_uint())
            end

        else if b_payload_type:uint() == Payload_Type['GetGameList2'] then
            if not (payload_length:le_uint() == 44) then -- Length of a GetGameList Packet (GameOptionsData + 2 bytes for length)
                subtree:add(buffwrap:peek_bytes(payload_length:le_uint()), "Get Game List V2 (Response)")

                local gameListLength = buffwrap:read_bytes(2)
                local gameListTree = subtree:add(gameListLength, "Games List Length: " .. gameListLength:le_uint())
                local seperatorTag = buffwrap:read_bytes(1)


                local startOffset = buffwrap.current_offset
                while (buffwrap.current_offset - startOffset < gameListLength:le_uint()) do

                    local gameServerInfoLength = buffwrap:read_bytes(1)
                    local gameInfoTree = gameListTree:add(gameServerInfoLength,
                            "Game Info Length: " .. gameServerInfoLength:uint())
                    seperatorTag = buffwrap:read_bytes(2)
                    local ipaddr = buffwrap:read_bytes(4)
                    local port = buffwrap:read_bytes(2)
                    gameInfoTree:add(ipaddr, "IP: " .. decode_ipv4(ipaddr))
                    gameInfoTree:add(port, "Port: " .. port:le_uint())
                    local gamecode = buffwrap:read_bytes(4)
                    gameInfoTree:add(gamecode, "Game Code: " .. decode_gamecode(gamecode:int()))
                    local name_length = buffwrap:read_bytes(1)
                    local name_string = buffwrap:read_bytes(name_length:le_uint())
                    gameInfoTree:add(name_length, "Name Length: ", name_length:uint())
                    gameInfoTree:add(name_string, "Name: " .. name_string:string())
                    local player_count = buffwrap:read_bytes(1)
                    gameInfoTree:add(player_count, "Player Count: " .. player_count:uint())
                    local age, packet_age_buffer = buffwrap:decode_packed()
                    gameInfoTree:add(packet_age_buffer, "Age (Packed Int): " .. age)
                    local mapId = buffwrap:read_bytes(1)
                    gameInfoTree:add(mapId, "Map Id: " .. Map_Ids:decode(mapId:uint()))
                    local numberImpostors = buffwrap:read_bytes(1)
                    gameInfoTree:add(numberImpostors, "Number of Impostors: " .. numberImpostors:uint())
                    local maxPlayers = buffwrap:read_bytes(1)
                    gameInfoTree:add(maxPlayers, "Max Players: " .. maxPlayers:uint())

                end
                return
            end
            local settingsLength = buffwrap:read_bytes(2)
            subtree:add(settingsLength, "GameOptionsData Length: " .. settingsLength:uint())
            parseGameOptionsData(buffwrap, pinfo, subtree)


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


        -- Consume Unused bytes
        local actualBytesRead = buffwrap.current_offset - payloadStartOffset
        local declaredLength = payload_length:le_uint() + 1 -- to add in the payload type
        if actualBytesRead < declaredLength then
            buffwrap:read_bytes(declaredLength - actualBytesRead)
        end
    end
end

-- NOT RPC 2 SyncSettings!
function parseGameOptionsData(buffwrap, pinfo, tree)
    local version = buffwrap:read_bytes(1)
    tree:add(version, "Version: " .. version:uint())

    local maxPlayers = buffwrap:read_bytes(1)
    tree:add(maxPlayers, "Max Players: " .. maxPlayers:uint())
    local language = buffwrap:read_bytes(4)
    tree:add(language, "Language: " .. Language_Ids:decode(language:le_uint()))
    local mapId = buffwrap:read_bytes(1)
    tree:add(mapId, "Map Id: " .. Map_Ids:decode(mapId:uint()))

    local playerSpeed = buffwrap:read_bytes(4)
    tree:add(playerSpeed, "Player Speed: " .. playerSpeed:le_float())
    local crewmateVision = buffwrap:read_bytes(4)
    tree:add(crewmateVision, "Crewmate Vision: " .. crewmateVision:le_float())
    local impostorVision = buffwrap:read_bytes(4)
    tree:add(impostorVision, "Impostor Vision: " .. impostorVision:le_float())
    local killCooldown = buffwrap:read_bytes(4)
    tree:add(killCooldown, "Kill Cooldown: " .. killCooldown:le_float())

    local commonTasks = buffwrap:read_bytes(1)
    tree:add(commonTasks, "Common Tasks: " .. commonTasks:uint())
    local longTasks = buffwrap:read_bytes(1)
    tree:add(longTasks, "Long Tasks: " .. longTasks:uint())
    local shortTasks = buffwrap:read_bytes(1)
    tree:add(shortTasks, "Short Tasks: " .. shortTasks:uint())

    local emergencyMeetings = buffwrap:read_bytes(4)
    tree:add(emergencyMeetings, "Emergency Meeting: " .. emergencyMeetings:le_uint())
    local impostorCount = buffwrap:read_bytes(1)
    tree:add(impostorCount, "Impostor Count: " .. impostorCount:uint())
    local killDistance = buffwrap:read_bytes(1)
    tree:add(killDistance, "Kill Distance: " .. killDistance:uint())

    local discussionTime = buffwrap:read_bytes(4)
    tree:add(discussionTime, "Discussion Time: " .. discussionTime:le_uint())
    local votingTime = buffwrap:read_bytes(4)
    tree:add(votingTime, "Voting Time: " .. votingTime:le_uint())

    local defaults = buffwrap:read_bytes(1)
    tree:add(defaults, "Defaults: " .. defaults:uint())


    if (version:uint() >= 2) then
        local emergencyCooldown = buffwrap:read_bytes(1)
        tree:add(emergencyCooldown, "Emergency Cooldown: " .. emergencyCooldown:uint())
    end
    if (version:uint() >= 3) then
        local confirmEjects = buffwrap:read_bytes(1)
        tree:add(confirmEjects, "Confirm Ejects: " .. confirmEjects:uint())
        local visualTasks = buffwrap:read_bytes(1)
        tree:add(visualTasks, "Visual Tasks: " .. visualTasks:uint())
    end
    if (version:uint() >= 4) then
        local anonVoting = buffwrap:read_bytes(1)
        if (anonVoting:uint() == 1) then
            tree:add(anonVoting, "Anonymous Voting: " .. "True")
        else if (anonVoting:uint() == 0) then
            tree:add(anonVoting, "Anonymous Voting: " .. "False")
        end
        end

        local taskbarUpdates = buffwrap:read_bytes(1)
        if (taskbarUpdates:uint() == 0) then
            tree:add(taskbarUpdates, "Taskbar Updates: " .. "Always")
        else if (taskbarUpdates:uint() == 1) then
            tree:add(taskbarUpdates, "Taskbar Updates: " .. "In Meetings")
        else if (taskbarUpdates:uint() == 2) then
            tree:add(taskbarUpdates, "Taskbar Updates: " .. "Never")
        end
        end
        end
    end
end


function parseGameDataParts(buffwrap, pinfo, tree, gameDataPartLength)
    local startOffset = buffwrap.current_offset
    while (buffwrap.current_offset - startOffset < gameDataPartLength)
    do
        local part_length = buffwrap:read_bytes(2)
        tree:add(part_length, "Part Length: " .. part_length:le_uint())
        local startActualOffset = buffwrap.current_offset

        local part_type = buffwrap:read_bytes(1)
        local subtree = tree:add(game_data_field, part_type)
        if part_type:uint() == Game_Data_Part_Type['Data'] then
            parseDataPart(buffwrap, pinfo, subtree, part_length:le_uint())

        else if part_type:uint() == Game_Data_Part_Type['RPC'] then
            parseRPCPart(buffwrap, pinfo, subtree, part_length:le_uint())

        else if part_type:uint() == Game_Data_Part_Type['Spawn'] then
            parseSpawnPart(buffwrap, pinfo, subtree)

        else if part_type:uint() == Game_Data_Part_Type['Despawn'] then
            local netid, packed_net_id_buffer = buffwrap:decode_packed()
            tree:add(packed_net_id_buffer, "Net Id (Packed Int): " .. netid)

        else if part_type:uint() == Game_Data_Part_Type['SceneChange'] then
            local clientid, packed_client_id_buffer = buffwrap:decode_packed()
            local sceneLength = buffwrap:read_bytes(1)
            local sceneName = buffwrap:read_bytes(sceneLength:le_uint())
            tree:add(packed_client_id_buffer, "Client Id (Packed Int): " .. clientid)
            tree:add(sceneLength, "Scene Name Length: " .. sceneLength:le_uint())
            tree:add(sceneName, "Scene Name: " .. sceneName:string())

        else if part_type:uint() == Game_Data_Part_Type['Ready'] then
            local playerid, packed_player_id_buffer = buffwrap:decode_packed()
            tree:add(packed_player_id_buffer, "Player Id (Packed Int): " .. playerid)

        else if part_type:uint() == Game_Data_Part_Type['ChangeSettings'] then
            -- TODO: Unused by among Us
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

function parseDataPart(buffwrap, pinfo, tree, part_length)
    local netid, packed_net_id_buffer = buffwrap:decode_packed()
    tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)

    if (part_length - packed_net_id_buffer:len()) ~= 10 then
        local unknownBuffer = buffwrap:read_bytes(part_length - packed_net_id_buffer:len())
        tree:add(unknownBuffer, "Unknown Data")
        return
    end

    local sequenceId = buffwrap:read_bytes(2)
    tree:add(sequenceId, "Sequence Id: " .. sequenceId:le_uint())

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
    -- TODO: Parse HeadQuarters and PlanetMap

    local whole_packet_buffer = buffwrap.buffer(startOffset, packed_net_id_buffer:len() + 3 + component_length:le_uint())
    local component_tree

    if objecttype == Spawned_Object_Ids["ShipStatus"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. ShipStatus_Components[index] .. ")")
        component_tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
        component_tree:add(component_length, "Component Length: " .. component_length:le_uint())
        local data = buffwrap:read_bytes(component_length:le_uint())
        component_tree:add(data, "Component Data: " .. data)

    else if objecttype == Spawned_Object_Ids["MeetingHud"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. MeetingHud_Components[index] .. ")")
        component_tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
        component_tree:add(component_length, "Component Length: " .. component_length:le_uint())

        for i=1, component_length:le_uint(), 1 do
            local voteAreaFlag = buffwrap:read_bytes(1)
            local voteAreaFlagTree = component_tree:add(voteAreaFlag, "Player Id: " .. i)
            local reported_player_id = bit32.band(voteAreaFlag:uint(), 0x0F) - 1
            local did_report = bit32.band(voteAreaFlag:uint(), 0x20)
            local did_vote = bit32.band(voteAreaFlag:uint(), 0x40)
            local is_dead = bit32.band(voteAreaFlag:uint(), 0x80)
            voteAreaFlagTree:add(voteAreaFlag, "Reported Player Id: " .. reported_player_id)
            voteAreaFlagTree:add(voteAreaFlag, "Did Report: " .. did_report)
            voteAreaFlagTree:add(voteAreaFlag, "Did Vote: " .. did_vote)
            voteAreaFlagTree:add(voteAreaFlag, "Is Dead: " .. is_dead)

        end


    else if objecttype == Spawned_Object_Ids["LobbyBehaviour"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. Lobby_Components[index] .. ")")
        component_tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
        component_tree:add(component_length, "Component Length: " .. component_length:le_uint())
        local data = buffwrap:read_bytes(component_length:le_uint())
        component_tree:add(data, "Component Data: " .. data)

    else if objecttype == Spawned_Object_Ids["GameData"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. GameData_Components[index] .. ")")
        component_tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
        component_tree:add(component_length, "Component Length: " .. component_length:le_uint())

        if index == 1 then
            local player_count, player_count_buffer = buffwrap:decode_packed()
            local dataTree = component_tree:add(player_count_buffer, "Player Count (Packed Int): " .. player_count)
            for i=1, player_count, 1 do
                local player_id = buffwrap:read_bytes(1)
                local playerSubtree = dataTree:add(player_id, "Player Id: " .. player_id:uint())

                local name_length = buffwrap:read_bytes(1)
                local name_string = buffwrap:read_bytes(name_length:le_uint())
                playerSubtree:add(name_length, "Name Length: ", name_length:uint())
                playerSubtree:add(name_string, "Name: " .. name_string:string())

                local color_byte = buffwrap:read_bytes(1)
                playerSubtree:add(color_byte, "Color: " .. Crewmate_Colors[color_byte:uint()])

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
            end
        else
            local data = buffwrap:read_bytes(component_length:le_uint())
            component_tree:add(data, "Component Data: " .. data)
        end

    else if objecttype == Spawned_Object_Ids["Player"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. Player_Components[index] .. ")")
        component_tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
        component_tree:add(component_length, "Component Length: " .. component_length:le_uint())


        if index == 1 then
            local is_new = buffwrap:read_bytes(1)
            if is_new:uint() == 1 then
                component_tree:add(is_new, "Is New (to the game): true")
            else
                component_tree:add(is_new, "Is New (to the game): false")
            end

            local player_id = buffwrap:read_bytes(1)
            component_tree:add(player_id, "Player Id: " .. player_id:uint())
        else if index == 3 then
            local sequenceId = buffwrap:read_bytes(2)
            component_tree:add(sequenceId, "Sequence Id: " .. sequenceId:le_uint())

            local x = buffwrap:read_bytes(2)
            local y = buffwrap:read_bytes(2)
            local dx = buffwrap:read_bytes(2)
            local dy = buffwrap:read_bytes(2)

            local poseX, poseY = parseMoveVector(x:le_uint(), y:le_uint())
            local velX, velY = parseMoveVector(dx:le_uint(), dy:le_uint())
            component_tree:add(x, "Pose Vector.x: " .. poseX)
            component_tree:add(y, "Pose Vector.y: " .. poseY)
            component_tree:add(dx, "Velocity Vector.x: " .. velX)
            component_tree:add(dy, "Velocity Vector.y: " .. velY)
        else
            local data = buffwrap:read_bytes(component_length:le_uint())
            component_tree:add(data, "Component Data: " .. data)
        end
        end

    else if objecttype == Spawned_Object_Ids["HeadQuarters"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. HeadQuarters_Components[index] .. ")")
        component_tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
        component_tree:add(component_length, "Component Length: " .. component_length:le_uint())
        local data = buffwrap:read_bytes(component_length:le_uint())
        component_tree:add(data, "Component Data: " .. data)

    else if objecttype == Spawned_Object_Ids["PlanetMap"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. PlanetMap_Components[index] .. ")")
        component_tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
        component_tree:add(component_length, "Component Length: " .. component_length:le_uint())
        local data = buffwrap:read_bytes(component_length:le_uint())
        component_tree:add(data, "Component Data: " .. data)

    else if objecttype == Spawned_Object_Ids["AprilShipStatus"] then
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (" .. AprilShipStatus_Components[index] .. ")")
        component_tree:add(packed_net_id_buffer, "NetId (Packed Int): " .. netid)
        component_tree:add(component_length, "Component Length: " .. component_length:le_uint())
        local data = buffwrap:read_bytes(component_length:le_uint())
        component_tree:add(data, "Component Data: " .. data)

    else
        component_tree = tree:add(whole_packet_buffer, "Component " .. index
                .. " (Unknown)")
    end
    end
    end
    end
    end
    end
    end
    end

    -- Consume unused bytes
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

        parseGameOptionsData(buffwrap, pinfo, settingssubtree)

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
        tree:add(color_byte, "Color: " .. Crewmate_Colors[color_byte:uint()])

    else if rpc_code:uint() == RPC_Code['SetColor'] then
        tree:add(rpc_code, "RPC Code: SetColor")
        local color_byte = buffwrap:read_bytes(1)
        tree:add(color_byte, "Color: " .. Crewmate_Colors[color_byte:uint()])

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
            tree:add(scanning_bool_byte, "Scanning: true")
        else if scanning_bool_byte:uint() == 0 then
            tree:add(scanning_bool_byte, "Scanning: false")
        end
        end
        tree:add(scanning_stage, "Scanning Stage: " .. scanning_stage:uint())

    else if rpc_code:uint() == RPC_Code['SendChatNote'] then
        tree:add(rpc_code, "RPC Code: SendChatNote")
        local playerId = buffwrap:read_bytes(1)
        tree:add(playerId, "Player Id: " .. playerId:uint())
        local chat_note_type = buffwrap:read_bytes(1)
        tree:add(chat_note_type, "ChatNoteType: " .. chat_note_type:uint())


    else if rpc_code:uint() == RPC_Code['SetPet'] then
        tree:add(rpc_code, "RPC Code: SetPet")
        local pet_byte = buffwrap:read_bytes(1)
        tree:add(pet_byte, "Pet Id: " .. pet_byte:uint())

    else if rpc_code:uint() == RPC_Code['SetStartCounter'] then
        tree:add(rpc_code, "RPC Code: SetStartCounter")

        local sequence_counter, packed_counter_buffer = buffwrap:decode_packed()
        tree:add(packed_counter_buffer, "Sequence Id: " .. sequence_counter)
        local startCounter = buffwrap:read_bytes(1)
        tree:add(startCounter, "Start Counter: " .. startCounter:uint())

    else if rpc_code:uint() == RPC_Code['EnterVent'] then
        tree:add(rpc_code, "RPC Code: EnterVent")
        local ventId, packed_ventid_buffer = buffwrap:decode_packed()
        tree:add(packed_ventid_buffer, "Vent Id: " .. ventId)

    else if rpc_code:uint() == RPC_Code['ExitVent'] then
        tree:add(rpc_code, "RPC Code: ExitVent")
        local ventId, packed_ventid_buffer = buffwrap:decode_packed()
        tree:add(packed_ventid_buffer, "Vent Id: " .. ventId)

    else if rpc_code:uint() == RPC_Code['SnapTo'] then
        tree:add(rpc_code, "RPC Code: SnapTo")
        local x = buffwrap:read_bytes(2)
        local y = buffwrap:read_bytes(2)
        local poseX, poseY = parseMoveVector(x:le_uint(), y:le_uint())
        tree:add(x, "Pose Vector.x: " .. poseX)
        tree:add(y, "Pose Vector.y: " .. poseY)
        local sequence_counter = buffwrap:read_bytes(2)
        tree:add(sequence_counter, "Sequence: " .. sequence_counter:le_uint())


    else if rpc_code:uint() == RPC_Code['Close'] then
        tree:add(rpc_code, "RPC Code: Close")

    else if rpc_code:uint() == RPC_Code['VotingComplete'] then
        tree:add(rpc_code, "RPC Code: VotingComplete")
        local statesLength = buffwrap:read_bytes(1)
        local states = buffwrap:read_bytes(statesLength:uint())
        local exiledPlayerId = buffwrap:read_bytes(1)
        local tiedVote = buffwrap:read_bytes(1)
        tree:add(statesLength, "States Length: " .. statesLength:uint())
        tree:add(states, "States: " .. states)
        tree:add(exiledPlayerId, "Exiled Player Id " .. exiledPlayerId:uint())
        tree:add(tiedVote, "Vote tied: " .. tiedVote:uint())

    else if rpc_code:uint() == RPC_Code['CastVote'] then
        tree:add(rpc_code, "RPC Code: CastVote")
        local playerId = buffwrap:read_bytes(1)
        tree:add(playerId, "Player Id: " .. playerId:uint())
        local suspectId = buffwrap:read_bytes(1)
        tree:add(suspectId, "Suspect Id: " .. suspectId:uint())

    else if rpc_code:uint() == RPC_Code['ClearVote'] then
        tree:add(rpc_code, "RPC Code: ClearVote")
        local playerId = buffwrap:read_bytes(1)
        tree:add(playerId, "Player Id: " .. playerId:uint())

    else if rpc_code:uint() == RPC_Code['AddVote'] then
        tree:add(rpc_code, "RPC Code: AddVote")
        local playerId = buffwrap:read_bytes(1)
        tree:add(playerId, "Player Id: " .. playerId:uint())

    else if rpc_code:uint() == RPC_Code['CloseDoorsOfType'] then
        tree:add(rpc_code, "RPC Code: CloseDoorsOfType")
        local doorType = buffwrap:read_bytes(1)
        tree:add(doorType, "Door Type: " .. System_Types:decode(doorType:uint()))

    else if rpc_code:uint() == RPC_Code['RepairSystem'] then
        tree:add(rpc_code, "RPC Code: RepairSystem")
        local systemType = buffwrap:read_bytes(1)
        tree:add(systemType, "System Type: " .. System_Types:decode(systemType:uint()))
        local senderNetId, packet_senderNetId = buffwrap:decode_packed()
        tree:add(packet_senderNetId, "Sender Id (Packed Int): " .. senderNetId)
        local amount = buffwrap:read_bytes(1)
        if systemType:uint() == System_Types["Sabotage"] then
            tree:add(amount, "System sabotaged: " .. System_Types:decode(amount:uint()))
        else
            tree:add(amount, "Amount repaired: " .. decode_amount_repaired(amount))
        end

        

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
            local player_count = buffwrap:read_bytes(2)
            local currentPlayerOffset = buffwrap.current_offset

            local playerId = buffwrap:read_bytes(1)
            tree:add(player_count, "Player Data Length: " .. player_count:le_uint())
            local playerSubtree = tree:add(playerId, "Player Id: " .. playerId:uint())

            local name_length = buffwrap:read_bytes(1)
            local name_string = buffwrap:read_bytes(name_length:le_uint())
            playerSubtree:add(name_length, "Name Length: " .. name_length:uint())
            playerSubtree:add(name_string, "Name : " .. name_string:string())

            local color_byte = buffwrap:read_bytes(1)
            playerSubtree:add(color_byte, "Color: " .. Crewmate_Colors[color_byte:uint()])

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
            local declaredLength = player_count:le_uint() + 1 -- add byte length for id of player
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
udp_table:add(22323, proto_among_us)
udp_table:add(22423, proto_among_us)
udp_table:add(22523, proto_among_us)
udp_table:add(22623, proto_among_us)
udp_table:add(22723, proto_among_us)
udp_table:add(22823, proto_among_us)
udp_table:add(22923, proto_among_us)
