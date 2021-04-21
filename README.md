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

3. (OPTIONAL) Create a file called `initPlayerLocal.sqf` and write the following in it:

```Teleport_Object addAction ["<img image='\a3\modules_f_curator\data\portraitobjectivemove_ca.paa'/> Select Teleport Location", {findDisplay 46 createDisplay "TPD_Teleport"}, nil, 6, true, true, "", "true", 4]; ```

4. (OPTIONAL) Place an object in the editor and give it the variable name `Teleport_Object`

# Function Description and Customisation
```
Author: R3vo

  Description:
  Handles the teleport GUI functionality. Needs to run in scheduled environment. Will also show a global message in side channel.
  This can be disabled by:

  missionNamespace setVariable ["TDP_GlobalMessage", false, true]


  Adding custom locations:
  Custom locations can be added by defining the variable TDP_CustomLocations globally in missionNamespace.

  Each custom location is an array in format
  0: STRING - Name displayed in the GUI
  1: ARRAY ([x, y] or [x, y, z]), OBJECT, GROUP, STRING (marker or variable name containing an object), LOCATION
  2: ARRAY - (optional, default [1, 1, 1, 1]) Color in format RGBA. Can be used to highlight the entry in the list

  Example:
  missionNamespace setVariable ["TDP_CustomLocations", [["MHQ", MQH, [1, 0, 0, 1]]], true]

  Parameter(s):
  0: DISPLAY - Teleport GUI
  1: STRING - Mode, either "onLoad" or "teleport"
  2: ARRAY - Color in format RGBA. Can be used to highlight the entry in the list

  Returns:
  -
  ```

