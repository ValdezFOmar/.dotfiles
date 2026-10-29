-- Config documentation: https://wiki.hypr.land/configuring/

--
-- Monitors
--
hl.monitor {
    output = '',
    mode = 'preferred',
    position = 'auto',
    scale = 1,
}

hl.monitor {
    output = 'HDMI-A-1',
    mirror = 'eDP-1',
    mode = 'preferred',
    position = 'auto',
    scale = 1,
}

--
-- Startup Programs
--
hl.on('hyprland.start', function()
    hl.exec_cmd 'uwsm app -- xrdb ~/.config/xorg/Xresources'
    hl.exec_cmd 'uwsm app -- hyprctl setcursor Qogir-cursors 24'
    hl.exec_cmd 'uwsm app -- copyq --start-server'
    hl.exec_cmd 'uwsm app -- udiskie --automount --notify --smart-tray'
    hl.exec_cmd 'uwsm app -- polkit-gnome-authentication-agent-1.desktop'
    hl.exec_cmd 'uwsm app -- ~/.config/hypr/scripts/volume-indicator.py'

    -- Wine will error if the variable is defined but the directory doesn't exist
    hl.exec_cmd 'test -n "$WINEPREFIX" && mkdir --parents "$WINEPREFIX"'

    -- Spawn frequently used programs
    hl.exec_cmd('uwsm app -- firefox', { workspace = '1 silent' })
    hl.exec_cmd('uwsm app -- kitty --hold --directory ~ fastfetch', { workspace = '2 silent' })
end)

--
-- Configuration
--

local inactive_border = '#005F78'

