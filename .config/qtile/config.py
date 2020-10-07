#
#
#                               ████ ██                            
#                              ░██░ ░░   █████     ██████   ██   ██
#    █████   ██████  ███████  ██████ ██ ██░░░██   ░██░░░██ ░░██ ██ 
#   ██░░░██ ██░░░░██░░██░░░██░░░██░ ░██░██  ░██   ░██  ░██  ░░███  
#  ░██  ░░ ░██   ░██ ░██  ░██  ░██  ░██░░██████   ░██████    ░██   
#  ░██   ██░██   ░██ ░██  ░██  ░██  ░██ ░░░░░██ ██░██░░░     ██    
#  ░░█████ ░░██████  ███  ░██  ░██  ░██  █████ ░██░██       ██     
#   ░░░░░   ░░░░░░  ░░░   ░░   ░░   ░░  ░░░░░  ░░ ░░       ░░      
#
#
# Copywrite (c) 2020 Jackson Mooring
#  - https://github.com/Verassitnh
#  - https://jacksonmooring.com
#
# IMPORTS
import os
import socket
import subprocess

from typing import List

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

# CONFIG VARIABLES
mod = "mod4"
terminal = guess_terminal()

# THEMES
colors = {
    "background": ["#282C34", "#282C34"],
    "foreground": ["#ABB2BF", "#3E4452"],
    "red": ["#E06C75", "#E06C75"],
    "green": ["#98C379", "#98C379"],
    "yellow": ["#E5C07B", "#E5C07B"],
    "blue": ["#61AFEF", "#61AFEF"],
    "purple": ["#C678DD", "#C678DD"],
    "teal": ["#56B6C2", "#56B6C2"],
    "foreground_color": ["#282C34", "#282C34"]
}

layout_theme = {
    "border_width": 2.5,
    "margin": 5,
    "border_focus": "#E06C75",
    "border_normal": "#282C34"
}

# GROUP CONFIG
group_names = [
    ("TODO", {'layout': 'ratiotile'}),
    ("EDU", {'layout': 'ratiotile'}),
    ("DEV", {'layout': 'ratiotile'}),
    ("DOC", {'layout': 'monadtall'}),
    ("TERM", {'layout': 'monadtall'}),
    ("SYS", {'layout': 'monadtall'}),
    ("CHAT", {'layout': 'max'}),
    ("MUS", {'layout': 'max'}),
    ("WEB", {'layout': 'floating'})
]

# LAYOUT CONFIG
layouts = [
    layout.RatioTile(**layout_theme),
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    layout.Floating(**layout_theme)
]


keys = [
    # Switch between windows in current stack pane
    Key([mod], "k", lazy.layout.down(),
        desc="Move focus down in stack pane"),
    Key([mod], "j", lazy.layout.up(),
        desc="Move focus up in stack pane"),

    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down(),
        desc="Move window down in current stack "),
    Key([mod, "control"], "j", lazy.layout.shuffle_up(),
        desc="Move window up in current stack "),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next(),
        desc="Switch window focus to other pane(s) of stack"),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate(),
        desc="Swap panes of split stack"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "shift"], "Return", lazy.spawn(
        "firefox"), desc="Launch Firefox"),
    Key([mod], "c",  lazy.spawn("colorgrab"), desc="Launch ColorGrab"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart qtile"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown qtile"),
    Key([mod], "r", lazy.spawncmd(),
        desc="Spawn a command using a prompt widget"),
]

# INITIATE GROUPS
groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    # Switch to another group
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))
    # Send current window to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name)))


prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())


# DEFAULT WIDGET SETTINGS
widget_defaults = dict(
    font="Hack Nerd Font",
    fontsize=10,
    padding=2,
    foreground=colors["foreground_color"][0]
)

extension_defaults = widget_defaults.copy()


def init_widgets_list():
    widgets_list = [
          widget.Sep(
                   linewidth = 0,
                   padding = 6,
                   foreground = colors["foreground"][0],
                   background = colors["background"][0]
                   ),
        widget.GroupBox(
            font="Hack Nerd Font",
            fontsize=10,
            margin_y=4,
            margin_x=10,
            padding_y=4,
            padding_x=10,
            borderwidth=0,
            active=colors["foreground"][1],
            inactive=colors["foreground"][1],
            rounded=False,
            highlight_color=colors["red"][0],
            highlight_method="block",
            this_current_screen_border=colors["red"][0],
            # this_screen_border = ,
            #other_current_screen_border = colors[0],
            #other_screen_border = colors[0],
            foreground=colors["foreground_color"][0],
            background=colors["background"][1]
        ),
        widget.Prompt(
            prompt=prompt,
            padding=10,
            foreground=colors["foreground"][0],
            background=colors["background"][0]
        ),
          widget.Spacer(
                    length = bar.STRETCH,
                    background = colors["background"][0],
                    ),
        # widget.TextBox(
        #         text = '',
        #         background = colors[0],
        #         foreground = colors[4],
        #         padding = 0,
        #         fontsize = 37
        #         ),
        # widget.TextBox(
        #         text = " ₿",
        #         padding = 0,
        #         foreground = colors[2],
        #         background = colors[4],
        #         fontsize = 12
        #         ),
        # widget.BitcoinTicker(
        #         foreground = colors[2],
        #         background = colors[4],
        #        padding = 5
        #         ),
        widget.TextBox(
            text=" 🌡",
            padding=0,
            foreground=colors["foreground_color"][0],
            background=colors["red"][0],
        ),
          widget.ThermalSensor(
                   foreground = colors["foreground_color"][0],
                   background = colors["red"][0],
                   threshold = 90,
                   padding = 5
                   ),
        widget.TextBox(
            text=" ⟳",
            padding=2,
            foreground=colors["foreground_color"][0],
            background=colors["green"][0],
        ),
          widget.Pacman(
                   update_interval = 5,
                   foreground = colors["foreground_color"][0],
                   mouse_callbacks = {'Button1': lambda qtile: qtile.cmd_spawn(terminal + ' -e sudo pacman -Syu')},
                   background = colors["green"][0]
                   ),
        widget.TextBox(
            text="Updates",
            padding=5,
            mouse_callbacks={'Button1': lambda qtile: qtile.cmd_spawn(
                terminal + ' -e sudo pacman -Syu')},
            foreground=colors["foreground_color"][0],
            background=colors["green"][0]
        ),
        widget.TextBox(
            text=" Vol:",
            foreground=colors["foreground_color"][0],
            background=colors["yellow"][0],
            padding=0
        ),
          widget.Volume(
                   background = colors["yellow"][0],
                   padding = 5,
                   ),
        widget.CurrentLayoutIcon(
            custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
            background=colors["blue"][0],
            padding=0,
            scale=0.7
        ),
        widget.CurrentLayout(
            background=colors["blue"][0],
            padding=5
        ),
        widget.Clock(
            background=colors["purple"][0],
            format="%A, %B %d  [ %H:%M ]",
            padding=5
        ),
          widget.Sep(
                   linewidth = 0,
                   padding = 10,
                   background = colors["purple"][0]
                   ),
    ]
    return widgets_list


def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_list(), opacity=1.0, size=20))]


screens = init_screens()

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"
@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart.sh'])
# # XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "Qtile"
