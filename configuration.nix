# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

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
  # boot.loader.systemd-boot.enable = true;

  networking.hostName = "tabletop";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Vilnius";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.zsh = {
    ohMyZsh = {
      theme = "robbyrussell";
      enable = true;
      plugins = [ "git" ];
    };
    enable = true;
  };

  programs.tmux = {
    enable = true;
    escapeTime = 0;
    keyMode = "vi";
  };

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

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
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
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  users.users.gaming = {
    isNormalUser = true;
    description = "I Do Gaming";
    extraGroups = [ "networkmanager" ];
    useDefaultShell = true;
    packages = with pkgs; [ ];
  };

  home-manager.users.joris = { pkgs, ... }: {
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
    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        undotree
        vim-fugitive
        lsp-zero-nvim
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        luasnip # Needed for LSP to work properly
        { plugin = telescope-nvim;
          type = "lua";
          config = ''
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ps', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
            vim.keymap.set('n', '<leader>pas', builtin.live_grep, {})
          '';
        }
        {
          plugin = harpoon;
          type = "lua";
          config = ''
            local mark = require('harpoon.mark')
            local ui = require('harpoon.ui')
            vim.keymap.set('n', '<leader>a', mark.add_file)
            vim.keymap.set('n', '<leader>e', ui.toggle_quick_menu)
            vim.keymap.set('n', '<leader>t', function() ui.nav_file(1) end)
            vim.keymap.set('n', '<leader>y', function() ui.nav_file(2) end)
            vim.keymap.set('n', '<leader>u', function() ui.nav_file(3) end)
            vim.keymap.set('n', '<leader>i', function() ui.nav_file(4) end)
          '';
        }
        { plugin = onedark-nvim;
          type = "lua";
          config = ''
            local od = require('onedark')
            od.setup {
              style = 'warmer'
            }
            od.load()
          '';
        }
      ];
      extraLuaConfig = ''
        vim.g.mapleader = " "

        vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
        vim.keymap.set("n", "<leader>pe", vim.diagnostic.setqflist)
        vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>")

        vim.opt.nu = true
        vim.opt.relativenumber = true
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.expandtab = true
        vim.opt.wrap = true
        vim.opt.smartindent = true

        vim.opt.swapfile = false
        vim.opt.backup = false
        vim.opt.undodir = vim.fn.stdpath('data') .. '/undodir'
        vim.opt.undofile = true

        vim.opt.incsearch = true
        vim.opt.hlsearch = false

        vim.opt.termguicolors = true

        vim.opt.scrolloff = 8
        vim.opt.signcolumn = "yes"

        vim.opt.updatetime = 250
        vim.opt.modelines = 0

        vim.opt.fixeol = false



        
        local lsp = require('lsp-zero')
        local cmp = require('cmp')
        local lspconfig = require('lspconfig')
        lsp.preset('recommended')
        lsp.set_sign_icons()
        local cmp_select = {behavior = cmp.SelectBehavior.Select}
        cmp.setup({
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'nvim_lua' },
                { name = 'luasnip', keyword_length = 2 },
                { name = 'buffer', keyword_length = 3 },
            },
            formatting = lsp.cmp_format(),
            mapping = cmp.mapping.preset.insert({
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                ['<C-d>'] = cmp.mapping.scroll_docs(4),
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
        })
        lsp.on_attach(function(client, bufnr)
            local opts = {buffer = bufnr, remap = false}
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
            vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
            vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts)
            vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "gs", function() vim.lsp.buf.signature_help() end, opts)
            vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set({"n", "v"}, "<F3>", function() vim.lsp.buf.format() end, opts)
            vim.keymap.set("n", "<F4>", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        end)
        lspconfig.jdtls.setup({})
        lspconfig.pyright.setup({})
        lsp.setup()
        vim.diagnostic.config({
            virtual_text = true,
            update_in_insert = true,
        })
      '';
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

    gimp
    feh
    kitty
    wofi
    waybar

    killall
    htop
    nix-search-cli
    ranger
    vesktop

    jdt-language-server
    pyright
  ];

  environment.variables.EDITOR = "vim";

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" "Hack" ]; })
  ];

  services.ollama = {
    enable = true;
    acceleration = "rocm";
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
