{ config
, pkgs
, name
, devenv
, inputs
, ...
}:

{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  environment = {
    # etc."hosts" = {          # PHP is _extremely slow_ with executing commands without this
    #   copy = true;
    #   text = ''
    #     ::1             localhost
    #     127.0.0.1       localhost
    #     255.255.255.255 broadcasthost

    #     127.0.0.1       webdev.test
    #   '';
    # };
    shells = with pkgs; [ zsh ];          # Default shell
    variables = {                         # System variables
      EDITOR = "hx";
      VISUAL = "hx";
    };
    shellAliases = {
      resolve = "seq $(jj resolve --list | grep -c .) | xargs -I{} jj resolve";
    };
  };

  homebrew = {                            # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = true;                 # Auto update packages
      upgrade = false;
      cleanup = "zap";                    # Uninstall not listed packages and casks
    };
  }; 

  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    settings = {
      trusted-users = [
        "root"
        "yamashita"
        "work"
      ];
    };
  };
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Darwin settings
  system = {
    activationScripts.extraActivation.text = ''
	softwareupdate --install-rosetta --agree-to-license
    '';
    defaults = {
      dock = {
        autohide = true;
        appswitcher-all-displays = true;
      };

      finder = {
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
        FXDefaultSearchScope = "SCcf";
        FXPreferredViewStyle = "Nlsv";
      };

      NSGlobalDomain = {
        "com.apple.sound.beep.volume" = 0.6065307;
        _HIHideMenuBar = false;
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
        ApplePressAndHoldEnabled = false;
        AppleTemperatureUnit = "Celsius";
        InitialKeyRepeat = 15;
        KeyRepeat = 1;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSTableViewDefaultSizeMode = 2;
      };

      trackpad = {
        ActuationStrength = 0; # silent clicking
        FirstClickThreshold = 0; # light clicking
        SecondClickThreshold = 0; # light force touch
        Clicking = true;
        TrackpadRightClick = true;
      };
    };

    keyboard.enableKeyMapping = true;
  };
  
  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina

  system.stateVersion = 4;
}
