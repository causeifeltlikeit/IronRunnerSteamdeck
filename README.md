# IronRunner
Requires [AutoHotkey v2.0](https://www.autohotkey.com/)

The script works by detecting certain UI elements whose position changes based on resolution. Supported game resolutions: 2560x1440, 1920x1080, 1280x720, 640x480

Your game window size must match the chosen resolution. In fullscreen your native resolution must be the same as the game resolution. In windowed make sure the window isn't being scaled by Windows or something else. Right click your desktop, choose display settings, then under Scale and layout check that the size of text, apps and other items is 100%.
Your game's colors must not be altered e.g. by reshade or other color filters.

## Setup
If you've changed the ingame keybinds, edit the script and change the keybinds near the top.

In `Options > Input Options` set `Other Player Status` to `TYPE 2`. This makes it so the interact key won't interact with other players.

Either make the iron delivery quest a first slot favorite quest, or do it once so it's in your quest history.

Take a full stack of iron into your inventory and set your first item set to have 99 iron. The script will use this item set to restock. You can make this any of your first 4 item sets by changing the `item_set` keybind in the script to correspond to the correct set.

## Running the script
Accept the quest from your favorites or quest history, then go to the quest departure area. The depart on quest prompt should be on your screen.

Press F12 to start the script. F12 again to stop after the current loop. F11 to stop immediately and restart the script.

Note that F12 can't be used to stop during the first quest completion.

## Troubleshooting
If you run MHF as admin, edit the script and change the line `run_as_admin := false` to `run_as_admin := true`, or run the script as admin yourself.

If you notice the script not menu correctly (turning in the iron or accepting rewards), edit the script and change `input_delay` at the top to a higher number. Try 100 first, then increase if you still encounter problems.

If you forcibly stop the script, some keys (movement keys and sprint mostly) may still be held down. Pressing any stuck down key yourself will fix it.
