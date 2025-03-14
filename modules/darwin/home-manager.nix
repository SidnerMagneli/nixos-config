{ config, pkgs, lib, home-manager, ... }:

let
  user = "ziggystardust";
  # Define the content of your file as a derivation
  sharedFiles = import ../shared/files.nix { inherit config pkgs; };
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  imports = [
   ./dock
  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix {};
    # onActivation.cleanup = "uninstall";

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # If you have previously added these apps to your Mac App Store profile (but not installed them on this system),
    # you may receive an error message "Redownload Unavailable with This Apple ID".
    # This message is safe to ignore. (https://github.com/dustinlyons/nixos-config/issues/83)

    masApps = {
      # "1password" = 1333542190;
      # "wireguard" = 1451685025;

      # does not seem to work, keep getting the above mentioned error, puttiong this here for reference.
      # "messenger" = 1451685025;
      "ghostery" = 6504861501;
    };
  };

  # Enable home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.${user} = { pkgs, config, lib, ... }:{
      home = {
        enableNixpkgsReleaseCheck = false;
        packages = pkgs.callPackage ./packages.nix {};
        file = lib.mkMerge [
          sharedFiles
          additionalFiles
        ];

        stateVersion = "23.11";
      };
      programs = {} // import ../shared/home-manager.nix { inherit config pkgs lib; };

      # Marked broken Oct 20, 2022 check later to remove this
      # https://github.com/nix-community/home-manager/issues/3344
      # Update 7 March 2025: seems to have been fixed
      # manual.manpages.enable = false;
    };
    backupFileExtension = "nixbackup";
  };

  # Fully declarative dock using the latest from Nix Store
  local = { 
    dock = {
      enable = true;
      entries = [
        { path = "/Applications/Bitwig Studio.app/"; }
        { path = "/Applications/WhatsApp.app/"; }
        # { path = "/System/Applications/Find My.app/"; }
        { path = "/System/Applications/Photos.app/"; }
        { path = "/System/Applications/Messages.app/"; }
        { path = "/System/Applications/Facetime.app/"; }
        { path = "/System/Applications/Calendar.app/"; }
        { path = "/System/Applications/Reminders.app/"; }
        { path = "/Applications/Safari.app"; }
        { path = "/Applications/Spotify.app/"; }
        { path = "/Applications/Microsoft Outlook.app/"; }
        { path = "/Applications/Slack.app/"; }
        { path = "/Applications/Notion.app/"; }
        { path = "/Applications/Visual Studio Code.app/"; }
        {
          path = "${config.users.users.${user}.home}/downloads";
          section = "others";
          options = "--sort name --view grid --display stack";
        }
      ];
    };
  };
}
