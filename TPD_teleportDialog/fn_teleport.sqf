/*
  Author: R3vo

  Description:
  Handles the teleport GUI functionality. Needs to run in scheduled environment.

  Parameter(s):
  0: DISPLAY - Teleport GUI
  1: STRING - Mode, either "onLoad" or "teleport"

  Returns:
  -
*/

#define LB (_display displayCtrl 10)

disableSerialization;
params ["_display", "_mode"];

//Param can be display or control
if (_display isEqualType controlNull) then {_display = ctrlParent _display};
private _ctrlLB = LB;

switch (_mode) do
{
  case "onLoad":
  {
    while {!isNull _display} do
    {
      lbClear _ctrlLB;
      ((units side player) select {alive _x && _x != player && isPlayer _x}) apply
      {
        private _index = _ctrlLB lbAdd name _x;
        _ctrlLB lbSetData [_index, str position _x];
        _ctrlLB lbSetTextRight [_index, format ["(%2 m) - Grid: %1", mapGridPosition _x, round (player distance _x)]];
      };
      sleep 1;
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
    [[side player, "HQ"], format ["%1 arrived in the AO.", name player]] remoteExec ["sideChat"];
  };
};
