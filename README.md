# TeleportDialog
A simple teleport dialog.


# How to use

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

```Teleport_Object addAction ["Select Teleport Location", {findDisplay 46 createDisplay "TPD_Teleport"}];```

4. (OPTIONAL) Place an object in the editor and give it the variable name `Teleport_Object`

