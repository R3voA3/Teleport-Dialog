16.04.2023
- Fixed mission function call in addAction

07.10.2021
- UI is now fully scripted to make implementation into missions easier
- CfgFunctions is now a separate files for easier implementation into mission
- Several tweaks to the function and GUI
- Preview button was removed. Position is now previewed when listbox selection is changed
- Global message will only be shown to players of the same side
- Global message changed from sideChat to systemChat
- Teleporting is only possible to units of same side. (Negative rating added to the check)
- Teleport action will now no longer be added if the object does not exist

19.04.2021
- Merged both functions into one
- Updated the GUI to new pixelGrid system
- Positions are now updated every second automatically
- Added MP Message (Optional)
- Improved the code quality
- Improved message after player got teleported
- List now also displays the distance
- Added the ability to create custom locations
- Easier setup of teleport actions via function
- Teleportation to players which are in a vehicle is not possible anymore
- Ability to preview position before teleporting
