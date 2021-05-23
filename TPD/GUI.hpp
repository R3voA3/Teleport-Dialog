//GUI and script related macros
#include "\a3\3DEN\UI\macros.inc"

#define CTRL_DEFAULT_H (SIZE_M * GRID_H)
#define DIALOG_W 80
#define DIALOG_Y (safezoneY + 2 * CTRL_DEFAULT_H)

class TPD
{
  idd = -1;
  movingenable = 0;
  onLoad = "uiNamespace setVariable ['TPD_Display', _this select 0]; ['fillGUI'] spawn TPD_fnc_teleport";
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
      h = 8 * CTRL_DEFAULT_H - GRID_H;
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
      h = 6 * CTRL_DEFAULT_H;
      onLBSelChanged = "['previewPosition'] call TPD_fnc_teleport";
    };
    class BackgroundButtons: ctrlStaticFooter
    {
      x = 0.5 - DIALOG_W / 2 * GRID_W;
      y = DIALOG_Y + 7 * CTRL_DEFAULT_H + 2 * GRID_H;
      w = DIALOG_W * GRID_W;
      h = CTRL_DEFAULT_H + 2 * GRID_H;
    };
    class Teleport: ctrlButton
    {
      text = "$STR_STATE_MOVE";
      x = 0.5 - DIALOG_W / 2 * GRID_W + GRID_W;
      y = DIALOG_Y + 7 * CTRL_DEFAULT_H + 3 * GRID_H;
      w = DIALOG_W / 3 * GRID_W - 2 * GRID_W;
      h = CTRL_DEFAULT_H;
      onButtonClick = "['teleport'] spawn TPD_fnc_teleport";
    };
    class Close: Teleport
    {
      idc= 1;
      text = "$STR_DISP_OPT_CLOSE";
      x = 0.5 + DIALOG_W / 2 * GRID_W - DIALOG_W / 3 * GRID_W + GRID_W;
      onButtonClick = "";
    };
    class BackgroundMap: ctrlStaticBackground
    {
      text = "$STR_DISP_OPT_CLOSE";
      x = 0.5 - DIALOG_W / 2 * GRID_W;
      y = DIALOG_TOP + 8 * CTRL_DEFAULT_H - 2 * GRID_H;
      w = DIALOG_W * GRID_W;
      h = 8 * CTRL_DEFAULT_H + 2 * GRID_H;
    };
    class Map: ctrlMap
    {
      idc= 20;
      x = 0.5 - DIALOG_W / 2 * GRID_W + GRID_W;
      y = DIALOG_TOP + 8 * CTRL_DEFAULT_H - GRID_H;
      w = DIALOG_W * GRID_W - 2 * GRID_W;
      h = 8 * CTRL_DEFAULT_H;
      showCountourInterval = 0;
    };
  };
};