import pyautogui
import keyboard
import time
from datetime import datetime

# Configuration
INPUT_DELAY = 0.050  # 50ms in seconds
MAX_COMPLETIONS = 0
CLOSE_AFTER_MAX = False

# Keybinds
MOVE_FORWARD = "w"
MOVE_BACK = "s"
MOVE_LEFT = "a"
MOVE_RIGHT = "d"
SPRINT = "shift"

MENU_UP = "up"
MENU_DOWN = "down"
MENU_LEFT = "left"
MENU_RIGHT = "right"

INTERACT = "e"
CONFIRM = "e"
CANCEL = "backspace"
START_MENU = "esc"

ITEM_SET = "f"


class Coordinate:
    def __init__(self, x, y):
        self.x = x
        self.y = y


class UICoordinates:
    def __init__(self):
        self.season = Coordinate(50, 20)  
        self.quest_accept = Coordinate(440, 210)  
        self.quest_depart = Coordinate(460, 340)  
        self.health = Coordinate(120, 15)  
        self.ore_deposit = Coordinate(1171, 193)  
        self.reward = Coordinate(833, 146) 


def hex_to_rgb(hex_color):
    """Convert hex color (0xRRGGBB) to RGB tuple"""
    return (
        (hex_color >> 16) & 0xFF,
        (hex_color >> 8) & 0xFF,
        hex_color & 0xFF
    )


def is_season_daytime_box_visible(season_coord):
    pixel = pyautogui.pixel(season_coord.x, season_coord.y)
    return pixel == hex_to_rgb(0x191919)


def is_accepting_quest_dialog_visible(quest_accept_coord):
    pixel = pyautogui.pixel(quest_accept_coord.x, quest_accept_coord.y)
    return pixel == hex_to_rgb(0x1E120F)


def is_quest_depart_box_visible(quest_depart_coord):
    pixel = pyautogui.pixel(quest_depart_coord.x, quest_depart_coord.y)
    target = hex_to_rgb(0x1f1410)
    return all(abs(pixel[i] - target[i]) <= 15 for i in range(3))


def is_health_bar_visible(health_coord):
    pixel = pyautogui.pixel(health_coord.x, health_coord.y)
    return pixel == hex_to_rgb(0x10C010)


def wait_for_lobby(season_coord):
     # Wait for quest to complete
    print("Waiting 60 seconds for quest completion...")
    time.sleep(25)


def handle_startup(season_coord, quest_depart_coord):
    season_visible = is_season_daytime_box_visible(season_coord)
    quest_depart_visible = is_quest_depart_box_visible(quest_depart_coord)

    if not season_visible and not quest_depart_visible:
        print("Couldn't find the game UI. Make sure your UI isn't stretched or discolored and that you're starting at the right place.")
        exit(1)

    if not quest_depart_visible:
        key_press(INTERACT)


def get_to_quest_npc(season_coord):
    key_down(SPRINT)
    key_down(MOVE_BACK)
    time.sleep(1)
    key_down(MOVE_LEFT)
    time.sleep(2.5)
    key_up(MOVE_LEFT)
    key_up(MOVE_BACK)
    key_up(SPRINT)


def accept_quest(season_coord, quest_accept_coord):
    key_press(CONFIRM)
    time.sleep(1)
    key_press(CONFIRM)
    time.sleep(2)
    key_press(CONFIRM)
    time.sleep(10)
    for i in range(11):
        print('the espam')
        key_press(CONFIRM)
        time.sleep(2)
    #key_press(CONFIRM)
    #time.sleep(10)
    key_press(CONFIRM)
    time.sleep(20)



def get_to_departure_dialog():
    key_down(MOVE_FORWARD)
    time.sleep(0.2)
    key_down(SPRINT)
    time.sleep(0.3)
    key_down(MOVE_RIGHT)
    time.sleep(1)
    key_up(MOVE_RIGHT)
    time.sleep(2.5)
    key_press(INTERACT)
    key_up(MOVE_FORWARD)
    key_up(SPRINT)


def depart_on_quest(quest_depart_coord):
    while not is_quest_depart_box_visible(quest_depart_coord):
        time.sleep(0.05)
    key_press(CONFIRM)
    time.sleep(2)


def get_to_red_box(health_coord, ore_deposit_coord):
    # Wait until we're in the quest (health bar visible)
    while not is_health_bar_visible(health_coord):
        time.sleep(0.05)

    # Now that we're in the quest, move to the red box
    key_down(MOVE_BACK)
    key_down(MOVE_RIGHT)

    # Move for a set duration to reach the box
    time.sleep(1.5)  # Adjust this timing as needed

    key_up(MOVE_BACK)
    key_up(MOVE_RIGHT)

    # Give extra time for character to stop
    time.sleep(0.3)

    # Try to interact with the box
    for _ in range(3):
        key_press(INTERACT)
        time.sleep(0.2)


