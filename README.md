# Among Us Wireshark Dissector
This repo contains a Wireshark Lua plugin to tag and analyze packets running on the Among Us UDP ports. 
It registers a new protocol and parses all packets. Currently, a lot of the protocol is fully analyzed, 
but this project a WIP and it doesn't have every detail for every packet.

## Installation
Install the lua plugin by cloning this repo and dropping the `among_us_dissector.lua` in your device specific plugin folder
- Read this: https://www.wireshark.org/docs/wsug_html_chunked/ChPluginFolders.html
- Windows: `%APPDATA%\Wireshark\plugins`
- macOS: `%APPDIR%/Contents/PlugIns/wireshark` if installed as an application bundle, or `INSTALLDIR/lib/wireshark/plugins` if installed seperately
- Linux/Unix-like OSes: `~/.local/lib/wireshark/plugins`

## Contributions and Issues
Contributions are welcome, just open a pull request to the **dev branch**. 

Please open an issue on the Github tracker if you have a packet that doesn't get dissected (or gets dissected incorrectly)

To Do: 
- Add fields to allow easy filtering (currently can only filter wireshark by 'amongus' as a protocol)
- Document fields once created
- Better code style (Use tables to index and retreive parsing functions for each packet format type)
- Might be converted to a C plugin if I can get compilation working properly 

## Credits
Thank you to the [Among Us Protocol Wiki](https://wiki.weewoo.net/) and everyone in the [Impostor discord](https://discord.gg/Mk3w6Tb)
