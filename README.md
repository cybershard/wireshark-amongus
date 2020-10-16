# Among Us Wireshark Dissector
This repo contains a Wireshark Lua plugin to tag and analyze packets running on the Among Us UDP ports. 
It registers a new protocol and parses all packets. Currently, a lot of the protocol is fully analyzed, 
but this project a WIP and it doesn't have every detail for every packet.

Contributions are welcome, just open a pull request to the **dev branch**. 

Please open an issue on the Github tracker if you have a packet that doesn't get dissected (or gets dissected incorrectly)

To Do: 
- Add fields to allow easy filtering (currently can only filter wireshark by 'amongus' as a protocol)
- Document fields once created
- Better code style 
- Might be converted to a C plugin if I can get compilation working properly 
