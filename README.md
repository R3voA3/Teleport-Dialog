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
/*
  Author: R3vo

  Description:
  Handles the teleport GUI functionality. Needs to run in scheduled environment. Will also show a global message in side channel.

  Parameter(s):
  0: DISPLAY - Teleport GUI
  1: STRING - Mode, can be:
    "onLoad" (Internal use)
    "teleport" (Internal use)
    "disableGlobalMessage" - Disable or enable global message
    "setCustomLocations" - Set the custom locations.

      Each custom location is an array in format
      0: STRING - Name displayed in the GUI
      1: ARRAY ([x, y] or [x, y, z]), OBJECT, GROUP, STRING (marker or variable name containing an object), LOCATION
      2: ARRAY - (optional, default [1, 1, 1, 1]) Color in format RGBA. Can be used to highlight the entry in the list

      Example:
      ["TDP_CustomLocations", [["MHQ", MQH, [1, 0, 0, 1]]], true] call

  2: ARRAY - Color in format RGBA. Can be used to highlight the entry in the list
  3: ARRAY, BOOLEAN - Parameters according to mode

  Returns:
  -

  Examples:
  ["setCustomLocations", [["MHQ", MQH, [1, 0, 0, 1]]], true] call TPD_fnc_teleport; // Set custom locations

  ["enableGlobalMessage", false, true] call TPD_fnc_teleport; // Disable global message
*/

#define LB (_display displayCtrl 10)

disableSerialization;
params ["_display", "_mode", "_parameters"];

//Param can be display or control
if (_display isEqualType controlNull) then {_display = ctrlParent _display};
private _ctrlLB = LB;
switch (_mode) do
{
  case "onLoad":
  {
    private _customLocs = missionNamespace getVariable ["TDP_CustomLocations", []];
    while {!isNull _display} do
    {
      lbClear _ctrlLB;
      ((units side player) select {alive _x && _x != player && !isPlayer _x}) apply
      {
        private _index = _ctrlLB lbAdd name _x;
        _ctrlLB lbSetData [_index, str position _x];
        _ctrlLB lbSetTextRight [_index, format ["(%2 m) - Grid: %1", mapGridPosition _x, round (player distance _x)]];
      };
      _customLocs apply
      {
        _x params ["_name", "_pos", ["_color", [1, 1, 1, 1], [[]], 4]];
        _pos = _pos call BIS_fnc_position;
        private _index = _ctrlLB lbAdd _name;
        _ctrlLB lbSetData [_index, str _pos];
        _ctrlLB lbSetTextRight [_index, format ["(%2 m) - Grid: %1", mapGridPosition _pos, round (player distance _pos)]];
        _ctrlLB lbSetColor [_index, _color];
      };
      sleep 2;
    };
  };
  case "teleport":
  {
    private _newPos = LB lbData (lbCurSel LB);

    //Exit if nothing was selected or position could not be retrieved
    if (_newPos == "") exitWith {};
    _newPos = parseSimpleArray _newPos;

    //Fade out
    _display closeDisplay 0;
    2 fadeSound 0;
    cutText ["", "BLACK OUT", 2];
    sleep 2;

    //Fade in
    cutText ["", "BLACK IN", 2];
    player setPos (_newPos getPos [5, random 360]);
    [["You arrived at the designated location."], [format ["Grid: %1", mapGridPosition player]]] spawn BIS_fnc_EXP_camp_SITREP;
    2 fadeSound 1;

    //MP Message
    if (missionNamespace getVariable ["TDP_EnableGlobalMessage", true]) then
    {
      [[side player, "HQ"], format ["%1 arrived in the AO.", name player]] remoteExec ["sideChat"];
    };
  };
  case "enableGlobalMessage":
  {
    missionNamespace setVariable ["TDP_EnableGlobalMessage", _parameters, true];
  };
  case "setCustomLocations":
  {
    missionNamespace setVariable ["TDP_CustomLocations", _parameters, true];
  };
};
