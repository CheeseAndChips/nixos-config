{ config, pkgs, lib, ... }:
let
  hyprconfig = import ./hyprland.nix;
  waybarconfig = import ./waybar;
  woficonfig = import ./wofi;
  hyprlockconfig = import ./hyprlock.nix;
in
{
  options.wmconfig = {
    users = lib.options.mkOption { type = with lib.types; listOf str; };
  };

  config = {
    environment.systemPackages = with pkgs; [
      hyprshot
      mako
    ];

    fonts.packages = with pkgs; [
      font-awesome
      noto-fonts
      nerd-fonts.symbols-only
      nerd-fonts.hack
    ];

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    home-manager.users = with builtins; listToAttrs (map
      (username: {
        name = username;
        value = { pkgs, ... }:
        {
          wayland.windowManager.hyprland = {
            enable = true;
            settings = hyprconfig;
          };

          programs.waybar = {
            enable = true;
            settings = waybarconfig;
            style = ./waybar/style.css;
          };

          programs.wofi = {
            enable = true;
            settings = woficonfig;
            style = builtins.readFile ./wofi/style.css;
          };

          programs.hyprlock = {
            enable = true;
            settings = hyprlockconfig;
          };

          home.pointerCursor = {
            gtk.enable = true;
            package = pkgs.bibata-cursors;
            name = "Bibata-Original-Ice";
            size = 26;
          };

          gtk = {
            enable = true;
            theme = {
              package = pkgs.flat-remix-gtk;
              name = "Flat-Remix-GTK-Green-Darkest";
            };
            iconTheme = {
              package = pkgs.kdePackages.breeze-icons;
              name = "BreezeIcons";
            };
            font = {
              name = "Sans";
              size = 10;
            };
          };
        };
      }) config.wmconfig.users);
    };
}
