class_color_map = {}
class_color_map["Warrior"] = {r=0.78, g=0.61, b=0.43}
class_color_map["Rogue"]   = {r=1.0, g=0.96, b=0.41}
class_color_map["Hunter"]  = {r=0.67, g=0.83, b=0.45}
class_color_map["Mage"]    = {r=0.25, g=0.78, b=0.92}
class_color_map["Warlock"] = {r=0.53, g=0.53, b=0.93}
class_color_map["Paladin"] = {r=0.96, g=0.55, b=0.73}
class_color_map["Priest"]  = {r=1.0, g=1.0, b=1.0}
class_color_map["Druid"]   = {r=1.0, g=0.49, b=0.04}

raid_zones_map = {
    [249] = true,
    [409] = true,
    [469] = true,
    [509] = true,
    [531] = true,
    [533] = true,
    [309] = true
}

function SM_print(msg)
    print("Shiah Mods: " .. msg)
end