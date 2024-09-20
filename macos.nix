{ pkgs, pkgs-unstable, ... }:

let
  colors = import ./colors.nix { };

in
{
  imports = [ ];

  nixpkgs.config.allowUnfree = true;
  stylix.enable = true;
  stylix.base16Scheme = {
    # -- base00 - Default Background
    base00 = "#15181A";
    # -- base01 - Lighter Background (Used for status bars, line number and folding marks)
    base01 = "#15181A";
    # -- base02 - Selection Background
    base02 = "#3C4344";
    # -- base03 - Comments, Invisibles, Line Highlighting
    base03 = "#737A82";
    # -- base04 - Dark Foreground (Used for status bars)
    base04 = "#737A82";
    # -- base05 - Default Foreground, Caret, Delimiters, Operators
    base05 = "#E1E3E6";
    # -- base06 - Light Foreground (Not often used)
    base06 = "#3C4344";
    # -- base07 - Light Background (Not often used)
    base07 = "#15181A";
    # -- base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
    base08 = "#D0CAC9";
    # -- base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
    base09 = "#FFA474";
    # -- base0A - Classes, Markup Bold, Search Text Background
    base0A = "#FFD187";
    # -- base0B - Strings, Inherited Class, Markup Code, Diff Inserted
    base0B = "#93C394";
    # -- base0C - Support, Regular Expressions, Escape Characters, Markup Quotes
    base0C = "#80B6D7";
    # -- base0D - Functions, Methods, Attribute IDs, Headings
    base0D = "#FFD187";
    # -- base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
    base0E = "#DFB0B0";
    # -- base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
    base0F = "#E7E3E2";
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

  home.username = "cline";
  home.homeDirectory = "/Users/cline";
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
    raycast

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

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
    "nvim/init.lua".text = builtins.readFile ./xdg/nvim.lua;
  };

  programs.wezterm.enable = true;

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
    terminal = "screen-256color";
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.vim-tmux-navigator
    ];
    extraConfig = ''

      # statusbar
      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'bg=#15181A fg=colour7 dim'
      set -g status-left "" 
      set -g status-right "#S"
      setw -g window-status-format ' #I:#W#F '

      set-option -a terminal-features 'xterm-256color:RGB'
    '';
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
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
              foreground = "lightblack";
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
    settings = import ./aws_configs.nix;
  };

  programs.ssh = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}