def deposit_iron():
    key_press(CONFIRM)
    key_press(CONFIRM)
    for _ in range(5):
        key_press(MENU_UP)
        key_press(CONFIRM)


def wait_for_rewards(reward_coord):
    # Wait for quest to complete
    print("Waiting 60 seconds for quest completion...")
    time.sleep(60)


def send_rewards_to_box():
    key_press(MENU_UP)
    key_press(MENU_UP)
    key_press(CONFIRM)
    key_press(MENU_LEFT)
    key_press(CONFIRM)
    key_press(CONFIRM)


def cancel_quest_endscreen():
    for _ in range(20):
        key_press(START_MENU)


def resupply_at_chest():
    key_down(SPRINT)
    key_down(MOVE_FORWARD)
    time.sleep(1)
    key_down(MOVE_RIGHT)
    time.sleep(1.5)
    key_up(MOVE_FORWARD)
    key_up(MOVE_RIGHT)
    key_up(SPRINT)

    time.sleep(4)
    key_press(INTERACT)
    key_press(ITEM_SET)
    key_press(CANCEL)
    """"
    time.sleep(5)
    key_press(INTERACT)
    time.sleep(2)
    key_press(ITEM_SET)
    key_press(CANCEL)
    """
    print('stop')


def get_to_departure_dialog_from_box():
    print('testerasidj;')
    time.sleep(10)
    key_down(SPRINT)
    key_down(MOVE_FORWARD)
    key_down(MOVE_LEFT)
    time.sleep(1)
    key_up(MOVE_LEFT)
    time.sleep(1.5)
    key_press(INTERACT)
    key_up(MOVE_FORWARD)
    key_up(SPRINT)


def key_press(key):
    key_down(key)
    time.sleep(INPUT_DELAY)
    key_up(key)
    time.sleep(INPUT_DELAY)


def key_press_double(key1, key2):
    key_down(key1)
    key_down(key2)
    time.sleep(INPUT_DELAY)
    key_up(key1)
    key_up(key2)
    time.sleep(INPUT_DELAY)


def key_down(key):
    pyautogui.keyDown(key)


def key_up(key):
    pyautogui.keyUp(key)


class IronRunner:
    def __init__(self):
        self.toggle = False
        self.coordinates = None
        self.iron_left = 99
        self.loops_completed = 0
        self.running = False

    def startup(self):
        handle_startup(self.coordinates.season, self.coordinates.quest_depart)
        depart_on_quest(self.coordinates.quest_depart)
        get_to_red_box(self.coordinates.health, self.coordinates.ore_deposit)
        deposit_iron()
        wait_for_rewards(self.coordinates.reward)
        send_rewards_to_box()
        cancel_quest_endscreen()
        self.iron_left -= 3
        self.loops_completed += 1

    def runner(self):
        wait_for_lobby(self.coordinates.season)

        get_to_quest_npc(self.coordinates.season)
        accept_quest(self.coordinates.season, self.coordinates.quest_accept)

        print('In Main')

        resupply_at_chest()
        get_to_departure_dialog_from_box()

        depart_on_quest(self.coordinates.quest_depart)
        get_to_red_box(self.coordinates.health, self.coordinates.ore_deposit)
        deposit_iron()
        wait_for_rewards(self.coordinates.reward)
        send_rewards_to_box()
        cancel_quest_endscreen()
        self.iron_left -= 3
        self.loops_completed += 1

    def toggle_bot(self):
        self.toggle = not self.toggle

        if self.toggle:
            print("Bot started! Press F12 to stop.")
            self.coordinates = UICoordinates()
            self.iron_left = 99
            self.loops_completed = 0
            self.running = True

            self.startup()

            while self.running and self.toggle:
                self.runner()
        else:
            print("Bot stopped!")
            self.running = False


def main():
    print("IronRunner v1.2.4 (Python) - Steam Deck Edition")
    print("Optimized for 1280x800 resolution")
    print("Press F12 to start/stop the bot")
    print("Press F11 to exit")
    print("Make sure the game window is active and focused!")

    pyautogui.FAILSAFE = False

    runner = IronRunner()

    keyboard.add_hotkey('f12', runner.toggle_bot)
    keyboard.add_hotkey('f11', lambda: exit(0))

    # Keep the script running
    keyboard.wait()


if __name__ == "__main__":
    main()