hl.config {
    general = {
        border_size = 1,
        gaps_in = 2,
        gaps_out = 5,
        layout = 'monocle',
        resize_on_border = true,
        col = {
            active_border = { colors = { '#00b8db', '#53eafd' }, angle = 90 },
            inactive_border = inactive_border,
        },
        snap = {
            enabled = true,
        },
    },
    dwindle = {
        force_split = 2,
        preserve_split = true,
    },
    input = {
        kb_layout = 'us,latam',
        kb_options = 'grp:win_space_toggle',
    },
    misc = {
        -- NOTE:
        -- There's some strange behavior when staging this file after
        -- pre-commit runs, so it's better to disable it and just run
        -- `hyprctl reload` when necessary
        disable_autoreload = true,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        disable_hyprland_guiutils_check = true,
        force_default_wallpaper = 0,
        focus_on_activate = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
}

--
-- Rules
--

-- Blur semi-transparent backgrounds while ignoring fully transparent ones
hl.layer_rule {
    blur = true,
    blur_popups = true,
    ignore_alpha = 0,
    match = { namespace = [[waybar|launcher|notifications]] },
}

-- Default floating windows
hl.window_rule {
    float = true,
    match = {
        class = [[firefox]],
        title = [[(Library)|(About Mozilla Firefox)|(Firefox - Choose User Profile)]],
    },
}
hl.window_rule { float = true, match = { class = [[blueman-manager]] } }
hl.window_rule {
    float = true,
    size = { 'monitor_w * 0.4', 'monitor_h * 0.5' },
    match = { class = [[com\.github\.hluk\.copyq]] },
}
hl.window_rule {
    float = true,
    size = { 'monitor_w * 0.4', 'monitor_h * 0.5' },
    match = { class = [[xdg-desktop-portal-gtk]] },
}

-- Ignore maximize requests from apps
hl.window_rule { suppress_event = 'maximize', match = { class = [[.*]] } }

-- Fix some dragging issues with XWayland
hl.window_rule {
    no_focus = true,
    match = {
        class = [[^$]],
        title = [[^$]],
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
}

-- Inactive border when there's only one window on screen
--   w[v1] -> one visible window
--   f[1]  -> maximized window
hl.window_rule { border_color = inactive_border, match = { float = false, workspace = 'w[v1]' } }
hl.window_rule { border_color = inactive_border, match = { float = false, workspace = 'f[1]' } }

--
-- Decorations and animations
--
hl.config {
    decoration = {
        rounding = 10,
        dim_inactive = true,
        blur = {
            enabled = true,
            size = 6,
            passes = 2,
        },
        shadow = {
            enabled = true,
        },
    },
    animations = {
        enabled = true,
    },
}

---@class bones.animation.Spec
---@field seconds number
---@field bezier string
---@field style? string

---@param specs table<string, bones.animation.Spec>
local function animations(specs)
    for leaf, spec in pairs(specs) do
        hl.animation {
            leaf = leaf,
            enabled = true,
            speed = spec.seconds * 10, -- `speed` uses 100ms units
            bezier = spec.bezier,
            style = spec.style,
        }
    end
end

hl.curve('linear', { type = 'bezier', points = { { 0, 0 }, { 1, 1 } } })
hl.curve('ease-in-sine', { type = 'bezier', points = { { 0.12, 0 }, { 0.39, 0 } } })
hl.curve('ease-out-sine', { type = 'bezier', points = { { 0.61, 1 }, { 0.88, 1 } } })
hl.curve('ease-out-cubic', { type = 'bezier', points = { { 0.33, 1 }, { 0.68, 1 } } })

animations {
    layersIn = { seconds = 0.6, bezier = 'ease-out-cubic', style = 'slide' },
    layersOut = { seconds = 0.6, bezier = 'ease-in-sine', style = 'slide' },
    windowsIn = { seconds = 0.6, bezier = 'ease-out-cubic', style = 'popin 40%' },
    windowsOut = { seconds = 0.3, bezier = 'linear', style = 'popin 60%' },
    fadeIn = { seconds = 0.6, bezier = 'ease-out-cubic' },
    fadeOut = { seconds = 0.3, bezier = 'ease-out-sine' },
    fadeLayersIn = { seconds = 0.6, bezier = 'ease-out-cubic' },
    fadeLayersOut = { seconds = 0.8, bezier = 'ease-out-sine' },
}

--
-- Gestures
--
hl.gesture { fingers = 3, direction = 'horizontal', action = 'workspace' }
hl.gesture { fingers = 3, direction = 'up', action = 'fullscreen' }
hl.gesture {
    mods = 'SUPER',
    fingers = 2,
    direction = 'pinch',
    action = 'cursor_zoom',
    zoom_level = 1,
    mode = 'live',
}

--
-- Keybindings
--

local exec = hl.dsp.exec_cmd

-- Misc
hl.bind('SUPER + Q', exec 'uwsm app -- ~/bin/powermenu.py')
hl.bind('SUPER + L', exec 'uwsm app -- hyprlock')
hl.bind('SUPER + D', function()
    local dim_inactive = hl.get_config 'decoration.dim_inactive'
    hl.config { decoration = { dim_inactive = not dim_inactive } }
end)
hl.bind('SUPER + T', function()
    local tap_to_click = not hl.get_config 'input.touchpad.tap_to_click'
    hl.config { input = { touchpad = { tap_to_click = tap_to_click } } }
end)

-- Applications
hl.bind('SUPER + RETURN', exec 'uwsm app -- kitty')
hl.bind('SUPER + B', exec 'uwsm app -- firefox')
hl.bind('SUPER + E', exec 'uwsm app -- pcmanfm')
hl.bind('SUPER + O', exec 'uwsm app -- fuzzel')
hl.bind('SUPER + H', exec 'uwsm app -- copyq show')
hl.bind(
    'SUPER + P',
    exec 'pidof hyprpicker || uwsm app -- hyprpicker --autocopy --notify --format=hex'
)

-- Screenshot actions
hl.bind('Print', exec 'uwsm app -- ~/bin/screenshot screen', { locked = true })
hl.bind('CTRL + Print', exec 'uwsm app -- ~/bin/screenshot region')

-- Laptop multimedia keys for volume and LCD brightness
local opts = { locked = true, repeating = true }
hl.bind('XF86AudioRaiseVolume', exec 'wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%+', opts)
hl.bind('XF86AudioLowerVolume', exec 'wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 5%-', opts)
hl.bind('XF86AudioMute', exec 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle', opts)
hl.bind('XF86AudioMicMute', exec 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle', opts)
hl.bind('XF86MonBrightnessUp', exec 'brightnessctl set +2.5% --exponent=8', opts)
hl.bind('XF86MonBrightnessDown', exec 'brightnessctl set 2.5%- --exponent=8', opts)

-- Operations on windows
hl.bind('SUPER + C', hl.dsp.window.close())
hl.bind('SUPER + F', hl.dsp.window.fullscreen { mode = 'fullscreen', action = 'toggle' })
hl.bind('SUPER + M', hl.dsp.window.fullscreen { mode = 'maximized', action = 'toggle' })
hl.bind('SUPER + V', hl.dsp.window.float { action = 'toggle' })

-- Switch window focus
hl.bind('SUPER + J', hl.dsp.window.cycle_next { next = true, tiled = true })
hl.bind('SUPER + K', hl.dsp.window.cycle_next { next = false, tiled = true })
hl.bind('SUPER + left', hl.dsp.focus { direction = 'left' })
hl.bind('SUPER + right', hl.dsp.focus { direction = 'right' })
hl.bind('SUPER + up', hl.dsp.focus { direction = 'up' })
hl.bind('SUPER + down', hl.dsp.focus { direction = 'down' })

-- Move windows
hl.bind('SUPER + SHIFT + J', hl.dsp.window.swap { next = true })
hl.bind('SUPER + SHIFT + K', hl.dsp.window.swap { prev = true })

-- Focus workspaces and move windows (workspace 10 uses key 0)
for i = 1, 10 do
    local key = i % 10
    hl.bind('SUPER + ' .. key, hl.dsp.focus { workspace = i })
    hl.bind('SUPER + SHIFT + ' .. key, hl.dsp.window.move { workspace = i, follow = true })
end

-- Move/resize windows while dragging with left/right mouse click
hl.bind('SUPER + mouse:272', hl.dsp.window.drag(), { mouse = true })
hl.bind('SUPER + mouse:273', hl.dsp.window.resize(), { mouse = true })
