# Teleport Dialog
A simple teleport dialog. It allows players to teleport to other alive players of the same side or custom locations.

![107410_20210422010444_1](https://user-images.githubusercontent.com/17484252/115631821-db576080-a306-11eb-9cff-d6430483cce3.png)


# Installation

1. Copy the `TPD_teleportDialog` folder into your mission folder
2. Copy the following into your `description.ext`:
```
class CfgFunctions
{
  class TPD
  {
    tag = "TPD";
    class Initialize
    {
      file = "TPD_teleportDialog";
      class teleport;
    };
  };
};

//If these are already present do not add them
import ctrlListBox;
import ctrlButton;
import ctrlStaticTitle;
import ctrlStaticBackground;

#include "TPD_teleportDialog\GUI.hpp"
```

3. Create a file called `initServer.sqf` and write the following in it:

```
["setCustomLocations", [["MHQ", MQH, [1, 0, 0, 1]]]] call TPD_fnc_teleport; // Set custom locations

["enableGlobalMessage", false] call TPD_fnc_teleport; // Disable global message

["addActions", [TPD_1, MHQ]] call TPD_fnc_teleport; // Add actions to given objects for all players
```

4. Place two objects in the editor and give them the variable names *TPD_1* and *MHQ*

# Function Description and Customisation
```
/*
  Author: R3vo

  Description:
  Handles the teleport GUI functionality. Needs to run in scheduled environment. Will also show a global message in side channel.

  Parameter(s):
  
  0: STRING - Mode, can be:
    "onLoad" (Internal use)
    "teleport" (Internal use)
    "disableGlobalMessage" - Disable or enable global message
    "addActions" - Will add actions to given objects globally
    "setCustomLocations" - Set the custom locations.

      Each custom location is an array in format
      0: STRING - Name displayed in the GUI
      1: ARRAY ([x, y] or [x, y, z]), OBJECT, GROUP, STRING (marker or variable name containing an object), LOCATION
      2: ARRAY - (optional, default [1, 1, 1, 1]) Color in format RGBA. Can be used to highlight the entry in the list

    
  2: ARRAY, BOOLEAN - Parameters according to mode
  3: DISPLAY - Teleport GUI (internal only)

  Returns:
  -

  Examples:
  ["setCustomLocations", [["MHQ", MQH, [1, 0, 0, 1]]]] call TPD_fnc_teleport; // Set custom locations

  ["enableGlobalMessage", false] call TPD_fnc_teleport; // Disable global message

  ["addActions", [TPD_1, MHQ]] call TPD_fnc_teleport; // Add actions to given objects for all players
*/
```
