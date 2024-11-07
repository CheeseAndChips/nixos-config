{ config, pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-run"
  ];
  programs.steam = {
    enable = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  users.users.gaming = {
    isNormalUser = true;
    description = "Gaming";
    extraGroups = [ "networkmanager" ];
    useDefaultShell = true;
  };

  home-manager.users.gaming = { pkgs, ... }:
  {
    home.stateVersion = "24.05";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
