# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>

      ./wm
      ./neovim
      ./gaming
      ./backuper
    ];

  wmconfig.users = [ "joris" "gaming" ];
  neovimconfig.users = [ "joris" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };
  boot.tmp.useTmpfs = true;
  # boot.loader.systemd-boot.enable = true;

  networking.hostName = "tabletop";
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs.zsh = {
    # grml-zsh-config according to https://discourse.nixos.org/t/using-zsh-with-grml-config-and-nix-shell-prompt-indicator/13838
    enable = true;
    promptInit = ""; # otherwise it'll override the grml prompt
    interactiveShellInit = ''
      # Note that loading grml's zshrc here will override NixOS settings such as
      # `programs.zsh.histSize`, so they will have to be set again below.
      source ${pkgs.grml-zsh-config}/etc/zsh/zshrc
      HISTSIZE=10000000

      # disable sad smiley on non-zero exit
      zstyle ':prompt:grml:right:setup' items

      # Add nix-shell indicator that makes clear when we're in nix-shell.
      # Set the prompt items to include it in addition to the defaults:
      # Described in: http://bewatermyfriend.org/p/2013/003/
      function nix_shell_prompt () {
        REPLY=''${IN_NIX_SHELL+"(nix-shell) "}
      }
      grml_theme_add_token nix-shell-indicator -f nix_shell_prompt '%F{magenta}' '%f'
      zstyle ':prompt:grml:left:setup' items rc nix-shell-indicator change-root user at host path vcs percent
    '';
  };

  programs.tmux = {
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
    extraConfig = "set-option -g default-shell ${pkgs.zsh}/bin/zsh";
  };

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joris = {
    isNormalUser = true;
    description = "Joris";
    extraGroups = [ "networkmanager" "wheel" ];
    useDefaultShell = true;
  };

  home-manager.users.joris = { pkgs, ... }:
  {
    programs.vim = {
      enable = true;
      settings = {
        relativenumber = true;
        expandtab = true;
      };
    };
    programs.git = {
      enable = true;
      userName = "Joris Pevcevičius";
      userEmail = "joris.pevcas@gmail.com";
    };
    home.stateVersion = "24.05";
  };

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    tmux
    git
    ripgrep
    wl-clipboard
    restic
    pass-wayland
    unzip

    gimp
    feh
    kitty
    qalculate-gtk

    killall
    htop
    nix-search-cli
    ranger
    vesktop

    linux-manual
    man-pages
    man-pages-posix
  ];

  environment.variables.EDITOR = "vim";

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  documentation = {
    enable = true;
    man = {
      enable = true;
      man-db.enable = true;
      generateCaches = true;
    };
    dev.enable = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
