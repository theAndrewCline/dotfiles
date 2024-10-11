{ pkgs, pkgs-unstable, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
  colors = import ./base16-theme.nix { };
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

    brave

    nodejs
    go
    rustup
    spotify
    slack
    telegram-desktop
    zoom-us
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
  stylix.base16Scheme = colors;
  stylix.image = ./images/leaves.jpg;
  stylix.fonts.sizes.desktop = 22;

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      name = "JetBrainsMono Nerd Font";
    };

    # TODO: Find new font
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };

    # TODO: Find new font
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

  # TODO: Figure out how to simlink nvim config for dyamic editting 
  xdg.configFile = {
    "i3/config".text = builtins.readFile ./xdg/i3;
    "nvim/init.lua".text = builtins.readFile ./xdg/nvim.lua;
  };

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        enable_tab_bar = false,
        font_size = 22,
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
    terminal = "xterm-256color";
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''
      # statusbar
      set -g status-position bottom
      set -g status-justify left
      set -g status-left "" 
      set -g status-right "#S"
      setw -g window-status-format ' #I:#W#F '

      set-option -a terminal-features 'xterm-256color:RGB'
    '';
  };

  fonts.fontconfig.enable = isLinux;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".scripts/o".source = ./scripts/o;
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
    userEmail = "andrew.cline77@gmail.com";
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

  programs.feh = {
    enable = true;
  };

  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "run,window,combi";
      display-combi = " 🖥️  All ";
      display-run = " 🏃  Run ";
      display-window = " 🪟  Window";
    };
  };

  services.picom = {
    enable = true;
    fade = true;
    fadeDelta = 2;
  };

  services.polybar = {
    enable = true;
    script = "polybar min &";
    config = {
      "bar/min" = {
        height = "3%";
        radius = 0;
        width = "100%";
        dpi = 96;
        bottom = false;
        module-margin = 1;
        padding-right = 1;
        modules-left = "xworkspaces xwindow";
        modules-right = "date";
        font-0 = "JetBrainsMono Nerd Font:size=18";
        background = colors.base00;
      };

      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%d.%m.%y";
        time = "%H:%M";
        label = "%time% %date%";
      };

      "module/xworkspaces" = {
        type = "internal/xworkspaces";

        label-active = "%name%";
        label-active-background = colors.base0C;
        label-active-padding = 1;

        label-occupied = "%name%";
        label-occupied-background = colors.base01;
        label-occupied-padding = 1;

        label-urgent = "%name%";
        label-urgent-background = colors.base09;
        label-urgent-padding = 1;

        label-empty = "%name%";
        label-empty-background = colors.base01;
        label-empty-padding = 1;
      };

      "module/xwindow" = {
        type = "internal/xwindow";
        label = "%title:0:60:...%";
        format-foreground = colors.base03;
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
