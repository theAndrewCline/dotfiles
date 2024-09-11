{ config, pkgs, ... }:

let
  unstable = import <unstable> { config.allowUnfree = true; };
  stable = import <stable> { config.allowUnfree = true; };

in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "acline";
  home.homeDirectory = "/home/acline";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.stow
    pkgs.openssl
    pkgs.httpie
    pkgs.atuin
    pkgs.nodejs
    pkgs.pnpm
    pkgs.deno
    pkgs.yarn-berry
    pkgs.mods
    pkgs.go
    pkgs.rustup
    pkgs.marksman
    pkgs.gopls
    pkgs.nodePackages.prettier
    pkgs.nodePackages.typescript-language-server
    pkgs.vscode-langservers-extracted
    pkgs.postgresql_14
    pkgs.nil
    pkgs.speedtest-rs
    pkgs.monaspace
    pkgs.gh
    pkgs.glab
    pkgs.bat
    pkgs.eza
    pkgs.ripgrep
    pkgs.protobuf
    pkgs.jq
    pkgs.yq
    pkgs.fx
    pkgs.fd
    pkgs.tldr
    pkgs.localstack
    stable.lazydocker
    pkgs.nixfmt

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  fonts.fontconfig.enable = true;

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

  home.sessionPath = [ "$HOME/.local/bin" "$HOME/go/bin" "$HOME/.scripts" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history.ignoreDups = true;
    initExtraBeforeCompInit = "autoload bashcompinit && bashcompinit";
    initExtra =
      "\n      complete -C 'aws_completer' aws\n      autoload -z edit-command-line\n      zle -N edit-command-line\n      bindkey \"^X^E\" edit-command-line\n    ";
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "$schema" =
        "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
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
              properties = { style = "full"; };
              template = "{{ .Path }} ";
            }
            {
              type = "git";
              style = "plain";
              background = "transparent";
              foreground = "#5b5f66";
              template =
                " {{ .HEAD }}{{ if or (.Working.Changed) (.Staging.Changed) }}*{{ end }} <cyan>{{ if gt .Behind 0 }}⇣{{ end }}{{ if gt .Ahead 0 }}⇡{{ end }}</> ";
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
          segments = [{
            type = "executiontime";
            style = "plain";
            foreground = "lightYellow";
            background = "transparent";
            template = "{{ .FormattedMs }}";
            properties = { threshold = 5000; };
          }];
        }

        {
          type = "prompt";
          alignment = "left";
          newline = true;
          segments = [{
            type = "text";
            style = "plain";
            foreground_templates =
              [ "{{if gt .Code 0}}red{{end}}" "{{if eq .Code 0}}blue{{end}}" ];
            template = "❯";
          }];
        }
      ];
      transient_prompt = {
        background = "transparent";
        template = "❯ ";
        foreground_templates =
          [ "{{if gt .Code 0}}red{{end}}" "{{if eq .Code 0}}blue{{end}}" ];
      };
    };
  };

  programs.fzf = { enable = true; };

  programs.helix = {
    enable = true;
    defaultEditor = false;
    settings = {
      theme = "custom";
      editor = {
        line-number = "relative";
        auto-format = true;
        bufferline = "always";
        cursor-shape.insert = "bar";
        statusline.center = [ "version-control" ];
        soft-wrap.enable = true;
        lsp = {
          # display-inlay-hints = true;
          display-messages = true;
        };
        file-picker.hidden = false;
      };
    };
    themes = {
      custom = {
        inherits = "base16_transparent";
        attribute = "blue";
        function = "light-blue";
        "function.method" = "light-green";
        "variable" = "white";
        "variable.other.member" = "cyan";
        string = "light-yellow";
        "string.special" = "light-green";
        comment = "green";
        "comment.modifiers" = [ "italic" ];
        "ui.linenr" = "white dim";
      };
    };
    languages = {
      # language-server.deno-lsp = {
      #   command = "deno";
      #   args = ["lsp"];
      #   config.deno.enable = true;
      # };
      language = [
        # {
        #   name = "typescript";
        #   scope = "source.ts";
        #   shebangs = ["deno"];
        #   roots = ["deno.json" "deno.jsonc"];
        #   file-types = ["ts" "js" "tsx"];
        #   language-servers = ["deno-lsp"];
        #   auto-format = true;
        # }

        {
          name = "typescript";
          formatter = {
            command = "prettier";
            args = [ "--parser" "typescript" ];
          };
          auto-format = true;
        }

        {
          name = "tsx";
          formatter = {
            command = "prettier";
            args = [ "--parser" "typescript" ];
          };
          auto-format = true;
        }

        {
          name = "javascript";
          formatter = {
            command = "prettier";
            args = [ "--parser" "javascript" ];
          };
          auto-format = true;
        }

        {
          name = "javascript";
          formatter = {
            command = "prettier";
            args = [ "--parser" "javascript" ];
          };
          auto-format = true;
        }

        {
          name = "html";
          formatter = {
            command = "prettier";
            args = [ "--parser" "html" ];
          };
          auto-format = true;
        }

        {
          name = "json";
          formatter = {
            command = "prettier";
            args = [ "--parser" "json" ];
          };
          auto-format = true;
        }

        {
          name = "rust";
          auto-format = true;
          language-servers = [ "rust-analyzer" ];
        }
      ];
    };
  };

  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped; 
    defaultEditor = true;
  };

  programs.git = {
    enable = true;
    userEmail = "acline@precisionplanting.com";
    userName = "Andrew Cline";
    extraConfig = {
      init.defaultBranch = "main";
      core = { editor = "nvim"; };
      push.autoSetupRemote = true;
      url = {
        "ssh://git@git.2020.dev/" = { insteadOf = "https://git.2020.dev/"; };
      };
    };
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    prefix = "C-a";
    escapeTime = 0;
    historyLimit = 5000;
    baseIndex = 1;
    terminal = "tmux-256color";
    plugins = with pkgs; [ tmuxPlugins.yank tmuxPlugins.vim-tmux-navigator ];
    extraConfig =
      "\n        set -g pane-border-style 'fg=colour7 bg=#15181A'\n        set -g pane-active-border-style 'bg=#15181A fg=colour14'\n\n        # statusbar\n        set -g status-position bottom\n        set -g status-justify left\n        set -g status-style 'bg=#15181A fg=colour7 dim' # 'dim' maybe added here\n        set -g status-left \"\"\n\n        set -g status-right \"#S\"\n\n        setw -g window-status-current-style 'fg=colour7  bg=#15181A bold'\n        setw -g window-status-current-format \" #I:#W#F \"\n\n        setw -g window-status-style 'fg=colour7 bg=#15181A' \n        setw -g window-status-format ' #I:#W#F '\n        set-option -a terminal-features 'xterm-256color:RGB'\n\n        setw -g window-status-bell-style 'fg=colour0 bg=colour7 bold'\n\n        # messages\n        set -g message-style 'fg=colour0 bg=colour3 bold'\n\n    ";
  };

  programs.lazygit = {
    enable = true;
    settings = { disableStartupPopups = true; };
  };

  programs.awscli = {
    enable = true;
    package = stable.awscli2;
  };

  programs.ssh = { enable = true; };

  programs.yazi = { enable = true; };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
