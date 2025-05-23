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

      jj-kebab = ''
        jj-kebab() {
          local rev="''${1:-@-}"
          jj log -r "''${rev}" --no-graph -T "(description)" \
            | sed 's|: |/|' \
            | tr '[:upper:]' '[:lower:]' \
            | tr ' ' '-'
        }
        jj-kebab
      '';
    };
  };

  homebrew = {                            # Declare Homebrew using Nix-Darwin
    enable = true;
    onActivation = {
      autoUpdate = false;                 # Auto update packages
      upgrade = false;
      cleanup = "zap";                    # Uninstall not listed packages and casks
    };
  }; 

  # security.pam.services.sudo_local.touchIdAuth = true;

  nix = {
    enable = false;
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
