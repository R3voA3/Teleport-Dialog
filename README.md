
# Teleport Dialog
A simple teleport dialog which allows players to move instantly to other players or custom locations. Teleportation is not possible if:
- The side of the player is not equal to the side of the target
- The target is in a vehicle
- The target is dead
![107410_20210423020907_1](https://user-images.githubusercontent.com/17484252/115799547-05795300-a3d9-11eb-8af2-d46853638dd2.png)

# Installation
1. Copy the `TPD` folder into your mission folder
2. Copy the following into your `description.ext`:
```
class CfgFunctions
{
  #include "TPD\CfgFunctions.hpp"
};
```

3. Create a file called `initServer.sqf` and write the following in it:

```
["setCustomLocations", [["MHQ", MQH, [1, 0, 0, 1]]]] call TPD_fnc_teleport; // Set custom locations

["enableGlobalMessage", false] call TPD_fnc_teleport; // Disable global message

["addActions", [TPD_1, MHQ]] call TPD_fnc_teleport; // Add actions to given objects for all players
```

4. Place two objects in the editor and give them the variable names *TPD_1* and *MHQ*

# Function Description and Customisation
See [fn_teleport.sqf](https://github.com/R3voA3/Arma-3-Teleport-Dialog/blob/cec9852f2ba53800465620f6af04ddf146753404/TPD_teleportDialog/fn_teleport.sqf#L1)