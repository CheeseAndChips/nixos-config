{
  mainBar = {
    layer = "top";
    position = "top";
    modules-left = [ "clock" "hyprland/language" ];
    modules-center = [ "hyprland/workspaces" ];
    modules-right = [ "disk" "battery" "custom/battery_capacity" "cpu" "temperature" "pulseaudio" "network" "tray" ];

    "hyprland/workspaces" = {
      disable-scroll = true;
      format = "{id}";
      active-only = false;
      all-outputs = true;
    };

    "hyprland/window" = {
      format = "{}";
      max-length = 50;
      tooltip = false;
    };

    "hyprland/language" = {
        format = "<big></big> {short}";
        max-length = 5;
        min-length = 5;
    };

    # idle_inhibitor = {
    #     format = "{icon}";
    #     format-icons = {
    #         activated = " ";
    #         deactivated = " ";
    #     };
    #     tooltip = true;
    # };

    disk = {
        path = "/";
        format = "  {free}";
    };

    tray = {
        spacing = 5;
    };

    clock = {
        format = "  {:%H:%M   %e %b}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        today-format = "<b>{}</b>";
        on-click = "gnome-calendar";
    };

    battery = {
      bat = "BAT0";
      adapter = "AC";
      format = "󰁹 {capacity}%";
      format-charging = "󰂄 {capacity}%";
    };

    cpu = {
        interval = "1";
        # format = "  {usage}% <span color=\"darkgray\">| {max_frequency}GHz</span>";
        format = "  {usage}%";
        # max-length = 13;
        # min-length = 13;
        tooltip = false;
    };

    temperature = {
        thermal-zone = 2;
        interval = "1";
        critical-threshold = 74;
        format-critical = "  {temperatureC}°C";
        format = "{icon}  {temperatureC}°C";
        format-icons = [""];
        max-length = 7;
        min-length = 7;
    };

    network = {
        format-wifi = "  {essid}";
        format-ethernet = " {ipaddr}   {bandwidthUpBits}   {bandwidthDownBits}";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
        family = "ipv4";
        tooltip-format-wifi = "  {ifname} @ {essid}\nIP: {ipaddr}\nStrength: {signalStrength}%\nFreq: {frequency}MHz\n {bandwidthUpBits}  {bandwidthDownBits}";
        tooltip-format-ethernet = " {ifname}\nIP: {ipaddr}/{cidr}\n  {bandwidthUpBits}  {bandwidthDownBits}";
    };

    pulseaudio = {
        scroll-step = 3;
        format = "{icon}  {volume}% {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "";
        format-source-muted = "";
        format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
        };
        on-click = "pavucontrol";
        on-click-right = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
    };

    "custom/cpugovernor" = {
      format = "{icon}";
      interval = 30;
      return-type = "json";
      exec = ./cpugovernor.sh;
      min-length = 2;
      max-length = 2;
      format-icons = {
        perf = "";
        sched = "";
      };
    };

    "custom/battery_capacity" = {
      format = "CAP {text}";
      exec = "cat /var/tmp/current_battery_limit";
      interval = 1;
    };
  };
}
