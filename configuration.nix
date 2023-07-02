# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "nixos"; # Define your hostname.
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Bahia";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    videoDrivers = [ "amdgpu" ];

    # i3 (and a fallback gnome, why not)
    windowManager.i3.enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    displayManager.defaultSession = "none+i3";

    enable = true;
    layout = "br";
    xkbVariant = "thinkpad";

    # Enable automatic login for the user.
    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "marcospb19";

    libinput = {
      # Enable touchpad support (enabled default in most desktopManager).
      enable = true;
      mouse.accelProfile = "flat";
      mouse.accelSpeed = null;
    };
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  security.sudo.extraRules = [
    {
      users = ["marcospb19"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"]; # "SETENV" # Adding the following could be a good idea
        }
      ];
    }
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marcospb19 = {
    isNormalUser = true;
    description = "João Marcos";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
    ];
  };

  users.defaultUserShell = pkgs.zsh;

  environment.shells = with pkgs; [zsh];

  programs = {
    steam.enable = true;

    zsh = {
      enable = true;
      # My aliases are actually inside of the .aliases file
      shellAliases = {
        update = "sudo nixos-rebuild switch";
      };
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
      };
      syntaxHighlighting.highlighters = ["main" "brackets"];
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      histSize = 50000;
    };
  };

  # environment.variables.LD_LIBRARY_PATH = lib.makeLibraryPath[ pkgs.openssl ];

  environment.systemPackages = with pkgs; [
    alejandra
    openssl.dev
    openssl
    pkgconfig
    pkg-config
    valgrind
    vscode
    mold
    blueberry
    dbus
    signal-desktop
    flameshot
    du-dust
    solaar
    obsidian
    xdragon
    sccache
    lorien
    libffi
    gnumake
    vim
    neovim
    wget
    curl
    feh
    man
    man-pages
    telegram-desktop
    sublime4-dev
    alacritty
    ripgrep
    fd
    hyperfine
    ouch
    bat
    google-chrome
    mupdf
    dmenu
    hexyl
    stow
    gcc
    networkmanagerapplet
    bottom
    spotify
    clang
    git
    clonehero
    python3
    python3Packages.ipython
    rustup
    zulip
    element-desktop
    pavucontrol
    discord
    delta
    evcxr
  ];

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    victor-mono
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  environment.localBinInPath = true;
  environment.variables = {
    OPENSSL_DEV = pkgs.openssl.dev;
    EDITOR = "nvim";
    BROWSER = "google-chrome-stable";
  };

  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1u"
  ];
}
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
# # Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };
# Enable the OpenSSH daemon.
# services.openssh.enable = true;
# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;
# If you want to use JACK applications, uncomment this
#services.pipewire.jack.enable = true;
# use the example session manager (no others are packaged yet so this is enabled by default,
# no need to redefine it in your config for now)
#services.pipewire.media-session.enable = true;

