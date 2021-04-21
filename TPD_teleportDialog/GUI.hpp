//GUI and script related macros
#include "\a3\3DEN\UI\macros.inc"

#define CTRL_DEFAULT_H (SIZE_M * GRID_H)
#define DIALOG_W 80

class TPD_Teleport
{
  idd = -1;
  movingenable = 0;
  onLoad = "[_this select 0, 'onLoad'] spawn TPD_fnc_teleport";
  class ControlsBackground
  {
    class Background: ctrlStaticBackground
    {
      x = 0.5 - DIALOG_W / 2 * GRID_W;
      y = CTRL_DEFAULT_H;
      w = DIALOG_W * GRID_W;
      h = 67 * GRID_H;
    };
    class Headline: ctrlStaticTitle
    {
      text = "$STR_DN_LOCATIONS";
      x = 0.5 - DIALOG_W / 2 * GRID_W;
      w = DIALOG_W * GRID_W;
      h = CTRL_DEFAULT_H;
    };
   };
   class Controls
   {
    class Locations: ctrlListBox
    {
      idc = 10;
      x = 0.5 - DIALOG_W / 2 * GRID_W + GRID_W;
      y = CTRL_DEFAULT_H + GRID_H;
      w = DIALOG_W * GRID_W - 2 * GRID_W;
      h = 59 * GRID_H;
    };
    class Teleport: ctrlButton
    {
      text = "$STR_STATE_MOVE";
      x = 0.5 - DIALOG_W / 2 * GRID_W + GRID_W;
      y = 66 * GRID_H;
      w = DIALOG_W / 2 * GRID_W - 2 * GRID_W;
      h = CTRL_DEFAULT_H;
      onButtonClick = "[_this select 0, 'teleport'] spawn TPD_fnc_teleport";
    };
    class Close: Teleport
    {
      idc = 1;
      text = "$STR_DISP_OPT_CLOSE";
      x = 0.5 + DIALOG_W / 2 * GRID_W - DIALOG_W / 2 * GRID_W + GRID_W;
      onButtonClick = "";
    };
  };
};
