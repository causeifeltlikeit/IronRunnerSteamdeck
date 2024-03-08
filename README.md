# IronRunner
Requires [AutoHotkey v2.0](https://www.autohotkey.com/)

The script works by detecting certain UI elements whose position changes based on resolution. Supported game resolutions: 2560x1440, 1920x1080, 1280x720, 640x480

Press F11 to restart the script and stop anything it's doing.

## Setup
If you've changed the ingame keybinds, edit the script and change the keybinds near the top.

In `Options > Input Options` set `Other Player Status` to `TYPE 2`. This makes it so the interact key won't interact with other players.

Either make the iron delivery quest a first slot favorite quest, or do it once so it's in your quest history.

Take a full stack of iron into your inventory and set your first item set to have 99 iron. The script will use this item set to restock. You can make this any of your first 4 item sets by changing the `item_set` keybind in the script to correspond to the correct set.

Face the camera at the quest departure area. Aim for the same camera angle you return from quests at, but it's not strict.

Talk to the general quest giver and highlight the iron delivery quest in your favorites or quest history.

F12 with the game focused to start. F12 again to stop after the current loop. F11 to stop immediately.

## Troubleshooting
If you run MHF as admin, edit the script and change the line `run_as_admin := false` to `run_as_admin := true`, or run the script as admin yourself.

If you notice the script not menu correctly (turning in the iron or accepting rewards), edit the script and change `input_delay` at the top to a higher number. Try 100 first, then increase if you still encounter problems.

If you forcibly stop the script, some keys (movement keys and sprint mostly) may still be held down. Pressing any stuck down key yourself will fix it.

The script can't recover from connection errors when accepting the quest or departing. F11 to restart the script, then do setup again.
