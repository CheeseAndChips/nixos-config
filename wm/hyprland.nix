{
  extraConfig = ''
    ${builtins.readFile ./hyprland.conf}
  '';
}
