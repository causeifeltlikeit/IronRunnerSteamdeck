; v1.0.2
#Requires AutoHotkey v2
#SingleInstance

run_as_admin := false
input_delay := 50

; Keybinds
; For valid key names, see https://www.autohotkey.com/docs/v2/KeyList.htm
move_forward := "W"
move_back := "S"
move_left := "A"
move_right := "D"
sprint := "Shift"

menu_up := "Up"
menu_down := "Down"
menu_left := "Left"
menu_right := "Right"

confirm := "E"
cancel := "Backspace"
start_menu := "Escape"

item_set := "F"

;=================================================================================================

if (!A_IsAdmin && run_as_admin) {
    Run('*RunAs "' A_ScriptFullPath '" /restart')
}

*F11:: {
    Reload
}

class Coordinate {
    __New(x, y) {
        this.x := x
        this.y := y
    }
}

class UICoordinates {
    __New(client_width, client_height) {
        valid_resolutions := [[2560, 1440], [1920, 1080], [1280, 720], [640, 480]]
        resolution_idx := 0
        for i, v in valid_resolutions {
            if (client_width == v[1] && client_height == v[2]) {
                resolution_idx := i
            }
        }
        if (resolution_idx == 0) {
            MsgBox("Unsupported game resolution. Please run the game at 2560x1440, 1920x1080, 1280x720 or 640x480.")
            Exit
        }
        this.season := Coordinate(210, 20)
        this.quest_accept := [Coordinate(1250, 690), Coordinate(950, 510), Coordinate(630, 329), Coordinate(310, 210)][resolution_idx]
        this.quest_depart := [Coordinate(1100, 666), Coordinate(910, 487), Coordinate(610, 306), Coordinate(280, 186)][resolution_idx]
        this.health := Coordinate(120, 17)
        this.ore_deposit := [Coordinate(2534, 174), Coordinate(1893, 174), Coordinate(1254, 174), Coordinate(614, 174)][resolution_idx]
        this.reward := [Coordinate(2172, 131), Coordinate(1531, 131), Coordinate(892, 131), Coordinate(252, 131)][resolution_idx]
    }
}

is_season_daytime_box_visible(season_coord) {
    return PixelGetColor(season_coord.x, season_coord.y) == 0x191919
}

is_accepting_quest_dialog_visible(quest_accept_coord) {
    return PixelGetColor(quest_accept_coord.x, quest_accept_coord.y) == 0x1E120F
}

is_quest_depart_box_visible(quest_depart_coord) {
    return PixelGetColor(quest_depart_coord.x, quest_depart_coord.y) == 0x1f1410
}

is_health_bar_visible(health_coord) {
    return PixelGetColor(health_coord.x, health_coord.y) == 0x10C010
}

wait_for_lobby(season_coord) {
    while !is_season_daytime_box_visible(season_coord) {
        Sleep(50)
    }
}

get_to_quest_npc(season_coord) {
    key_down(sprint)
    key_down(move_back)
    wait_for_lobby(season_coord)
    Sleep(1000)
    key_down(move_left)
    while is_season_daytime_box_visible(season_coord) {
        key_press(confirm)
        Sleep(50)
    }
    key_up(move_left)
    key_up(move_back)
    key_up(sprint)
}

accept_quest(season_coord, quest_accept_coord) {
    while !is_accepting_quest_dialog_visible(quest_accept_coord) {
        key_press(confirm)
    }
    while is_accepting_quest_dialog_visible(quest_accept_coord) {
        Sleep(50)
    }
    key_down(sprint)
    key_down(move_forward)
    key_down(move_right)
    while !is_season_daytime_box_visible(season_coord) {
        key_press(cancel)
    }
}

depart_on_quest(quest_depart_coord) {
    Sleep(1500)
    key_up(move_right)
    Sleep(1500)
    Loop 5 {
        key_press(confirm)
        Sleep(100)
    }
    key_up(move_forward)
    key_up(sprint)
    while !is_quest_depart_box_visible(quest_depart_coord) {
        Sleep(50)
    }
    key_press(confirm)
    Sleep(2000)
}

get_to_red_box(health_coord, ore_deposit_coord) {
    key_down(move_back)
    key_down(move_right)
    while !is_health_bar_visible(health_coord) {
        Sleep(50)
    }
    while (!PixelSearch(&_, &_, ore_deposit_coord.x, ore_deposit_coord.y, ore_deposit_coord.x, ore_deposit_coord.y, 0x7D6851, 5)) {
        key_press(confirm)
    }
    key_up(move_back)
    key_up(move_right)
}

deposit_iron() {
    key_press(confirm)
    key_press(confirm)
    Loop 5 {
        key_press(menu_up)
        key_press(confirm)
    }
}

wait_for_rewards(reward_coord) {
    while (!PixelSearch(&_, &_, reward_coord.x, reward_coord.y, reward_coord.x, reward_coord.y, 0x78624A, 5)) {
        Sleep(100)
    }
}

send_rewards_to_box() {
    key_press(menu_up)
    key_press(menu_up)
    key_press(confirm)
    key_press(menu_left)
    key_press(confirm)
    key_press(confirm)
}

cancel_quest_endscreen() {
    Loop 20 {
        key_press(start_menu)
    }
}

resupply_at_chest() {
    Sleep(2300)
    key_up(move_right)
    Sleep(500)
    key_up(move_forward)
    key_up(sprint)
    Sleep(1500)
    key_press(confirm)
    Sleep(500)
    key_press(item_set)
    key_press(cancel)
}

depart_on_quest_from_box(quest_depart_coord) {
    key_down(sprint)
    key_down(move_forward)
    key_down(move_left)
    Sleep(1000)
    key_up(move_left)
    Sleep(500)
    Loop 5 {
        key_press(confirm)
        Sleep(100)
    }
    key_up(move_forward)
    key_up(sprint)
    while !is_quest_depart_box_visible(quest_depart_coord) {
        Sleep(50)
    }
    key_press(confirm)
    Sleep(2000)
}

key_press(key) {
    key_down(key)
    Sleep(50)
    key_up(key)
    Sleep(input_delay)
}

key_down(key) {
    Send("{" . key . " down}")
}

key_up(key) {
    Send("{" . key . " up}")
}

#HotIf WinActive("ahk_exe mhf.exe")

*F12:: {
    static toggle := false
    toggle := !toggle
    if toggle {
        WinGetClientPos(&_, &_, &width, &height, "ahk_exe mhf.exe")
        static coordinates
        coordinates := UICoordinates(width, height)
        static iron_left
        iron_left := 99
        SetTimer(runner, 1)
    } else {
        SetTimer(runner, 0)
    }
    runner() {
        accept_quest(coordinates.season, coordinates.quest_accept)
        if (iron_left < 3) {
            resupply_at_chest()
            iron_left := 99
            depart_on_quest_from_box(coordinates.quest_depart)
        } else {
            depart_on_quest(coordinates.quest_depart)
        }
        get_to_red_box(coordinates.health, coordinates.ore_deposit)
        deposit_iron()
        wait_for_rewards(coordinates.reward)
        send_rewards_to_box()
        cancel_quest_endscreen()
        iron_left -= 3
        wait_for_lobby(coordinates.season)
        get_to_quest_npc(coordinates.season)
    }
}
