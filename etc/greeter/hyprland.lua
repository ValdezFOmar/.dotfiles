hl.monitor {
    output = '',
    mode = 'preferred',
    position = 'auto',
    scale = 1,
}
hl.bind('ALT + Q', hl.dsp.window.close())
hl.config {
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        disable_hyprland_guiutils_check = true,
    },
    animations = {
        enabled = false,
    },
}
hl.on('hyprland.start', function()
    hl.exec_cmd 'nwg-hello; hyprctl dispatch exit'
end)
