# Among Us Wireshark Dissector
This repo contains a Wireshark Lua plugin to tag and analyze packets running on the Among Us UDP ports. 
It registers a new protocol and parses all packets. Currently, a lot of the protocol is fully analyzed. 
One caveat to this dissector is that it is stateless: if a field requires context from a previous packet, only the 
representation of the field as it appears in the packet will be shown (so numerical ID instead of resolving to a player name).
However, this also means that the dissector will never be in a unknown bad state and give wrong info.

## Installation
Install the lua plugin by cloning this repo and dropping the `among_us_dissector.lua` in your device specific plugin folder
- Read this: https://www.wireshark.org/docs/wsug_html_chunked/ChPluginFolders.html
- Windows: `%APPDATA%\Wireshark\plugins`
- macOS: `%APPDIR%/Contents/PlugIns/wireshark` if installed as an application bundle, or `INSTALLDIR/lib/wireshark/plugins` if installed seperately
- Linux/Unix-like OSes: `~/.local/lib/wireshark/plugins`

## Basic Usage
- First, open up wireshark on the interface that the client is sending through (localhost if running a local server)
- Filter output by protocol `amongus` in the filter bar
- View packet dissection in the tree

## Filter examples
- View Among Us protocol UDP packets only: `amongus`
- View only Among Us reliable packets: `amongus and amongus.packet_format eq Reliable` or `amongus and amongus.packet_format eq 1`
- Remove Pings and ACKs from the view: `amongus and !(amongus.packet_format eq Ping or amongus.packet_format eq Acknowledgement)`
- View only GameData payload packets (reliable and unreliable packets): `amongus and amongus.payload_type eq GameData`
- The valid names/numbers for `amongus.packet_format` and `amongus.payload_type` and `amongus.game_data` are:
     - ```
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
            AlterGame = 10,
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
        ```

## Contributions and Issues
Contributions are welcome, just open a pull request to the **dev branch**. 

Please open an issue on the Github tracker if you have a packet that doesn't get dissected (or gets dissected incorrectly)

Worked On:
- Fields for protocol. Packet Format (Reliable, Hello, etc) and Payload Type (JoinGame, GameData, etc)

To Do: 
- Add more fields to allow easy filtering
- Document fields once created
- Better code style (Use tables to index and retreive parsing functions for each packet format type)
- Might be converted to a C plugin if I can get compilation working properly 

## Credits
Thank you to the [Among Us Protocol Wiki](https://wiki.weewoo.net/) and everyone in the [Impostor discord](https://discord.gg/Mk3w6Tb)
