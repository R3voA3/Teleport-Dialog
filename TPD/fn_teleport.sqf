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

  Returns:
  -

  Examples:
  ["setCustomLocations", [["MHQ", MHQ, [1, 0, 0, 1]]]] call TPD_fnc_teleport; // Set custom locations

  ["enableGlobalMessage", false] call TPD_fnc_teleport; // Disable global message

  ["addActions", [TPD_1, MHQ]] call TPD_fnc_teleport; // Add actions to given objects for all players

  [
    "setCustomLocations",
    [
      ["MHQ No. 0", "MHQ_0", [random 1, random 1, random 1, 1]],
      ["MHQ No. 1", "MHQ_1", [random 1, random 1, random 1, 1]],
      ["MHQ No. 2", "MHQ_2", [random 1, random 1, random 1, 1]],
      ["MHQ No. 3", "MHQ_3", [random 1, random 1, random 1, 1]]
    ]
  ] call TPD_fnc_teleport; //Add 4 custom locations in form of markers.
*/

#include "\a3\3DEN\UI\macros.inc"
#define CTRL_H (SIZE_M * GRID_H)
#define DIALOG_W 80
#define DIALOG_TOP (safezoneY + 2 * CTRL_H)
#define LB (_display displayCtrl 10)

disableSerialization;
params ["_mode", ["_parameters", []]];

switch (_mode) do
{
  case "createGUI":
  {
    disableSerialization;

    private _display = (call BIS_fnc_displayMission) createDisplay "DisplaySimulated";
    uiNamespace setVariable ["TPD_Display", _display];

    private _ctrlHeader = _display ctrlCreate ["ctrlStaticTitle", -1];
    _ctrlHeader ctrlSetText localize "STR_DN_LOCATIONS";
    _ctrlHeader ctrlSetPosition [0.5 - DIALOG_W / 2 * GRID_W, DIALOG_TOP, DIALOG_W * GRID_W, CTRL_H];

    private _ctrlBackground = _display ctrlCreate ["ctrlStaticBackground", -1];
    _ctrlBackground ctrlSetPosition [0.5 - DIALOG_W / 2 * GRID_W, DIALOG_TOP + CTRL_H, DIALOG_W * GRID_W, 51 * GRID_H];

    private _ctrlList = _display ctrlCreate ["ctrlListbox", 10];
    _ctrlList ctrlSetPosition [0.5 - DIALOG_W / 2 * GRID_W + GRID_W, DIALOG_TOP + CTRL_H + GRID_H, DIALOG_W * GRID_W - 2 * GRID_W, 42 * GRID_H];

    _ctrlList ctrlAddEventHandler ["LBSelChanged",
    {
      ["previewPosition"] spawn TPD_fnc_teleport;
    }];

    private _ctrlButtonBackground = _display ctrlCreate ["ctrlStaticFooter", -1];
    _ctrlButtonBackground ctrlSetPosition [0.5 - DIALOG_W / 2 * GRID_W, DIALOG_TOP + 49 * GRID_H, DIALOG_W * GRID_W, CTRL_H + 2 * GRID_H];

    private _ctrlTeleport = _display ctrlCreate ["ctrlButton", -1];
    _ctrlTeleport ctrlSetPosition [0.5 - DIALOG_W / 2 * GRID_W + GRID_W, DIALOG_TOP + 50 * GRID_H, DIALOG_W / 3 * GRID_W - 2 * GRID_W, CTRL_H];
    _ctrlTeleport ctrlSetText localize "STR_STATE_MOVE";

    _ctrlTeleport ctrlAddEventHandler ["ButtonClick",
    {
      ["teleport"] spawn TPD_fnc_teleport;
    }];

    private _ctrlClose = _display ctrlCreate ["ctrlButtonClose", 1];
    _ctrlClose ctrlSetPosition [0.5 + DIALOG_W / 2 * GRID_W - DIALOG_W / 3 * GRID_W + GRID_W, DIALOG_TOP + 50 * GRID_H, DIALOG_W / 3 * GRID_W - 2 * GRID_W, CTRL_H];

    private _ctrlMapBackground = _display ctrlCreate ["ctrlStaticBackground", -1];
    _ctrlMapBackground ctrlSetPosition [0.5 - DIALOG_W / 2 * GRID_W, DIALOG_TOP + 57 * GRID_H, DIALOG_W * GRID_W, 62 * GRID_H];

    private _ctrlMap = _display ctrlCreate ["RscMapControl", 20]; //Need to use Rsc... here instead of ctrl... because of contourInterval
    _ctrlMap ctrlMapSetPosition [0.5 - DIALOG_W / 2 * GRID_W + GRID_W, DIALOG_TOP + 58 * GRID_H, DIALOG_W * GRID_W - 2 * GRID_W, 60 * GRID_H];

    [_ctrlHeader, _ctrlBackground, _ctrlList, _ctrlTeleport, _ctrlClose, _ctrlButtonBackground, _ctrlMapBackground] apply {_x ctrlCommit 0};

    ["fillGUI"] spawn TPD_fnc_teleport;
  };
  case "fillGUI":
  {
    private _display = uiNamespace getVariable ["TPD_Display", displayNull];
    private _ctrlLB = LB;
    private _customLocs = missionNamespace getVariable ["TDP_CustomLocations", []];
    while {!isNull _display} do
    {
      lbClear _ctrlLB;
      ((units side player) select {alive _x && _x != player  && isPlayer  _x && vehicle _x == _x}) apply
      {
        private _index = _ctrlLB lbAdd name _x;
        _ctrlLB lbSetData [_index, str position _x];
        _ctrlLB lbSetTextRight [_index, format ["%2 m - Grid: %1", mapGridPosition _x, round (player distance _x)]];
      };
      _customLocs apply
      {
        _x params
        [
          ["_name", "", [""]],
          ["_pos", [0, 0, 0], [objNull, grpNull, locationNull, [], ""]],
          ["_color", [1, 1, 1, 1], [[]], 4]
        ];
        _pos = _pos call BIS_fnc_position;
        private _index = _ctrlLB lbAdd _name;
        _ctrlLB lbSetData [_index, str _pos];
        _ctrlLB lbSetTextRight [_index, format ["%2 m - Grid: %1", mapGridPosition _pos, round (player distance _pos)]];
        _ctrlLB lbSetColor [_index, _color];
      };
      sleep 2;
    };
  };
  case "teleport":
  {
    private _display = uiNamespace getVariable ["TPD_Display", displayNull];
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
      [format ["%1 arrived in the AO.", name player]] remoteExec ["systemChat", playerSide];
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
      [_x, ["<img image='\a3\modules_f_curator\data\portraitobjectivemove_ca.paa'/> Select Teleport Location", {["createGUI"] call TPD_fnc_teleport;}, nil, 6, true, true, "", "true", 4]] remoteExec ["addAction", 0, _x];
    };
  };
  case "previewPosition":
  {
    private _display = uiNamespace getVariable ["TPD_Display", displayNull];
    private _newPos = LB lbData (lbCurSel LB);
    private _ctrlMap = _display displayCtrl 20;

    //Exit if nothing was selected or position could not be retrieved
    if (_newPos == "") exitWith {};
    _newPos = parseSimpleArray _newPos;

    _ctrlMap ctrlMapAnimAdd [0.3, ctrlMapScale _ctrlMap, _newPos];
    ctrlMapAnimCommit _ctrlMap;
  };
};
