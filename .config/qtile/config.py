"""
Copyright (c) 2010 Aldo Cortesi
Copyright (c) 2010, 2014 dequis
Copyright (c) 2012 Randall Ma
Copyright (c) 2012-2014 Tycho Andersen
Copyright (c) 2012 Craig Barnes
Copyright (c) 2013 horsik
Copyright (c) 2013 Tao Sauvage

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

# refrences
# https://github.com/qtile/qtile-examples/blob/master/sweenu/keys.py
# https://github.com/qtile/qtile/wiki/app-launchers
# https://github.com/qtile/qtile-examples/blob/master/rxcomm/config.py.eee

import os
import subprocess
from typing import List

from libqtile.config import (
    Screen,
    Group,
    Drag,
    Click,
    Key as BasicKey,
    EzKey as Key,
    Match,
)
from libqtile.lazy import lazy
from libqtile import layout, bar, widget, hook

from server_monitor_widget import monitor_widget


mod = "mod4"  # windows key
terminal = os.environ.get("TERMINAL", "urxvt")

# Keysym List:
# https://github.com/qtile/qtile/blob/master/libqtile/xkeysyms.py
keys = [
    # layout specific (MonadTall)
    Key("M-h", lazy.layout.left(), desc="move focus to left window"),
    Key("M-l", lazy.layout.right(), desc="move focus to right window"),
    Key("M-j", lazy.layout.down(), desc="cycle down focus on window stack"),
    Key("M-k", lazy.layout.up(), desc="cycle up focus on window stack"),
    Key("M-S-h", lazy.layout.swap_left(), desc="swap window to left"),
    Key("M-S-l", lazy.layout.swap_right(), desc="swap window to right"),
    Key("M-S-j", lazy.layout.shuffle_down(), desc="swap window down on stack"),
    Key("M-S-k", lazy.layout.shuffle_up(), desc="swap window up on stack"),
    Key("M-i", lazy.layout.grow(), desc="increase size of window"),
    Key("M-m", lazy.layout.shrink(), desc="decrease size of window"),
    Key("M-n", lazy.layout.normalize(), desc="reset size of windows"),
    Key(
        "M-o",
        lazy.layout.maximize(),
        desc="increase currently focused window to close to max",
    ),
    Key("M-S-<space>", lazy.layout.flip(), desc="flip layout stacks"),
    # window
    Key(
        "M-S-f",
        lazy.window.toggle_floating(),
        desc="toggle currently focused window as floating",
    ),
    Key(
        "M-f",
        lazy.window.toggle_fullscreen(),
        desc="toggle fullscreen on currently focused window",
    ),
    # run commands
    Key("M-<Return>", lazy.spawn(terminal), desc="open a terminal"),
    Key("M-r", lazy.spawn('rofi -show run -display-run "run > "'), desc="run prompt"),
    Key(
        "M-<Tab>",
        lazy.spawn('rofi -show window -display-window "window > "'),
        desc="swap to window prompt",
    ),
    Key(
        "<XF86Display>",
        lazy.spawn("randomize_wallpaper"),
        desc="randomize current wallpaper",
    ),
    Key("M-S-<Escape>", lazy.spawn("lock_screen"), desc="lock the screen"),
    Key("M-S-w", lazy.spawn("wfi"), desc="wait till I have internet and notify me"),
    Key(
        "<XF86MonBrightnessUp>",
        lazy.spawn("brightness up"),
        desc="increase screen brightness",
    ),
    Key(
        "<XF86MonBrightnessDown>",
        lazy.spawn("brightness down"),
        desc="decrease screen brightness",
    ),
    Key(
        "<XF86AudioRaiseVolume>", lazy.spawn("volume up"), desc="increase system volume"
    ),
    Key(
        "<XF86AudioLowerVolume>",
        lazy.spawn("volume down"),
        desc="decrease system volume",
    ),
    Key("<XF86AudioMute>", lazy.spawn("volume mute"), desc="mute system volume"),
    Key("<XF86AudioMicMute>", lazy.spawn("volume micmute"), desc="mute the mic"),
    Key(
        "M-S-e",
        lazy.spawn(f"{terminal} -e refresh-doom"),
        desc="refresh doom bindings/packages and the emacs daemon",
    ),
    Key(
        "<Print>",
        lazy.spawn("screenshot"),
        desc="changes cursor to select a region to take a screenshot",
    ),
    Key(
        "S-<Print>",
        lazy.spawn("screenshot -f"),
        desc="take a screenshot of the entire screen"
    ),
    Key(
        "M-<Print>",
        lazy.spawn("screenshot-to-imgur"),
        desc="uploads most recent recent screenshot to imgur",
    ),
    # general qtile commands
    Key("M-S-<Tab>", lazy.next_layout(), desc="swap to next qtile layout"),
    Key("M-q", lazy.window.kill(), desc="kill the current window"),
    Key("M-S-r", lazy.restart(), desc="restart qtile in place"),
]


# application launcher
applications = [
    "thunderbird",
    "emacs",
    "slack",
    "keepassxc",
    "discord",
    "firefox-developer-edition",
]
terminal_applications = [
    "ranger",
    "update",
]

# launch applications with Mod+Ctrl+<>
keys.extend(
    [
        Key(f"M-C-{app[0]}", lazy.spawn(app), desc=f"launch {app}")
        for app in applications
    ]
)
keys.extend(
    [
        Key(
            f"M-C-{termapp[0]}",
            lazy.spawn(f"launch {termapp}"),
            desc=f"launch a terminal with {termapp}",
        )
        for termapp in terminal_applications
    ]
)

groups = [
    Group("1"),
    Group("2"),
    Group("3", matches=[Match(wm_class=["discord"])]),
    Group("4"),
    Group("5"),
    Group("6"),
    Group("7"),
    Group("8", layout="max", matches=[Match(wm_class=["slack", "Slack"])]),
    Group("9", layout="max", matches=[Match(wm_class=["Thunderbird", "Mail"])],),
]

for i, g in enumerate(groups, 1):
    keys.extend(
        [
            # mod1 + group number = switch to group
            BasicKey(
                [mod],
                str(i),
                lazy.group[g.name].toscreen(),
                desc=f"switch to group {i}",
            ),
            # mod1 + shift + group number = move focused window to group
            BasicKey(
                [mod, "shift"],
                str(i),
                lazy.window.togroup(g.name, switch_group=False),
                desc=f"move focused window to group {i}",
            ),
        ]
    )
layout_theme = {"border_width": 2,
                "margin": 3,
                "border_focus": "e1acff",
                "border_normal": "282a36"
                }
layouts = [
    layout.MonadTall(**layout_theme),
    layout.Max(),
]

widget_defaults = dict(font="Source Code Pro", fontsize=12, padding=3,)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.GenPollText(func=monitor_widget, update_interval=600),
                widget.sep.Sep(padding=5),
                widget.CurrentLayoutIcon(scale=0.6),
                widget.CurrentLayout(),
                widget.sep.Sep(padding=5),
                widget.TextBox("CPU:"),
                widget.CPUGraph(update_interval=3),
                widget.ThermalSensor(update_interval=3),
                widget.sep.Sep(padding=5),
                widget.TextBox("BAT:"),
                widget.Battery(),
                widget.sep.Sep(padding=5),
                widget.Wlan(interface="wlp4s0", update_interval=5, format="{essid}",),
                widget.sep.Sep(padding=5),
                widget.Clock(format="%b %d (%a) %I:%M%p", update_interval=5.0),
                widget.sep.Sep(padding=5),
                widget.Systray(),
            ],
            30,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False
floating_layout = layout.Floating(float_rules=[{"wmclass": "dragon-drag-and-drop"}, {"wmclass": "megasync"}])
auto_fullscreen = True
focus_on_window_activation = "smart"


@hook.subscribe.startup_once
def autostart():
    autostart_script = os.path.join(os.path.dirname(__file__), "autostart.sh")
    subprocess.call([autostart_script])
