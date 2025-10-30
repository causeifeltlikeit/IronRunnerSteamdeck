# IronRunner - Steam Deck Setup

## Setup

Disable read-only mode and install dependencies:

```bash
sudo steamos-readonly disable
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --populate holo
sudo pacman -S gnome-screenshot
sudo steamos-readonly enable
```

Set up conda environment:

```bash
conda create -n ironrunner python=3.11
conda activate ironrunner
pip install pyautogui
pip install keyboard
```

## Usage

Navigate to the directory and run:

```bash
python ironrunner.py
```

Open the game (or Alt+Tab back to it) and press **F12** to start.



