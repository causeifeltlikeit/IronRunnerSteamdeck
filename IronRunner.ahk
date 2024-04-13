; v1.2.0
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

interact := "E"
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
        key_press_double(interact, confirm)
    }
    key_up(move_left)
    key_up(move_back)
    key_up(sprint)
}

accept_quest(season_coord, quest_accept_coord) {
    while !is_accepting_quest_dialog_visible(quest_accept_coord) {
        key_press_double(confirm, interact)
    }
    while is_accepting_quest_dialog_visible(quest_accept_coord) {
        Sleep(50)
    }
    connection_error_check := A_Now
    while !is_season_daytime_box_visible(season_coord) {
        if (DateDiff(A_Now, connection_error_check, "Seconds") > 30) {
            accept_quest(season_coord, quest_accept_coord)
            break
        }
        key_press(cancel)
    }
}

get_to_departure_dialog() {
    key_down(sprint)
    key_down(move_forward)
    Sleep(500)
    key_down(move_right)
    Sleep(1000)
    key_up(move_right)
    Sleep(1500)
    Loop 5 {
        key_press(interact)
        Sleep(100)
    }
    key_up(move_forward)
    key_up(sprint)
}

depart_on_quest(season_coord, quest_accept_coord, quest_depart_coord) {
    connection_error_check := A_Now
    while !is_quest_depart_box_visible(quest_depart_coord) {
        if (DateDiff(A_Now, connection_error_check, "Seconds") > 60) {
            recover_from_connection_error(season_coord, quest_accept_coord)
            connection_error_check := A_Now
        }
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
    fallback_check := A_Now
    while (!PixelSearch(&_, &_, ore_deposit_coord.x, ore_deposit_coord.y, ore_deposit_coord.x, ore_deposit_coord.y, 0x7D6851, 10)) {
        if (DateDiff(A_Now, fallback_check, "Seconds") > 5) {
            break
        }
        key_press(interact)
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
    fallback_check := A_Now
    while (!PixelSearch(&_, &_, reward_coord.x, reward_coord.y, reward_coord.x, reward_coord.y, 0x78624A, 10)) {
        if (DateDiff(A_Now, fallback_check, "Seconds") > 120) {
            break
        }
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
    key_down(sprint)
    key_down(move_forward)
    Sleep(500)
    key_down(move_right)
    Sleep(2000)
    key_up(move_right)
    Sleep(500)
    key_up(move_forward)
    key_up(sprint)
    Sleep(1500)
    key_press(interact)
    Sleep(500)
    key_press(item_set)
    key_press(cancel)
}

get_to_departure_dialog_from_box() {
    key_down(sprint)
    key_down(move_forward)
    key_down(move_left)
    Sleep(1000)
    key_up(move_left)
    Sleep(500)
    Loop 5 {
        key_press(interact)
        Sleep(100)
    }
    key_up(move_forward)
    key_up(sprint)
}

recover_from_connection_error(season_coord, quest_accept_coord) {
    key_press(confirm)
    key_down(sprint)
    key_down(move_forward)
    key_down(move_left)
    Sleep(2000)
    key_up(move_forward)
    key_up(move_left)
    key_down(move_back)
    Sleep(2800)
    key_down(move_left)
    while is_season_daytime_box_visible(season_coord) {
        key_press_double(interact, confirm)
    }
    key_up(move_left)
    key_up(move_back)
    key_up(sprint)
    accept_quest(season_coord, quest_accept_coord)
    key_down(sprint)
    key_down(move_forward)
    Sleep(500)
    key_down(move_right)
    Sleep(1000)
    key_up(move_right)
    Sleep(1500)
    Loop 5 {
        key_press(interact)
        Sleep(100)
    }
    key_up(move_forward)
    key_up(sprint)
}

key_press(key) {
    key_down(key)
    Sleep(50)
    key_up(key)
    Sleep(input_delay)
}

key_press_double(key1, key2) {
    key_down(key1)
    key_down(key2)
    Sleep(50)
    key_up(key1)
    key_up(key2)
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
        startup()
        SetTimer(runner, 1)
    } else {
        SetTimer(runner, 0)
    }

    startup() {
        key_press(interact)
        depart_on_quest(coordinates.season, coordinates.quest_accept, coordinates.quest_depart)
        get_to_red_box(coordinates.health, coordinates.ore_deposit)
        deposit_iron()
        wait_for_rewards(coordinates.reward)
        send_rewards_to_box()
        cancel_quest_endscreen()
        iron_left -= 3
    }

    runner() {
        wait_for_lobby(coordinates.season)
        get_to_quest_npc(coordinates.season)
        accept_quest(coordinates.season, coordinates.quest_accept)
        if (iron_left < 3) {
            resupply_at_chest()
            iron_left := 99
            get_to_departure_dialog_from_box()
            depart_on_quest(coordinates.season, coordinates.quest_accept, coordinates.quest_depart)
        } else {
            get_to_departure_dialog()
            depart_on_quest(coordinates.season, coordinates.quest_accept, coordinates.quest_depart)
        }
        get_to_red_box(coordinates.health, coordinates.ore_deposit)
        deposit_iron()
        wait_for_rewards(coordinates.reward)
        send_rewards_to_box()
        cancel_quest_endscreen()
        iron_left -= 3
    }
}
