//GUI and script related macros
#include "\a3\3DEN\UI\macros.inc"

#define CTRL_DEFAULT_H (SIZE_M * GRID_H)
#define DIALOG_W 80
#define DIALOG_Y (safezoneY + 2 * CTRL_DEFAULT_H)

class TPD_Teleport
{
  idd = -1;
  movingenable = 0;
  onLoad = "uiNamespace setVariable ['TPD_Display', _this select 0];['onLoad', nil, _this select 0] spawn TPD_fnc_teleport";
  class ControlsBackground
  {
   class Headline: ctrlStaticTitle
    {
      text = "$STR_DN_LOCATIONS";
      x = 0.5 - DIALOG_W / 2 * GRID_W;
      y = DIALOG_Y;
      w = DIALOG_W * GRID_W;
      h = CTRL_DEFAULT_H;
    };
    class Background: ctrlStaticBackground
    {
      x = 0.5 - DIALOG_W / 2 * GRID_W;
      y = DIALOG_Y + CTRL_DEFAULT_H;
      w = DIALOG_W * GRID_W;
      h = 67 * GRID_H;
    };
   };
   class Controls
   {
    class Locations: ctrlListBox
    {
      idc = 10;
      x = 0.5 - DIALOG_W / 2 * GRID_W + GRID_W;
      y = DIALOG_Y + CTRL_DEFAULT_H + GRID_H;
      w = DIALOG_W * GRID_W - 2 * GRID_W;
      h = 59 * GRID_H;
    };
    class Teleport: ctrlButton
    {
      text = "$STR_STATE_MOVE";
      x = 0.5 - DIALOG_W / 2 * GRID_W + GRID_W;
      y = DIALOG_Y + 66 * GRID_H;
      w = DIALOG_W / 3 * GRID_W - 2 * GRID_W;
      h = CTRL_DEFAULT_H;
      onButtonClick = "['teleport', nil, _this select 0] spawn TPD_fnc_teleport";
    };
    class Preview: Teleport
    {
      text = "$STR_EDITOR_MENU_FILE_PREVIEW";
      x = 0.5 + DIALOG_W / 3 * GRID_W - DIALOG_W / 2 * GRID_W + GRID_W;
      onButtonClick = "['previewPosition', nil, _this select 0] call TPD_fnc_teleport";
    };
    class Close: Teleport
    {
      idc= 1;
      text = "$STR_DISP_OPT_CLOSE";
      x = 0.5 + DIALOG_W / 2 * GRID_W - DIALOG_W / 3 * GRID_W + GRID_W;
      onButtonClick = "";
    };
  };
};