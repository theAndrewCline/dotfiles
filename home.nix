{ pkgs, pkgs-unstable, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  colors = import ./colors.nix { };
in
{
  imports = [ ];

  nixpkgs.config.allowUnfree = true;

  home.username = "acline";
  home.homeDirectory = "/home/acline";
  home.packages = with pkgs; [
    openssl
    httpie
    atuin
    nodejs
    pnpm
    deno
    yarn-berry
    mods
    go
    rustup
    marksman
    gopls
    nodePackages.prettier
    nodePackages.typescript-language-server
    vscode-langservers-extracted
    postgresql_14
    nil
    speedtest-rs
    monaspace
    gh
    glab
    bat
    eza
    ripgrep
    protobuf
    jq
    yq
    fx
    fd
    tldr
    localstack
    lazydocker
    nixfmt-rfc-style
    mongosh

    #i3 Stuff
    sddm-chili-theme
    rofi
    picom
    polybar
    feh
    lxappearance

    brave

    nodejs
    go
    rustup
    spotify
    slack
    telegram-desktop
    xclip

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "Go-Mono"
        "Inconsolata"
        "InconsolataGo"
        "JetBrainsMono"
      ];
    })
    noto-fonts

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  stylix.enable = true;
  stylix.base16Scheme = {
    # -- base00 - Default Background
    base00 = "#15181A";
    # -- base01 - Lighter Background (Used for status bars, line number and folding marks)
    base01 = "#242a2d";
    # -- base02 - Selection Background
    base02 = "#3C4344";
    # -- base03 - Comments, Invisibles, Line Highlighting
    base03 = "#737A82";
    # -- base04 - Dark Foreground (Used for status bars)
    base04 = "#3C4344";
    # -- base05 - Default Foreground, Caret, Delimiters, Operators
    base05 = "#E1E3E6";
    # -- base06 - Light Foreground (Not often used)
    base06 = "#eceff3";
    # -- base07 - Light Background (Not often used)
    base07 = "#eceff3";
    # -- base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base08 = "#df9a98";
    # -- base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base09 = "#FFA474";
    # -- base0A - Classes, Markup Bold, Search Text Background
    base0A = "#FFD187";
    # -- base0B - Strings, Inherited Class, Markup Code, Diff Inserted
    base0B = "#93C394";
    # -- base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
    base0C = "#87afaf";
    # -- base0D - Functions, Methods, Attribute IDs, Headings
    base0D = "#80B6D7";
    # -- base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0E = "#dfbdbc";
    # -- base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    base0F = "#e9dbc2";
    base10 = "#242a2d";
    base11 = "#15181A";
    base12 = "#e07798";
    base13 = "#729973";
    base14 = "#5f8787";
    base15 = "#5e90af";
    base16 = "#af8787";
  };
  stylix.image = ./red-blue-wall.jpg;

  stylix.targets.neovim.enable = false;
  stylix.targets.lazygit.enable = false;

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      name = "JetBrainsMono Nerd Font";
    };

    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.ignoreDups = true;
    initExtraBeforeCompInit = "autoload bashcompinit && bashcompinit";
    initExtra = ''
      complete -C 'aws_completer' aws
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey \"^X^E\" edit-command-line
    '';
  };

  xdg.configFile = {
    "i3/config".text = builtins.readFile ./xdg/i3;
    "nvim/init.lua".text = builtins.readFile ./xdg/nvim.lua;
    "rofi/config.lua".text = builtins.readFile ./xdg/rofi.rasi;
    "rofi/theme.lua".text = builtins.readFile ./xdg/rofi-theme.rasi;

    "polybar/config.ini".text = ''
      [bar/minimal]
      height=3%
      radius=0
      width=100%

      dpi = 96

      background = ${colors.background}
      foreground = ${colors.foreground}

      font-0 = JetBrainsMono Nerd Font:size=22

      module-margin = 1
      padding-right = 1

      modules-center = date
      modules-left = xworkspaces xwindow
      modules-right =  memory cpu wlan eth

      [module/date]
      date=%d-%m.%y
      internal=5
      label=%time% %date%
      time=%H:%M
      type=internal/date

      [module/xworkspaces]
      type = internal/xworkspaces

      label-active = %name%
      label-active-background = ${colors.bright.white} 
      label-active-foreground = ${colors.foreground} 
      ; label-active-underline= "" 
      label-active-padding = 1

      label-occupied = %name%
      label-occupied-padding = 1

      label-urgent = %name%
      ; label-urgent-background = ""
      label-urgent-padding = 1

      label-empty = %name%
      ; label-empty-foreground = ""
      label-empty-padding = 1

      [module/xwindow]
      type = internal/xwindow
      label = %title:0:60:...%

      [module/memory]
      type = internal/memory
      interval = 2
      format-prefix = "RAM "
      format-prefix-foreground = ${colors.foreground}
      label = %percentage_used:2%%

      [module/cpu]
      type = internal/cpu
      interval = 2
      format-prefix = "CPU "
      format-prefix-foreground = ${colors.foreground}
      label = %percentage:2%%

      [network-base]
      type = internal/network
      interval = 5
      format-connected = <label-connected>
      format-disconnected = <label-disconnected>
      label-disconnected = %{F#F0C674}%ifname%%{F#707880} disconnected

      [module/wlan]
      inherit = network-base
      interface-type = wireless
      label-connected = %{F#F0C674}%ifname%%{F-} %essid%

      [module/eth]
      inherit = network-base
      interface-type = wired
      label-connected = %{F#F0C674}%ifname%%{F-} %local_ip%

    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 20;
          y = 20;
        };
      };
    };
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        enable_tab_bar = false,
        font_size = 24,
        window_padding = {
          left = 30,
          right = 30,
          top = 30,
          bottom = 30,
        },
      }
    '';
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    prefix = "C-a";
    escapeTime = 0;
    historyLimit = 5000;
    baseIndex = 1;
    terminal = "alacritty";
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''
      set -g pane-border-style 'fg=${colors.dim.white} bg=${colors.background}'
      set -g pane-active-border-style 'bg=#15181A fg=colour14'

      # statusbar
      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'bg=#15181A fg=colour7 dim'
      set -g status-left "" 

      set -g status-right "#S"

      setw -g window-status-current-style 'fg=colour7  bg=#15181A bold'
      setw -g window-status-current-format " #I:#W#F "

      setw -g window-status-style 'fg=colour7 bg=#15181A' 
      setw -g window-status-format ' #I:#W#F '
      setw -g window-status-bell-style 'fg=colour0 bg=colour7 bold'

      # messages
      set -g message-style 'fg=colour0 bg=colour3 bold'

      set-option -ga terminal-overrides ',alacritty:Tc'
    '';
  };

  fonts.fontconfig.enable = isLinux;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/cline/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    NPM_CONFIG_PREFIX = "~/.local";
  };

  home.shellAliases = {
    x = "exit";
    lg = "lazygit";
    hms = "home-manager switch";
    v = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.scripts"
  ];

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      final_space = true;
      version = 2;
      blocks = [
        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            {
              type = "path";
              style = "plain";
              foreground = "cyan";
              background = "transparent";
              properties = {
                style = "full";
              };
              template = "{{ .Path }} ";
            }
            {
              type = "git";
              style = "plain";
              background = "transparent";
              foreground = "#5b5f66";
              template = " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</> ";
              properties = {
                branch_icon = "";
                fetch_status = true;
                commit_icon = "@";
              };
            }
            {
              type = "aws";
              style = "plain";
              foreground = "yellow";
              background = "transparent";
              template = "  {{.Profile}}";
            }
          ];
        }

        {
          type = "rprompt";
          overflow = "hidden";
          alignment = "right";
          segments = [
            {
              type = "executiontime";
              style = "plain";
              foreground = "lightYellow";
              background = "transparent";
              template = "{{ .FormattedMs }}";
              properties = {
                threshold = 5000;
              };
            }
          ];
        }

        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [
            {
              type = "text";
              style = "plain";
              foreground_templates = [
                "{{if gt .Code 0}}red{{end}}"
                "{{if eq .Code 0}}blue{{end}}"
              ];
              template = "❯";
            }
          ];
        }
      ];
      transient_prompt = {
        background = "transparent";
        template = "❯ ";
        foreground_templates = [
          "{{if gt .Code 0}}red{{end}}"
          "{{if eq .Code 0}}blue{{end}}"
        ];
      };
    };
  };

  programs.fzf = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;
    defaultEditor = true;
  };

  programs.git = {
    enable = true;
    userEmail = "acline@precisionplanting.com";
    userName = "Andrew Cline";
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "nvim";
      };
      push.autoSetupRemote = true;
      url = {
        "ssh://git@git.2020.dev/" = {
          insteadOf = "https://git.2020.dev/";
        };
      };
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      disableStartupPopups = true;
    };
  };

  programs.awscli = {
    enable = true;
    package = pkgs.awscli2;
  };

  programs.ssh = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # gtk = {
  #   enable = isLinux;
  #   theme = {
  #     package = pkgs.flat-remix-gtk;
  #     name = "Flat-Remix-GTK-Grey-Darkest";
  #   };
  #   iconTheme = {
  #     package = pkgs.gnome.adwaita-icon-theme;
  #     name = "Adwaita";
  #   };
  #   font = {
  #     name = "Sans";
  #     size = 11;
  #   };
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
