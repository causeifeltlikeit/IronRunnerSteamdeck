# IronRunner - Steam Deck Setup

## Setup

Set up conda environment (If you have conda installed otherwise just install with pip normally):

```bash
conda create -n ironrunner python=3.11
conda activate ironrunner
pip install pyautogui
pip install keyboard
```
Disable read-only mode and install dependencies:

```bash
sudo steamos-readonly disable
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --populate holo
sudo pacman -S gnome-screenshot
sudo steamos-readonly enable
```

## Usage

Navigate to the directory and run:

```bash
python ironrunner.py
```

Open the game (or Alt+Tab back to it) and press **F12** to start.



