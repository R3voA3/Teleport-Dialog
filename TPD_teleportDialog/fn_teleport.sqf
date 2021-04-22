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

    "addActions" - Will add actions to given objects globally

  2: ARRAY - Color in format RGBA. Can be used to highlight the entry in the list
  3: ARRAY, BOOLEAN - Parameters according to mode

  Returns:
  -

  Examples:
  ["setCustomLocations", [["MHQ", MQH, [1, 0, 0, 1]]], true] call TPD_fnc_teleport; // Set custom locations

  ["enableGlobalMessage", false, true] call TPD_fnc_teleport; // Disable global message

  ["addActions", [TPD_1, MHQ]] call TPD_fnc_teleport; // Add actions to given objects for all players
*/

#define LB (_display displayCtrl 10)

disableSerialization;
params ["_mode", "_parameters", "_display"];

switch (_mode) do
{
  case "onLoad":
  {
    //Param can be display or control
    if (_display isEqualType controlNull) then {_display = ctrlParent _display};
    private _ctrlLB = LB;
    private _customLocs = missionNamespace getVariable ["TDP_CustomLocations", []];
    while {!isNull _display} do
    {
      lbClear _ctrlLB;
      ((units side player) select {alive _x && _x != player && isPlayer _x}) apply
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
    //Param can be display or control
    if (_display isEqualType controlNull) then {_display = ctrlParent _display};
    private _ctrlLB = LB;
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
    if !(_parameters isEqualType true) exitWith {diag_log "TPD: Global message state could not be set. Only pass BOOLEAN to the function!"};
    missionNamespace setVariable ["TDP_EnableGlobalMessage", _parameters, true];
  };
  case "setCustomLocations":
  {
    missionNamespace setVariable ["TDP_CustomLocations", _parameters, true];
  };
  case "addActions":
  {
    if !(_parameters isEqualTypeAll objNull) exitWith {diag_log "TPD: Actions could not be added. Only pass objects to the function!"};
    _parameters apply
    {
      [_x, ["<img image='\a3\modules_f_curator\data\portraitobjectivemove_ca.paa'/> Select Teleport Location", {findDisplay 46 createDisplay "TPD_Teleport"}, nil, 6, true, true, "", "true", 4]]
      remoteExec ["addAction", 0, true];
    };
  };
};
