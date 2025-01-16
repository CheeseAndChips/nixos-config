{
  monitor = ",highrr,auto,auto";

  "$terminal" = "kitty";
  "$menu" = "wofi --show drun";

  exec-once = [
    "waybar"
  ];

  env = [
    "XCURSOR_SIZE,24"
    "HYPRCURSOR_SIZE,24"
  ];

  general = {
    gaps_in = "5";
    gaps_out = "20";
    border_size = "2";
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    resize_on_border = "false";
    allow_tearing = true;
    layout = "dwindle";
  };

  decoration = {
    rounding = "10";
    active_opacity = "1.0";
    inactive_opacity = "1.0";

    shadow = {
      enabled = "true";
      range = "4";
      render_power = "3";
      color = "rgba(1a1a1aee)";
    };

    blur = {
      enabled = "true";
      size = "3";
      passes = "1";
      vibrancy = "0.1696";
    };
  };

  animations = {
    enabled = "true";
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

    animation = [
      "windows, 1, 2, myBezier"
      "windowsOut, 1, 2, default, popin 80%"
      "border, 1, 1, default"
      "borderangle, 1, 1, default"
      "fade, 1, 2, default"
      "workspaces, 1, 2, default"
    ];
  };

  dwindle = {
    pseudotile = "true";
    preserve_split = "true";
  };

  master = {
    new_status = "master";
  };

  misc = {
    force_default_wallpaper = "0";
    disable_hyprland_logo = "false";
  };

  input = {
    kb_layout = "us,lt";
    kb_options = "grp:alt_space_toggle";
    follow_mouse = "1";
    sensitivity = "0";
    accel_profile = "flat";
    touchpad = {
      natural_scroll = "false";
    };
  };

  "$mainMod" = "SUPER";

  bind = [
    "$mainMod, RETURN, exec, $terminal"
    "$mainMod SHIFT, Q, killactive,"
    "$mainMod, M, exit,"
    "$mainMod, E, exec, $fileManager"
    "$mainMod, SPACE, togglefloating,"
    "$mainMod, D, exec, $menu"
    "$mainMod, P, pseudo, # dwindle"
    "$mainMod, V, togglesplit, # dwindle"
    "$mainMod, F, fullscreen"

    "bind = $mainMod, h, movefocus, l"
    "bind = $mainMod, l, movefocus, r"
    "bind = $mainMod, k, movefocus, u"
    "bind = $mainMod, j, movefocus, d"

    "$mainMod, 1, workspace, 1"
    "$mainMod, 2, workspace, 2"
    "$mainMod, 3, workspace, 3"
    "$mainMod, 4, workspace, 4"
    "$mainMod, 5, workspace, 5"
    "$mainMod, 6, workspace, 6"
    "$mainMod, 7, workspace, 7"
    "$mainMod, 8, workspace, 8"
    "$mainMod, 9, workspace, 9"

    "$mainMod SHIFT, 1, movetoworkspace, 1"
    "$mainMod SHIFT, 2, movetoworkspace, 2"
    "$mainMod SHIFT, 3, movetoworkspace, 3"
    "$mainMod SHIFT, 4, movetoworkspace, 4"
    "$mainMod SHIFT, 5, movetoworkspace, 5"
    "$mainMod SHIFT, 6, movetoworkspace, 6"
    "$mainMod SHIFT, 7, movetoworkspace, 7"
    "$mainMod SHIFT, 8, movetoworkspace, 8"
    "$mainMod SHIFT, 9, movetoworkspace, 9"

    "$mainMod, S, togglespecialworkspace, magic"
    "$mainMod SHIFT, S, movetoworkspace, special:magic"

    "$mainMod, mouse_down, workspace, e+1"
    "$mainMod, mouse_up, workspace, e-1"
  ];

  bindl = [
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%- -l 1"
    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1"
  ];

  bindm = [
    "$mainMod, mouse:272, movewindow"
    "$mainMod, mouse:273, resizewindow"
  ];

  windowrulev2 = [
    "suppressevent maximize, class:.*"
    "float, class:^(qalculate-gtk)$"
    "size 700 550, class:^(qalculate-gtk)$"
  ];
}
