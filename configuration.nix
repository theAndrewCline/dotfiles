# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let

in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sleepydesktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  # SOUND
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    # dpi = 196;
    # upscaleDefaultCursor = true;
    xkb = { };
    videoDrivers = [ "nvidia" ];
    windowManager.i3.enable = true;
  };

  services.displayManager = {
    defaultSession = "none+i3";
    sddm = {
      enable = true;
      enableHidpi = true;
      theme = "chili";
    };
  };

  environment.variables = {
    # GDK_SCALE = "2.2"; # default 1 I think
    # GDK_DPI_SCALE = "0.4"; # default 1 I think
    # _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2.2"; # default 1 I think
    # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # XCURSOR_SIZE = "64"; # default 16 I think
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.acline = {
    isNormalUser = true;
    description = "Andrew Cline";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "docker"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ discord ];
  };

  # home-manager.users.acline = import ./modules/home.nix {
  #   pkgs = pkgs;
  #   unstablePkgs = unstable.pkgs;
  # };
  # home-manager.backupFileExtension = "bak";

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git

    unzip
    zip
    gcc
    alacritty

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
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "Go-Mono"
        "Inconsolata"
        "InconsolataGo"
        "JetBrainsMono"
      ];
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
  programs.dconf.enable = true;

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
